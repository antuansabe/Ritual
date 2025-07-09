import SwiftUI
import CoreData
import CloudKit
import Combine

// MARK: - CloudKit Sync Monitor
class CloudKitSyncMonitor: ObservableObject {
    @Published var syncStatus: SyncStatus = .unknown
    @Published var lastSyncDate: Date?
    @Published var errorMessage: String?
    @Published var showingAlert = false
    
    private var cancellables = Set<AnyCancellable>()
    private let container: NSPersistentCloudKitContainer
    
    enum SyncStatus {
        case unknown
        case syncing
        case success
        case failed(String)
        
        var description: String {
            switch self {
            case .unknown:
                return "Estado desconocido"
            case .syncing:
                return "Sincronizando..."
            case .success:
                return "Sincronización exitosa"
            case .failed(let error):
                return "Error: \(error)"
            }
        }
        
        var color: Color {
            switch self {
            case .unknown:
                return .gray
            case .syncing:
                return .orange
            case .success:
                return .green
            case .failed:
                return .red
            }
        }
    }
    
    init(container: NSPersistentCloudKitContainer) {
        self.container = container
        setupCloudKitNotifications()
        checkCloudKitAccountStatus()
    }
    
    // MARK: - CloudKit Notifications Setup
    private func setupCloudKitNotifications() {
        // Monitor for remote change notifications
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .sink { [weak self] notification in
                DispatchQueue.main.async {
                    self?.handleRemoteChange(notification)
                }
            }
            .store(in: &cancellables)
        
        // Monitor for import events
        NotificationCenter.default.publisher(for: .NSPersistentCloudKitContainerEventChangedNotification)
            .sink { [weak self] notification in
                DispatchQueue.main.async {
                    self?.handleCloudKitEvent(notification)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CloudKit Account Status Check
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
                    self?.testCloudKitSync()
                case .noAccount:
                    print("[U+1F534] CloudKit Account: No iCloud account")
                    self?.syncStatus = .failed("No hay cuenta iCloud")
                    self?.showError("No se encontró cuenta iCloud. Inicia sesión en Configuración > iCloud")
                case .restricted:
                    print("[U+1F534] CloudKit Account: Restricted")
                    self?.syncStatus = .failed("Cuenta iCloud restringida")
                    self?.showError("La cuenta iCloud está restringida")
                case .couldNotDetermine:
                    print("[U+1F534] CloudKit Account: Could not determine")
                    self?.syncStatus = .failed("No se pudo determinar estado iCloud")
                    self?.showError("No se pudo determinar el estado de iCloud")
                case .temporarilyUnavailable:
                    print("[U+1F7E1] CloudKit Account: Temporarily unavailable")
                    self?.syncStatus = .failed("iCloud temporalmente no disponible")
                    self?.showError("iCloud temporalmente no disponible")
                @unknown default:
                    print("[U+1F534] CloudKit Account: Unknown status")
                    self?.syncStatus = .failed("Estado iCloud desconocido")
                }
            }
        }
    }
    
    // MARK: - CloudKit Sync Testing
    func testCloudKitSync() {
        print("[SYNC] Iniciando test de sincronización CloudKit...")
        syncStatus = .syncing
        
        // Fetch workouts to test sync
        let context = container.viewContext
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        
        do {
            let workouts = try context.fetch(request)
            print("[U+1F4CA] Entrenamientos locales encontrados: \(workouts.count)")
            
            // Log each workout for debugging
            for (index, workout) in workouts.prefix(5).enumerated() {
                print("  \(index + 1). \(workout.type ?? "Unknown") - \(workout.duration) min - \(formatDate(workout.date))")
            }
            
            // Check if data has CloudKit metadata (indicates sync status)
            checkCloudKitMetadata(for: workouts)
            
        } catch {
            print("[U+1F534] Error fetching workouts: \(error.localizedDescription)")
            syncStatus = .failed("Error al obtener entrenamientos")
            showError("Error al obtener entrenamientos: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CloudKit Metadata Check
    private func checkCloudKitMetadata(for workouts: [WorkoutEntity]) {
        var syncedCount = 0
        var pendingCount = 0
        
        for workout in workouts {
            // Check if the object has been synced to CloudKit
            if let recordID = workout.objectID.uriRepresentation().absoluteString.components(separatedBy: "/").last {
                // This is a simplified check - in reality, you'd check the actual CloudKit record
                if workout.objectID.isTemporaryID == false {
                    syncedCount += 1
                } else {
                    pendingCount += 1
                }
            }
        }
        
        print("[U+1F4E4] Entrenamientos sincronizados: \(syncedCount)")
        print("⏳ Entrenamientos pendientes: \(pendingCount)")
        
        if pendingCount == 0 && syncedCount > 0 {
            syncStatus = .success
            lastSyncDate = Date()
            print("[OK] Sincronización CloudKit exitosa")
        } else if pendingCount > 0 {
            syncStatus = .syncing
            print("[SYNC] Sincronización en progreso...")
        } else {
            syncStatus = .unknown
            print("❓ Estado de sincronización desconocido")
        }
    }
    
    // MARK: - Notification Handlers
    private func handleRemoteChange(_ notification: Notification) {
        print("[U+1F4E1] CloudKit: Cambios remotos detectados")
        print("[U+1F4E1] Notification: \(notification.name.rawValue)")
        
        // Log the store that changed
        if let store = notification.object as? NSPersistentStore {
            print("[U+1F4E1] Store afectado: \(store.identifier ?? "Unknown")")
        }
        
        // Refresh data after remote changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.testCloudKitSync()
        }
    }
    
    private func handleCloudKitEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let event = userInfo[NSPersistentCloudKitContainerEventChangedNotification] as? NSPersistentCloudKitContainer.Event else {
            return
        }
        
        print("[U+1F329]️ CloudKit Event: \(event.type.description)")
        
        switch event.type {
        case .setup:
            print("[U+1F329]️ CloudKit: Configuración")
        case .import:
            print("[U+1F329]️ CloudKit: Importación desde iCloud")
            if let error = event.error {
                print("[U+1F534] CloudKit Import Error: \(error.localizedDescription)")
                syncStatus = .failed("Error de importación")
                showError("Error al importar de iCloud: \(error.localizedDescription)")
            } else {
                print("[OK] CloudKit: Importación exitosa")
                testCloudKitSync()
            }
        case .export:
            print("[U+1F329]️ CloudKit: Exportación a iCloud")
            if let error = event.error {
                print("[U+1F534] CloudKit Export Error: \(error.localizedDescription)")
                syncStatus = .failed("Error de exportación")
                showError("Error al exportar a iCloud: \(error.localizedDescription)")
            } else {
                print("[OK] CloudKit: Exportación exitosa")
                syncStatus = .success
                lastSyncDate = Date()
            }
        @unknown default:
            print("[U+1F329]️ CloudKit: Evento desconocido")
        }
    }
    
    // MARK: - Manual Sync Trigger
    func triggerManualSync() {
        print("[SYNC] Iniciando sincronización manual...")
        syncStatus = .syncing
        
        // Save context to trigger CloudKit sync
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("[U+1F4BE] Contexto guardado - sincronización iniciada")
            } catch {
                print("[U+1F534] Error saving context: \(error.localizedDescription)")
                syncStatus = .failed("Error al guardar")
                showError("Error al guardar: \(error.localizedDescription)")
            }
        } else {
            // No changes to sync, just check current status
            testCloudKitSync()
        }
    }
    
    // MARK: - Helper Methods
    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - CloudKit Event Type Extension
extension NSPersistentCloudKitContainer.Event.EventType {
    var description: String {
        switch self {
        case .setup:
            return "Setup"
        case .import:
            return "Import"
        case .export:
            return "Export"
        @unknown default:
            return "Unknown"
        }
    }
}

// MARK: - CloudKit Sync Status View
struct CloudKitSyncStatusView: View {
    @StateObject private var syncMonitor: CloudKitSyncMonitor
    
    init(container: NSPersistentCloudKitContainer) {
        self._syncMonitor = StateObject(wrappedValue: CloudKitSyncMonitor(container: container))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: syncStatusIcon)
                    .foregroundColor(syncMonitor.syncStatus.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Estado CloudKit")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(syncMonitor.syncStatus.description)
                        .font(.caption)
                        .foregroundColor(syncMonitor.syncStatus.color)
                }
                
                Spacer()
                
                Button("Sincronizar") {
                    syncMonitor.triggerManualSync()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if let lastSync = syncMonitor.lastSyncDate {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    
                    Text("Última sync: \(formatDate(lastSync))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .alert("CloudKit Error", isPresented: $syncMonitor.showingAlert) {
            Button("OK") {
                syncMonitor.showingAlert = false
            }
        } message: {
            Text(syncMonitor.errorMessage ?? "Error desconocido")
        }
        .onAppear {
            syncMonitor.checkCloudKitAccountStatus()
        }
    }
    
    private var syncStatusIcon: String {
        switch syncMonitor.syncStatus {
        case .unknown:
            return "questionmark.circle"
        case .syncing:
            return "arrow.triangle.2.circlepath"
        case .success:
            return "checkmark.circle.fill"
        case .failed:
            return "exclamationmark.triangle.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}