import SwiftUI
import CoreData
import CloudKit
import Combine

// MARK: - Offline Manager
class OfflineManager: ObservableObject {
    static let shared = OfflineManager()
    
    @Published var pendingSyncCount: Int = 0
    @Published var isSyncing: Bool = false
    @Published var lastSyncDate: Date?
    @Published var syncStatus: SyncStatus = .idle
    
    private var cancellables = Set<AnyCancellable>()
    private let container: NSPersistentCloudKitContainer
    private let networkMonitor = NetworkMonitor.shared
    
    enum SyncStatus {
        case idle
        case syncing
        case success
        case failed(String)
        
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
            case .syncing: return "🔄"
            case .success: return "✅"
            case .failed: return "❌"
            }
        }
    }
    
    private init() {
        self.container = PersistenceController.shared.container
        setupOfflineMonitoring()
        setupNetworkReconnectionHandler()
    }
    
    // MARK: - Setup
    private func setupOfflineMonitoring() {
        // Monitor network status changes
        networkMonitor.$isConnected
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.handleNetworkReconnection()
                } else {
                    self?.handleNetworkDisconnection()
                }
            }
            .store(in: &cancellables)
        
        // Listen for connection restored notification
        NotificationCenter.default.publisher(for: .networkConnectionRestored)
            .sink { [weak self] _ in
                self?.triggerCloudKitSync()
            }
            .store(in: &cancellables)
        
        // Monitor Core Data saves for pending sync count
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] notification in
                self?.updatePendingSyncCount(from: notification)
            }
            .store(in: &cancellables)
        
        print("💾 OfflineManager: Sistema offline inicializado")
    }
    
    private func setupNetworkReconnectionHandler() {
        // Monitor CloudKit events for sync status
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink { [weak self] notification in
                self?.handleCloudKitEvent(notification)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Network Event Handlers
    private func handleNetworkReconnection() {
        guard networkMonitor.hasBeenOffline else { return }
        
        print("🌐 ✅ Red reconectada - Preparando sincronización offline")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.triggerCloudKitSync()
        }
    }
    
    private func handleNetworkDisconnection() {
        print("🌐 ❌ Red desconectada - Activando modo offline")
        print("💾 Los entrenamientos se guardarán localmente")
        
        DispatchQueue.main.async {
            self.syncStatus = .idle
            self.isSyncing = false
        }
    }
    
    // MARK: - CloudKit Sync Management
    private func triggerCloudKitSync() {
        guard networkMonitor.isConnected else {
            print("❌ No se puede sincronizar: Sin conexión a internet")
            return
        }
        
        print("🔄 Iniciando sincronización CloudKit después de reconexión...")
        
        DispatchQueue.main.async {
            self.isSyncing = true
            self.syncStatus = .syncing
        }
        
        // Force CloudKit to attempt sync by saving the context
        let context = container.viewContext
        
        do {
            if context.hasChanges {
                try context.save()
                print("💾 Context guardado - CloudKit sincronizará automáticamente")
            } else {
                // Even if no changes, this can trigger a sync check
                try context.save()
                print("🔄 Trigger de sincronización enviado a CloudKit")
            }
        } catch {
            print("❌ Error al trigger sincronización: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.syncStatus = .failed(error.localizedDescription)
                self.isSyncing = false
            }
        }
    }
    
    // MARK: - CloudKit Event Handling
    private func handleCloudKitEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let event = userInfo[NSPersistentCloudKitContainer.eventChangedNotification] as? NSPersistentCloudKitContainer.Event else {
            return
        }
        
        DispatchQueue.main.async {
            self.processCloudKitSyncEvent(event)
        }
    }
    
    private func processCloudKitSyncEvent(_ event: NSPersistentCloudKitContainer.Event) {
        switch event.type {
        case .import:
            if let error = event.error {
                print("❌ CloudKit Import Error: \(error.localizedDescription)")
                syncStatus = .failed("Import failed")
                isSyncing = false
            } else {
                print("📥 CloudKit Import Success: Datos recibidos desde iCloud")
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
                }
            }
            
        case .export:
            if let error = event.error {
                print("❌ CloudKit Export Error: \(error.localizedDescription)")
                syncStatus = .failed("Export failed")
                isSyncing = false
            } else {
                print("📤 CloudKit Export Success: Datos enviados a iCloud")
                if isSyncing {
                    syncStatus = .success
                    lastSyncDate = Date()
                    pendingSyncCount = 0 // Reset pending count on successful export
                    
                    // Continue syncing to check for imports
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.isSyncing = false
                        
                        // Auto-hide success status after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            if case .success = self.syncStatus {
                                self.syncStatus = .idle
                            }
                        }
                    }
                }
            }
            
        case .setup:
            print("⚙️ CloudKit Setup: Configuración completada")
            
        @unknown default:
            print("❓ CloudKit Event desconocido: \(event.type)")
        }
    }
    
    // MARK: - Pending Sync Count Management
    private func updatePendingSyncCount(from notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext,
              context == container.viewContext else { return }
        
        // Only count as pending if we're offline
        if !networkMonitor.isConnected {
            if let userInfo = notification.userInfo,
               let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                
                let workoutInserts = insertedObjects.compactMap { $0 as? WorkoutEntity }
                if !workoutInserts.isEmpty {
                    DispatchQueue.main.async {
                        self.pendingSyncCount += workoutInserts.count
                        print("💾 Entrenamientos pendientes de sync: \(self.pendingSyncCount)")
                    }
                }
            }
        } else {
            // If we're online, successful saves mean sync is happening
            print("🔄 Guardado online - CloudKit sincronizará automáticamente")
        }
    }
    
    // MARK: - Manual Sync Trigger
    func forceSyncIfConnected() {
        guard networkMonitor.isConnected else {
            print("❌ Sync manual: Sin conexión a internet")
            return
        }
        
        print("🔄 Sync manual iniciado por usuario")
        triggerCloudKitSync()
    }
    
    // MARK: - Offline Data Management
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
            
            if networkMonitor.isConnected {
                print("🔄 Entrenamiento guardado y enviado a CloudKit: \(type)")
            } else {
                print("💾 Entrenamiento guardado offline: \(type)")
                print("📋 Se sincronizará cuando regrese la conexión")
                
                DispatchQueue.main.async {
                    self.pendingSyncCount += 1
                }
            }
            
            return true
        } catch {
            print("❌ Error al guardar entrenamiento: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - Sync Status Card UI
struct SyncStatusCard: View {
    @ObservedObject var offlineManager = OfflineManager.shared
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Estado de Sincronización")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Status icon
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    if offlineManager.isSyncing {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: statusColor))
                    } else {
                        Text(offlineManager.syncStatus.emoji)
                            .font(.system(size: 18))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(offlineManager.syncStatus.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    if offlineManager.pendingSyncCount > 0 {
                        Text("\(offlineManager.pendingSyncCount) entrenamientos pendientes")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    
                    if let lastSync = offlineManager.lastSyncDate {
                        Text("Última sync: \(formatTime(lastSync))")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if networkMonitor.isConnected && !offlineManager.isSyncing {
                    Button("Sincronizar") {
                        offlineManager.forceSyncIfConnected()
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
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(statusColor.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var statusColor: Color {
        switch offlineManager.syncStatus {
        case .idle:
            return networkMonitor.isConnected ? .blue : .orange
        case .syncing:
            return .blue
        case .success:
            return .green
        case .failed:
            return .red
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}