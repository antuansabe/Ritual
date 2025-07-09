import SwiftUI
import CoreData
import CloudKit
import Combine
import os.log

// MARK: - CloudKit Conflict Monitor
class CloudKitConflictMonitor: ObservableObject {
    @Published var conflicts: [CloudKitConflict] = []
    @Published var syncEvents: [SyncEvent] = []
    @Published var networkIssues: [NetworkIssue] = []
    @Published var isMonitoring = false
    
    private var cancellables = Set<AnyCancellable>()
    private let container: NSPersistentCloudKitContainer
    private let maxEventsToKeep = 50
    
    init(container: NSPersistentCloudKitContainer) {
        self.container = container
        setupCloudKitMonitoring()
    }
    
    // MARK: - Data Models
    struct CloudKitConflict: Identifiable {
        let id = UUID()
        let timestamp: Date
        let entityType: String
        let conflictType: ConflictType
        let description: String
        let localData: String
        let remoteData: String
        
        enum ConflictType {
            case simultaneousEdit
            case deletionConflict
            case attributeConflict
            case relationshipConflict
            case unknown
            
            var emoji: String {
                switch self {
                case .simultaneousEdit: return "⚡"
                case .deletionConflict: return "[U+1F5D1]️"
                case .attributeConflict: return "[U+1F4DD]"
                case .relationshipConflict: return "[U+1F517]"
                case .unknown: return "❓"
                }
            }
        }
    }
    
    struct SyncEvent: Identifiable {
        let id = UUID()
        let timestamp: Date
        let type: EventType
        let description: String
        let details: String?
        
        enum EventType {
            case import
            case export
            case setup
            case accountChange
            case remoteChange
            
            var emoji: String {
                switch self {
                case .import: return "[U+1F4E5]"
                case .export: return "[U+1F4E4]"
                case .setup: return "⚙️"
                case .accountChange: return "[U+1F464]"
                case .remoteChange: return "☁️"
                }
            }
            
            var color: Color {
                switch self {
                case .import: return .green
                case .export: return .blue
                case .setup: return .gray
                case .accountChange: return .orange
                case .remoteChange: return .purple
                }
            }
        }
    }
    
    struct NetworkIssue: Identifiable {
        let id = UUID()
        let timestamp: Date
        let type: IssueType
        let description: String
        let suggestion: String
        
        enum IssueType {
            case networkError
            case accountError
            case quotaExceeded
            case authenticationFailed
            case serviceUnavailable
            
            var emoji: String {
                switch self {
                case .networkError: return "[U+1F4E1]"
                case .accountError: return "[U+1F464]"
                case .quotaExceeded: return "[U+1F4BE]"
                case .authenticationFailed: return "[U+1F510]"
                case .serviceUnavailable: return "[WARN]️"
                }
            }
        }
    }
    
    // MARK: - CloudKit Monitoring Setup
    private func setupCloudKitMonitoring() {
        isMonitoring = true
        #if DEBUG
        Logger.cloudkit.debug("[U+1F527] Configurando monitoreo avanzado de CloudKit...")
        #endif
        
        // Monitor CloudKit container events
        NotificationCenter.default.publisher(for: .NSPersistentCloudKitContainerEventChangedNotification)
            .sink { [weak self] notification in
                self?.handleCloudKitEvent(notification)
            }
            .store(in: &cancellables)
        
        // Monitor remote changes
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .sink { [weak self] notification in
                self?.handleRemoteChange(notification)
            }
            .store(in: &cancellables)
        
        // Monitor context saves for conflict detection
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] notification in
                self?.handleContextSave(notification)
            }
            .store(in: &cancellables)
        
        // Monitor context merges
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidMergeChangesFromParent)
            .sink { [weak self] notification in
                self?.handleContextMerge(notification)
            }
            .store(in: &cancellables)
        
        #if DEBUG
        Logger.cloudkit.debug("[OK] Monitoreo CloudKit configurado exitosamente")
        #endif
    }
    
    // MARK: - Event Handlers
    private func handleCloudKitEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let event = userInfo[NSPersistentCloudKitContainerEventChangedNotification] as? NSPersistentCloudKitContainer.Event else {
            return
        }
        
        DispatchQueue.main.async {
            self.processCloudKitEvent(event)
        }
    }
    
    private func processCloudKitEvent(_ event: NSPersistentCloudKitContainer.Event) {
        let timestamp = Date()
        
        switch event.type {
        case .setup:
            let syncEvent = SyncEvent(
                timestamp: timestamp,
                type: .setup,
                description: "CloudKit Setup",
                details: "Configuración inicial de CloudKit completada"
            )
            addSyncEvent(syncEvent)
            #if DEBUG
            Logger.cloudkit.debug("⚙️ CloudKit Setup: Configuración inicial completada")
            #endif
            
        case .import:
            handleImportEvent(event, timestamp: timestamp)
            
        case .export:
            handleExportEvent(event, timestamp: timestamp)
            
        @unknown default:
            #if DEBUG
            Logger.cloudkit.debug("❓ CloudKit Event desconocido: \(event.type)")
            #endif
        }
        
        // Check for errors in any event
        if let error = event.error {
            handleCloudKitError(error, eventType: event.type, timestamp: timestamp)
        }
    }
    
    private func handleImportEvent(_ event: NSPersistentCloudKitContainer.Event, timestamp: Date) {
        if let error = event.error {
            #if DEBUG
            Logger.cloudkit.debug("[ERR] CloudKit Import Error: \(error.localizedDescription)")
            #endif
            handleCloudKitError(error, eventType: .import, timestamp: timestamp)
        } else {
            let syncEvent = SyncEvent(
                timestamp: timestamp,
                type: .import,
                description: "Datos importados desde iCloud",
                details: "Sincronización entrante completada exitosamente"
            )
            addSyncEvent(syncEvent)
            #if DEBUG
            Logger.cloudkit.debug("[U+1F4E5] CloudKit Import: Datos nuevos recibidos desde iCloud")
            #endif
            
            // Check for potential conflicts during import
            detectImportConflicts(event)
        }
    }
    
    private func handleExportEvent(_ event: NSPersistentCloudKitContainer.Event, timestamp: Date) {
        if let error = event.error {
            #if DEBUG
            Logger.cloudkit.debug("[ERR] CloudKit Export Error: \(error.localizedDescription)")
            #endif
            handleCloudKitError(error, eventType: .export, timestamp: timestamp)
        } else {
            let syncEvent = SyncEvent(
                timestamp: timestamp,
                type: .export,
                description: "Datos exportados a iCloud",
                details: "Sincronización saliente completada exitosamente"
            )
            addSyncEvent(syncEvent)
            #if DEBUG
            Logger.cloudkit.debug("[U+1F4E4] CloudKit Export: Datos locales enviados a iCloud exitosamente")
            #endif
        }
    }
    
    private func handleRemoteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            let syncEvent = SyncEvent(
                timestamp: Date(),
                type: .remoteChange,
                description: "Cambios remotos detectados",
                details: "Datos modificados en otro dispositivo"
            )
            self.addSyncEvent(syncEvent)
            #if DEBUG
            Logger.cloudkit.debug("☁️ Remote Change: Cambios detectados desde otro dispositivo")
            #endif
            
            // Analyze the remote changes for conflicts
            self.analyzeRemoteChanges(notification)
        }
    }
    
    private func handleContextSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else { return }
        
        // Only monitor the view context saves
        if context == container.viewContext {
            #if DEBUG
            Logger.cloudkit.debug("[U+1F4BE] Context Save: Datos guardados localmente")
            #endif
            
            // Check for potential conflicts before save
            detectPreSaveConflicts(context, notification: notification)
        }
    }
    
    private func handleContextMerge(_ notification: Notification) {
        DispatchQueue.main.async {
            #if DEBUG
            Logger.cloudkit.debug("[SYNC] Context Merge: Fusionando cambios automáticamente")
            #endif
            
            if let userInfo = notification.userInfo {
                self.analyzeContextMerge(userInfo)
            }
        }
    }
    
    // MARK: - Conflict Detection
    private func detectImportConflicts(_ event: NSPersistentCloudKitContainer.Event) {
        // Simulate conflict detection during import
        // In a real implementation, you would analyze the imported data
        #if DEBUG
        Logger.cloudkit.debug("[U+1F50D] Analizando posibles conflictos en datos importados...")
        #endif
        
        // Example: Check for timestamp conflicts
        let context = container.viewContext
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        request.fetchLimit = 10
        
        do {
            let recentWorkouts = try context.fetch(request)
            
            // Look for potential conflicts (workouts with very close timestamps)
            for workout in recentWorkouts {
                if let date = workout.date,
                   Date().timeIntervalSince(date) < 60 { // Within last minute
                    
                    let conflict = CloudKitConflict(
                        timestamp: Date(),
                        entityType: "WorkoutEntity",
                        conflictType: .simultaneousEdit,
                        description: "Entrenamiento creado casi simultáneamente",
                        localData: "\(workout.type ?? "Unknown") - \(workout.duration) min",
                        remoteData: "Datos remotos similar timestamp"
                    )
                    
                    addConflict(conflict)
                    #if DEBUG
                    Logger.cloudkit.debug("⚡ Conflicto detectado: Ediciones simultáneas en \(workout.type ?? "Unknown")")
                    #endif
                }
            }
        } catch {
            print("[ERR] Error al analizar conflictos: \(error.localizedDescription)")
        }
    }
    
    private func detectPreSaveConflicts(_ context: NSManagedObjectContext, notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Check for updated objects that might conflict
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for object in updatedObjects {
                if let workout = object as? WorkoutEntity {
                    print("[U+1F4DD] Objeto modificado antes de guardar: \(workout.type ?? "Unknown")")
                    
                    // Check if this object was recently modified remotely
                    if hasRecentRemoteChanges(for: workout) {
                        let conflict = CloudKitConflict(
                            timestamp: Date(),
                            entityType: "WorkoutEntity",
                            conflictType: .attributeConflict,
                            description: "Modificación local vs remota",
                            localData: "Local: \(workout.type ?? "Unknown") - \(workout.duration) min",
                            remoteData: "Remoto: Modificado recientemente"
                        )
                        
                        DispatchQueue.main.async {
                            self.addConflict(conflict)
                        }
                        print("[U+1F4DD] Conflicto de atributos detectado para \(workout.type ?? "Unknown")")
                    }
                }
            }
        }
        
        // Check for deleted objects
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for object in deletedObjects {
                if let workout = object as? WorkoutEntity {
                    print("[U+1F5D1]️ Objeto eliminado: \(workout.type ?? "Unknown")")
                    
                    let conflict = CloudKitConflict(
                        timestamp: Date(),
                        entityType: "WorkoutEntity",
                        conflictType: .deletionConflict,
                        description: "Eliminación mientras objeto existe remotamente",
                        localData: "Eliminado: \(workout.type ?? "Unknown")",
                        remoteData: "Existe en iCloud"
                    )
                    
                    DispatchQueue.main.async {
                        self.addConflict(conflict)
                    }
                    print("[U+1F5D1]️ Conflicto de eliminación detectado")
                }
            }
        }
    }
    
    private func analyzeRemoteChanges(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Log details about remote changes
        if let storeUUID = userInfo[NSStoreUUIDKey] as? String {
            print("[U+1F4E1] Store UUID: \(storeUUID)")
        }
        
        // Analyze transaction history if available
        if let historyToken = userInfo["NSPersistentHistoryTokenKey"] {
            print("[U+1F4DA] History Token: \(historyToken)")
            
            // This indicates we have detailed transaction history
            analyzeTransactionHistory()
        }
    }
    
    private func analyzeContextMerge(_ userInfo: [AnyHashable: Any]) {
        // Analyze what was merged
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("[SYNC] Objetos actualizados en merge: \(updatedObjects.count)")
            
            for object in updatedObjects {
                if let workout = object as? WorkoutEntity {
                    print("   [U+1F4DD] Merged: \(workout.type ?? "Unknown") - \(workout.duration) min")
                }
            }
        }
        
        if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("[SYNC] Objetos insertados en merge: \(insertedObjects.count)")
            
            for object in insertedObjects {
                if let workout = object as? WorkoutEntity {
                    print("   ➕ Inserted: \(workout.type ?? "Unknown") - \(workout.duration) min")
                }
            }
        }
        
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("[SYNC] Objetos eliminados en merge: \(deletedObjects.count)")
        }
    }
    
    private func analyzeTransactionHistory() {
        // Fetch recent transaction history
        let context = container.viewContext
        let historyRequestFromToken = NSPersistentHistoryRequest.fetchHistory(after: nil)
        
        do {
            let historyResult = try context.execute(historyRequestFromToken) as? NSPersistentHistoryResult
            if let transactions = historyResult?.result as? [NSPersistentHistoryTransaction] {
                
                for transaction in transactions.suffix(5) { // Last 5 transactions
                    print("[U+1F4DA] Transaction: \(transaction.timestamp) - Author: \(transaction.author ?? "Unknown")")
                    
                    if let changes = transaction.changes {
                        for change in changes {
                            print("   [SYNC] Change: \(change.changeType.rawValue) - \(change.changedObjectID)")
                        }
                    }
                }
            }
        } catch {
            print("[ERR] Error al analizar historial: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling
    private func handleCloudKitError(_ error: Error, eventType: NSPersistentCloudKitContainer.Event.EventType, timestamp: Date) {
        let ckError = error as? CKError
        let nsError = error as NSError
        
        var issueType: NetworkIssue.IssueType = .networkError
        var description = error.localizedDescription
        var suggestion = "Verificar configuración"
        
        if let ckError = ckError {
            switch ckError.code {
            case .networkUnavailable, .networkFailure:
                issueType = .networkError
                description = "Error de red: \(ckError.localizedDescription)"
                suggestion = "Verificar conexión a internet"
                print("[U+1F4E1] CloudKit Network Error: \(description)")
                
            case .notAuthenticated:
                issueType = .authenticationFailed
                description = "Error de autenticación iCloud"
                suggestion = "Verificar sesión iCloud en Configuración"
                print("[U+1F510] CloudKit Auth Error: \(description)")
                
            case .quotaExceeded:
                issueType = .quotaExceeded
                description = "Cuota de iCloud excedida"
                suggestion = "Liberar espacio en iCloud"
                print("[U+1F4BE] CloudKit Quota Error: \(description)")
                
            case .serviceUnavailable:
                issueType = .serviceUnavailable
                description = "Servicio iCloud no disponible"
                suggestion = "Intentar más tarde"
                print("[WARN]️ CloudKit Service Error: \(description)")
                
            default:
                description = "Error CloudKit: \(ckError.localizedDescription)"
                print("[ERR] CloudKit Error: \(description)")
            }
        }
        
        let networkIssue = NetworkIssue(
            timestamp: timestamp,
            type: issueType,
            description: description,
            suggestion: suggestion
        )
        
        DispatchQueue.main.async {
            self.addNetworkIssue(networkIssue)
        }
    }
    
    // MARK: - Helper Methods
    private func hasRecentRemoteChanges(for workout: WorkoutEntity) -> Bool {
        // Simplified check - in real implementation, you'd check transaction history
        // This is a mock implementation
        return Date().timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 10) < 3
    }
    
    private func addConflict(_ conflict: CloudKitConflict) {
        conflicts.append(conflict)
        
        // Keep only recent conflicts
        if conflicts.count > maxEventsToKeep {
            conflicts = Array(conflicts.suffix(maxEventsToKeep))
        }
    }
    
    private func addSyncEvent(_ event: SyncEvent) {
        syncEvents.append(event)
        
        // Keep only recent events
        if syncEvents.count > maxEventsToKeep {
            syncEvents = Array(syncEvents.suffix(maxEventsToKeep))
        }
    }
    
    private func addNetworkIssue(_ issue: NetworkIssue) {
        networkIssues.append(issue)
        
        // Keep only recent issues
        if networkIssues.count > maxEventsToKeep {
            networkIssues = Array(networkIssues.suffix(maxEventsToKeep))
        }
    }
    
    // MARK: - Public Methods
    func clearAllEvents() {
        conflicts.removeAll()
        syncEvents.removeAll()
        networkIssues.removeAll()
        print("[U+1F9F9] Eventos de monitoreo limpiados")
    }
    
    func generateConflictReport() -> String {
        var report = "[U+1F4CA] REPORTE DE CONFLICTOS CLOUDKIT\n"
        report += "================================\n\n"
        
        report += "[U+1F525] CONFLICTOS DETECTADOS: \(conflicts.count)\n"
        for conflict in conflicts.suffix(5) {
            report += "\(conflict.conflictType.emoji) \(conflict.description)\n"
            report += "   Local: \(conflict.localData)\n"
            report += "   Remoto: \(conflict.remoteData)\n"
            report += "   Tiempo: \(formatTime(conflict.timestamp))\n\n"
        }
        
        report += "[U+1F4E1] PROBLEMAS DE RED: \(networkIssues.count)\n"
        for issue in networkIssues.suffix(3) {
            report += "\(issue.type.emoji) \(issue.description)\n"
            report += "   Sugerencia: \(issue.suggestion)\n\n"
        }
        
        report += "[U+1F4CB] EVENTOS RECIENTES: \(syncEvents.count)\n"
        for event in syncEvents.suffix(5) {
            report += "\(event.type.emoji) \(event.description)\n"
        }
        
        return report
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}