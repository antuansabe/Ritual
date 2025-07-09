import SwiftUI
import Network
import CoreData
import CloudKit
import Combine

// MARK: - Unified Sync Monitor
/// Sistema consolidado que unifica NetworkMonitor, CloudKitSyncMonitor y OfflineManager
/// Reduce overhead de múltiples observadores y centraliza toda la lógica de red/sync
class UnifiedSyncMonitor: ObservableObject {
    static let shared = UnifiedSyncMonitor()
    
    // MARK: - Network Status
    @Published var isConnected = false
    @Published var connectionType: ConnectionType = .none
    @Published var hasBeenOffline = false
    
    // MARK: - Sync Status
    @Published var syncStatus: SyncStatus = .idle
    @Published var pendingSyncCount: Int = 0
    @Published var lastSyncDate: Date?
    @Published var isSyncing: Bool = false
    @Published var errorMessage: String?
    @Published var showingAlert = false
    
    // MARK: - Private Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "UnifiedSyncMonitor", qos: .utility)
    private var cancellables = Set<AnyCancellable>()
    private let container: NSPersistentCloudKitContainer
    
    // MARK: - Enums
    enum ConnectionType {
        case wifi, cellular, ethernet, none
        
        var description: String {
            switch self {
            case .wifi: return "WiFi"
            case .cellular: return "Celular" 
            case .ethernet: return "Ethernet"
            case .none: return "Sin conexión"
            }
        }
        
        var emoji: String {
            switch self {
            case .wifi: return "[U+1F4F6]"
            case .cellular: return "[U+1F4F1]"
            case .ethernet: return "[U+1F310]"
            case .none: return "[ERR]"
            }
        }
    }
    
    enum SyncStatus {
        case idle, syncing, success, failed(String)
        
        var description: String {
            switch self {
            case .idle: return "En espera"
            case .syncing: return "Sincronizando..."
            case .success: return "Sincronización exitosa"
            case .failed(let error): return "Error: \(error)"
            }
        }
        
        var emoji: String {
            switch self {
            case .idle: return "⏱️"
            case .syncing: return "[SYNC]"
            case .success: return "[OK]"
            case .failed: return "[ERR]"
            }
        }
        
        var color: Color {
            switch self {
            case .idle: return .gray
            case .syncing: return .orange
            case .success: return .green
            case .failed: return .red
            }
        }
    }
    
    // MARK: - Initialization
    private init() {
        self.container = PersistenceController.shared.container
        setupUnifiedMonitoring()
        print("[U+1F310] UnifiedSyncMonitor: Sistema consolidado iniciado")
    }
    
    // MARK: - Setup
    private func setupUnifiedMonitoring() {
        setupNetworkMonitoring()
        setupCloudKitMonitoring()
        setupCoreDataMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.handleNetworkChange(path: path)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func setupCloudKitMonitoring() {
        // Monitor CloudKit events
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleRemoteChange(notification)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .NSPersistentCloudKitContainerEventChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleCloudKitEvent(notification)
            }
            .store(in: &cancellables)
        
        // Connection restored handler
        NotificationCenter.default.publisher(for: .networkConnectionRestored)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.triggerCloudKitSync()
            }
            .store(in: &cancellables)
    }
    
    private func setupCoreDataMonitoring() {
        // Monitor Core Data saves for pending sync count
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.updatePendingSyncCount(from: notification)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Network Event Handling
    private func handleNetworkChange(path: NWPath) {
        let wasConnected = isConnected
        isConnected = path.status == .satisfied
        
        // Update connection type
        updateConnectionType(from: path)
        
        // Handle connection state changes
        if !wasConnected && isConnected {
            handleConnectionRestored()
        } else if wasConnected && !isConnected {
            handleConnectionLost()
        }
        
        // Track offline state
        if !wasConnected && !isConnected {
            hasBeenOffline = true
        }
        
        logNetworkChange(wasConnected: wasConnected, currentStatus: path.status)
    }
    
    private func updateConnectionType(from path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .none
        }
    }
    
    private func handleConnectionRestored() {
        print("[U+1F310] [OK] Red CONECTADA - Tipo: \(connectionType.emoji) \(connectionType.description)")
        
        // Trigger sync if we were offline
        if hasBeenOffline {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.triggerCloudKitSync()
            }
            
            // Notify other components
            NotificationCenter.default.post(
                name: .networkConnectionRestored,
                object: nil,
                userInfo: ["connectionType": connectionType.description]
            )
        }
    }
    
    private func handleConnectionLost() {
        print("[U+1F310] [ERR] Red DESCONECTADA - Modo offline activado")
        print("[U+1F4BE] Los datos se guardarán localmente hasta reconectar")
        
        syncStatus = .idle
        isSyncing = false
    }
    
    private func logNetworkChange(wasConnected: Bool, currentStatus: NWPath.Status) {
        let isCurrentlyConnected = currentStatus == .satisfied
        
        if !wasConnected && isCurrentlyConnected {
            print("[SYNC] Iniciando sincronización automática CloudKit...")
        } else if isCurrentlyConnected {
            print("[U+1F310] [U+1F4E1] Cambio de red - Tipo: \(connectionType.emoji) \(connectionType.description)")
        }
    }
    
    // MARK: - CloudKit Event Handling
    private func handleRemoteChange(_ notification: Notification) {
        print("[U+1F4E1] CloudKit: Cambios remotos detectados")
        
        if let store = notification.object as? NSPersistentStore {
            print("[U+1F4E1] Store afectado: \(store.identifier ?? "Unknown")")
        }
        
        // Refresh sync status after remote changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkCloudKitStatus()
        }
    }
    
    private func handleCloudKitEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let event = userInfo[NSPersistentCloudKitContainerEventChangedNotification] as? NSPersistentCloudKitContainer.Event else {
            return
        }
        
        processCloudKitEvent(event)
    }
    
    private func processCloudKitEvent(_ event: NSPersistentCloudKitContainer.Event) {
        print("[U+1F329]️ CloudKit Event: \(event.type.description)")
        
        switch event.type {
        case .setup:
            print("[U+1F329]️ CloudKit: Configuración completada")
            
        case .import:
            if let error = event.error {
                print("[ERR] CloudKit Import Error: \(error.localizedDescription)")
                syncStatus = .failed("Import failed")
                showError("Error al importar de iCloud: \(error.localizedDescription)")
            } else {
                print("[U+1F4E5] CloudKit Import Success: Datos recibidos desde iCloud")
                handleSyncSuccess()
            }
            
        case .export:
            if let error = event.error {
                print("[ERR] CloudKit Export Error: \(error.localizedDescription)")
                syncStatus = .failed("Export failed")
                showError("Error al exportar a iCloud: \(error.localizedDescription)")
            } else {
                print("[U+1F4E4] CloudKit Export Success: Datos enviados a iCloud")
                pendingSyncCount = 0 // Reset pending count
                handleSyncSuccess()
            }
            
        @unknown default:
            print("❓ CloudKit Event desconocido: \(event.type)")
        }
    }
    
    private func handleSyncSuccess() {
        if isSyncing {
            syncStatus = .success
            lastSyncDate = Date()
            isSyncing = false
            
            // Auto-hide success status after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if case .success = self.syncStatus {
                    self.syncStatus = .idle
                }
            }
            
            // Reset offline flag after successful sync
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.hasBeenOffline = false
            }
        }
    }
    
    // MARK: - Sync Management
    func triggerCloudKitSync() {
        guard isConnected else {
            print("[ERR] No se puede sincronizar: Sin conexión a internet")
            return
        }
        
        print("[SYNC] Iniciando sincronización CloudKit...")
        
        isSyncing = true
        syncStatus = .syncing
        
        let context = container.viewContext
        
        do {
            try context.save()
            print("[U+1F4BE] Context guardado - CloudKit sincronizará automáticamente")
        } catch {
            print("[ERR] Error al trigger sincronización: \(error.localizedDescription)")
            syncStatus = .failed(error.localizedDescription)
            isSyncing = false
            showError("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    func checkCloudKitAccountStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("[U+1F534] CloudKit Account Error: \(error.localizedDescription)")
                    self?.syncStatus = .failed("Error de cuenta iCloud")
                    self?.showError("Error de cuenta iCloud: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .available:
                    print("[OK] CloudKit Account: Available")
                    self?.checkCloudKitStatus()
                case .noAccount:
                    print("[U+1F534] CloudKit Account: No iCloud account")
                    self?.syncStatus = .failed("No hay cuenta iCloud")
                    self?.showError("No se encontró cuenta iCloud")
                case .restricted:
                    print("[U+1F534] CloudKit Account: Restricted")
                    self?.syncStatus = .failed("Cuenta iCloud restringida")
                case .couldNotDetermine:
                    print("[U+1F534] CloudKit Account: Could not determine")
                    self?.syncStatus = .failed("No se pudo determinar estado iCloud")
                case .temporarilyUnavailable:
                    print("[U+1F7E1] CloudKit Account: Temporarily unavailable")
                    self?.syncStatus = .failed("iCloud temporalmente no disponible")
                @unknown default:
                    print("[U+1F534] CloudKit Account: Unknown status")
                    self?.syncStatus = .failed("Estado iCloud desconocido")
                }
            }
        }
    }
    
    private func checkCloudKitStatus() {
        let context = container.viewContext
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        request.fetchLimit = 5
        
        do {
            let workouts = try context.fetch(request)
            print("[U+1F4CA] Entrenamientos locales: \(workouts.count)")
            
            // Update sync status based on data availability
            if workouts.isEmpty {
                syncStatus = .idle
            } else {
                syncStatus = .success
                lastSyncDate = Date()
            }
        } catch {
            print("[U+1F534] Error fetching workouts: \(error.localizedDescription)")
            syncStatus = .failed("Error al obtener datos")
        }
    }
    
    // MARK: - Offline Data Management
    private func updatePendingSyncCount(from notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext,
              context == container.viewContext else { return }
        
        // Only count as pending if we're offline
        if !isConnected {
            if let userInfo = notification.userInfo,
               let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                
                let workoutInserts = insertedObjects.compactMap { $0 as? WorkoutEntity }
                if !workoutInserts.isEmpty {
                    pendingSyncCount += workoutInserts.count
                    print("[U+1F4BE] Entrenamientos pendientes de sync: \(pendingSyncCount)")
                }
            }
        } else {
            print("[SYNC] Guardado online - CloudKit sincronizará automáticamente")
        }
    }
    
    func saveWorkoutOffline(type: String, duration: Int32, calories: Int32) -> Bool {
        let context = container.viewContext
        
        let workout = WorkoutEntity(context: context)
        workout.id = UUID()
        workout.type = type
        workout.duration = duration
        workout.date = Date()
        workout.calories = calories
        
        do {
            try context.save()
            
            if isConnected {
                print("[SYNC] Entrenamiento guardado y enviado a CloudKit: \(type)")
            } else {
                print("[U+1F4BE] Entrenamiento guardado offline: \(type)")
                pendingSyncCount += 1
            }
            
            return true
        } catch {
            print("[ERR] Error al guardar entrenamiento: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Helper Methods
    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let networkConnectionRestored = Notification.Name("networkConnectionRestored")
}

// MARK: - CloudKit Event Type Extension
extension NSPersistentCloudKitContainer.Event.EventType {
    var description: String {
        switch self {
        case .setup: return "Setup"
        case .import: return "Import"
        case .export: return "Export"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Unified Status UI Components
struct UnifiedNetworkStatusBanner: View {
    @ObservedObject var monitor = UnifiedSyncMonitor.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if !monitor.isConnected {
                offlineBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
            } else if monitor.hasBeenOffline {
                syncingBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: monitor.isConnected)
        .animation(.easeInOut(duration: 0.5), value: monitor.hasBeenOffline)
    }
    
    private var offlineBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Modo Offline")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Los datos se sincronizarán cuando regrese la conexión")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            if monitor.pendingSyncCount > 0 {
                Text("\(monitor.pendingSyncCount)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color.orange, Color.red.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    private var syncingBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Conexión Restaurada")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Sincronizando datos con iCloud...")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            ProgressView()
                .scaleEffect(0.8)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color.green, Color.blue.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

struct UnifiedStatusCard: View {
    @ObservedObject var monitor = UnifiedSyncMonitor.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Network Status Section
            HStack {
                Text("Estado de Red y Sincronización")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            // Network connection status
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(monitor.isConnected ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(monitor.isConnected ? .green : .red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(monitor.isConnected ? "Conectado" : "Desconectado")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(monitor.connectionType.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(monitor.connectionType.emoji)
                    .font(.system(size: 28))
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Sync status section
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(monitor.syncStatus.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    if monitor.isSyncing {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: monitor.syncStatus.color))
                    } else {
                        Text(monitor.syncStatus.emoji)
                            .font(.system(size: 18))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(monitor.syncStatus.description)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if monitor.pendingSyncCount > 0 {
                        Text("\(monitor.pendingSyncCount) entrenamientos pendientes")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    
                    if let lastSync = monitor.lastSyncDate {
                        Text("Última sync: \(formatTime(lastSync))")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if monitor.isConnected && !monitor.isSyncing {
                    Button("Sincronizar") {
                        monitor.triggerCloudKitSync()
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            monitor.isConnected ? Color.green.opacity(0.3) : Color.orange.opacity(0.3),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("CloudKit Error", isPresented: $monitor.showingAlert) {
            Button("OK") {
                monitor.showingAlert = false
            }
        } message: {
            Text(monitor.errorMessage ?? "Error desconocido")
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}