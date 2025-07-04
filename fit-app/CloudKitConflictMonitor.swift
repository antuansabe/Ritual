import SwiftUI
import CoreData
import CloudKit
import Combine

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
                case .deletionConflict: return "🗑️"
                case .attributeConflict: return "📝"
                case .relationshipConflict: return "🔗"
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
                case .import: return "📥"
                case .export: return "📤"
                case .setup: return "⚙️"
                case .accountChange: return "👤"
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
                case .networkError: return "📡"
                case .accountError: return "👤"
                case .quotaExceeded: return "💾"
                case .authenticationFailed: return "🔐"
                case .serviceUnavailable: return "⚠️"
                }
            }
        }
    }
    
    // MARK: - CloudKit Monitoring Setup
    private func setupCloudKitMonitoring() {
        isMonitoring = true
        print("🔧 Configurando monitoreo avanzado de CloudKit...")
        
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
        
        print("✅ Monitoreo CloudKit configurado exitosamente")
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
            print("⚙️ CloudKit Setup: Configuración inicial completada")
            
        case .import:
            handleImportEvent(event, timestamp: timestamp)
            
        case .export:
            handleExportEvent(event, timestamp: timestamp)
            
        @unknown default:
            print("❓ CloudKit Event desconocido: \(event.type)")
        }
        
        // Check for errors in any event
        if let error = event.error {
            handleCloudKitError(error, eventType: event.type, timestamp: timestamp)
        }
    }
    
    private func handleImportEvent(_ event: NSPersistentCloudKitContainer.Event, timestamp: Date) {
        if let error = event.error {
            print("❌ CloudKit Import Error: \(error.localizedDescription)")
            handleCloudKitError(error, eventType: .import, timestamp: timestamp)
        } else {
            let syncEvent = SyncEvent(
                timestamp: timestamp,
                type: .import,
                description: "Datos importados desde iCloud",
                details: "Sincronización entrante completada exitosamente"
            )
            addSyncEvent(syncEvent)
            print("📥 CloudKit Import: Datos nuevos recibidos desde iCloud")
            
            // Check for potential conflicts during import
            detectImportConflicts(event)
        }
    }
    
    private func handleExportEvent(_ event: NSPersistentCloudKitContainer.Event, timestamp: Date) {
        if let error = event.error {
            print("❌ CloudKit Export Error: \(error.localizedDescription)")
            handleCloudKitError(error, eventType: .export, timestamp: timestamp)
        } else {
            let syncEvent = SyncEvent(
                timestamp: timestamp,
                type: .export,
                description: "Datos exportados a iCloud",
                details: "Sincronización saliente completada exitosamente"
            )
            addSyncEvent(syncEvent)
            print("📤 CloudKit Export: Datos locales enviados a iCloud exitosamente")
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
            print("☁️ Remote Change: Cambios detectados desde otro dispositivo")
            
            // Analyze the remote changes for conflicts
            self.analyzeRemoteChanges(notification)
        }
    }
    
    private func handleContextSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else { return }
        
        // Only monitor the view context saves
        if context == container.viewContext {
            print("💾 Context Save: Datos guardados localmente")
            
            // Check for potential conflicts before save
            detectPreSaveConflicts(context, notification: notification)
        }
    }
    
    private func handleContextMerge(_ notification: Notification) {
        DispatchQueue.main.async {
            print("🔄 Context Merge: Fusionando cambios automáticamente")
            
            if let userInfo = notification.userInfo {
                self.analyzeContextMerge(userInfo)
            }
        }
    }
    
    // MARK: - Conflict Detection
    private func detectImportConflicts(_ event: NSPersistentCloudKitContainer.Event) {
        // Simulate conflict detection during import
        // In a real implementation, you would analyze the imported data
        print("🔍 Analizando posibles conflictos en datos importados...")
        
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
                    print("⚡ Conflicto detectado: Ediciones simultáneas en \(workout.type ?? "Unknown")")
                }
            }
        } catch {
            print("❌ Error al analizar conflictos: \(error.localizedDescription)")
        }
    }
    
    private func detectPreSaveConflicts(_ context: NSManagedObjectContext, notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Check for updated objects that might conflict
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for object in updatedObjects {
                if let workout = object as? WorkoutEntity {
                    print("📝 Objeto modificado antes de guardar: \(workout.type ?? "Unknown")")
                    
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
                        print("📝 Conflicto de atributos detectado para \(workout.type ?? "Unknown")")
                    }
                }
            }
        }
        
        // Check for deleted objects
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for object in deletedObjects {
                if let workout = object as? WorkoutEntity {
                    print("🗑️ Objeto eliminado: \(workout.type ?? "Unknown")")
                    
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
                    print("🗑️ Conflicto de eliminación detectado")
                }
            }
        }
    }
    
    private func analyzeRemoteChanges(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Log details about remote changes
        if let storeUUID = userInfo[NSStoreUUIDKey] as? String {
            print("📡 Store UUID: \(storeUUID)")
        }
        
        // Analyze transaction history if available
        if let historyToken = userInfo["NSPersistentHistoryTokenKey"] {
            print("📚 History Token: \(historyToken)")
            
            // This indicates we have detailed transaction history
            analyzeTransactionHistory()
        }
    }
    
    private func analyzeContextMerge(_ userInfo: [AnyHashable: Any]) {
        // Analyze what was merged
        if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("🔄 Objetos actualizados en merge: \(updatedObjects.count)")
            
            for object in updatedObjects {
                if let workout = object as? WorkoutEntity {
                    print("   📝 Merged: \(workout.type ?? "Unknown") - \(workout.duration) min")
                }
            }
        }
        
        if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("🔄 Objetos insertados en merge: \(insertedObjects.count)")
            
            for object in insertedObjects {
                if let workout = object as? WorkoutEntity {
                    print("   ➕ Inserted: \(workout.type ?? "Unknown") - \(workout.duration) min")
                }
            }
        }
        
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("🔄 Objetos eliminados en merge: \(deletedObjects.count)")
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
                    print("📚 Transaction: \(transaction.timestamp) - Author: \(transaction.author ?? "Unknown")")
                    
                    if let changes = transaction.changes {
                        for change in changes {
                            print("   🔄 Change: \(change.changeType.rawValue) - \(change.changedObjectID)")
                        }
                    }
                }
            }
        } catch {
            print("❌ Error al analizar historial: \(error.localizedDescription)")
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
                print("📡 CloudKit Network Error: \(description)")
                
            case .notAuthenticated:
                issueType = .authenticationFailed
                description = "Error de autenticación iCloud"
                suggestion = "Verificar sesión iCloud en Configuración"
                print("🔐 CloudKit Auth Error: \(description)")
                
            case .quotaExceeded:
                issueType = .quotaExceeded
                description = "Cuota de iCloud excedida"
                suggestion = "Liberar espacio en iCloud"
                print("💾 CloudKit Quota Error: \(description)")
                
            case .serviceUnavailable:
                issueType = .serviceUnavailable
                description = "Servicio iCloud no disponible"
                suggestion = "Intentar más tarde"
                print("⚠️ CloudKit Service Error: \(description)")
                
            default:
                description = "Error CloudKit: \(ckError.localizedDescription)"
                print("❌ CloudKit Error: \(description)")
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
        print("🧹 Eventos de monitoreo limpiados")
    }
    
    func generateConflictReport() -> String {
        var report = "📊 REPORTE DE CONFLICTOS CLOUDKIT\n"
        report += "================================\n\n"
        
        report += "🔥 CONFLICTOS DETECTADOS: \(conflicts.count)\n"
        for conflict in conflicts.suffix(5) {
            report += "\(conflict.conflictType.emoji) \(conflict.description)\n"
            report += "   Local: \(conflict.localData)\n"
            report += "   Remoto: \(conflict.remoteData)\n"
            report += "   Tiempo: \(formatTime(conflict.timestamp))\n\n"
        }
        
        report += "📡 PROBLEMAS DE RED: \(networkIssues.count)\n"
        for issue in networkIssues.suffix(3) {
            report += "\(issue.type.emoji) \(issue.description)\n"
            report += "   Sugerencia: \(issue.suggestion)\n\n"
        }
        
        report += "📋 EVENTOS RECIENTES: \(syncEvents.count)\n"
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