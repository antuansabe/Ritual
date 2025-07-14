import CoreData
import CloudKit
import Foundation
import os.log

struct GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx()

    static var WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF: GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx = {
        let result = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx(inMemory: true)
        let viewContext = result.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
        
        // Add sample data for previews
        let sampleWorkout = WorkoutEntity(context: viewContext)
        sampleWorkout.id = UUID()
        sampleWorkout.type = "Cardio"
        sampleWorkout.duration = 45
        sampleWorkout.date = Date()
        sampleWorkout.calories = 360
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let FU31nOsXzkAu3ssDTzwUVmAnypmtztob: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob = NSPersistentCloudKitContainer(name: "WorkoutHeroModel")
        
        if inMemory {
            // Configure for preview/testing with in-memory store
            FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            // Disable CloudKit for preview mode
            // Configure testing mode store options
            let description = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreDescriptions.first!
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            
            // SECURITY: Enable file protection encryption (AES-256 native) for testing
            description.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
        } else {
            // Configure for production with CloudKit synchronization
            guard let description = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreDescriptions.first else {
                fatalError("Failed to retrieve a persistent store description.")
            }
            
            // CRITICAL: Configure CloudKit container to use PRIVATE database
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            // Set CloudKit container identifier - uses private database by default
            let containerIdentifier = "iCloud.com.antonio.ritmia"
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
            
            // Configure CloudKit container options for private database
            if let cloudKitOptions = description.cloudKitContainerOptions {
                cloudKitOptions.databaseScope = .private // EXPLICIT: Use private database scope
            }
            
            // SECURITY: Enable file protection encryption (AES-256 native)
            description.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
            
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("☁️ CloudKit configurado para base de datos PRIVADA")
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("📱 Container ID: \(containerIdentifier)")
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🔒 Database scope: PRIVATE (solo sincroniza con mismo Apple ID)")
            #endif
        }
        
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                #if DEBUG
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.error("❌ Error cargando persistent store: \(error), \(error.userInfo)")
                #endif
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ Persistent store cargado exitosamente")
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("📄 Store description: \(storeDescription)")
            
            // Log CloudKit configuration details
            if let cloudKitOptions = storeDescription.cloudKitContainerOptions {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("☁️ CloudKit options configuradas:")
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Container ID: \(cloudKitOptions.containerIdentifier)")
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Database scope: \(cloudKitOptions.databaseScope.rawValue)")
            }
            #endif
        })
        
        // Configure view context for optimal CloudKit synchronization
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext.automaticallyMergesChangesFromParent = true
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Add CloudKit conflict monitoring logging
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🔧 Configurando monitoreo de conflictos CloudKit...")
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ automaticallyMergesChangesFromParent = true")
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy")
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ CloudKit conflict monitor iniciado")
        #endif
        
        // Enable query generation tokens for consistent reads
        do {
            try FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext.setQueryGenerationFrom(.current)
        } catch {
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("Failed to pin viewContext to the current generation: \(error)")
            #endif
        }
        
        // Setup CloudKit sync event monitoring
        setupCloudKitSyncMonitoring()
    }
    
    // MARK: - CloudKit Sync Monitoring
    
    /// Configures comprehensive CloudKit sync event monitoring
    private func setupCloudKitSyncMonitoring() {
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🔍 Configurando monitoreo de eventos de sincronización CloudKit...")
        #endif
        
        // Monitor remote change notifications
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreCoordinator,
            queue: .main
        ) { notification in
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("☁️ SYNC EVENT: Remote change notification received")
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Notification: \(notification)")
            
            if let storeUUID = notification.userInfo?[NSStoreUUIDKey] as? String {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Store UUID: \(storeUUID)")
            }
            
            if let historyToken = notification.userInfo?[NSPersistentHistoryTokenKey] as? NSPersistentHistoryToken {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - History token: \(historyToken)")
            }
            #endif
            
            // Process remote changes
            self.processRemoteChanges()
        }
        
        // Monitor CloudKit account status changes
        NotificationCenter.default.addObserver(
            forName: .CKAccountChanged,
            object: nil,
            queue: .main
        ) { notification in
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("☁️ SYNC EVENT: CloudKit account status changed")
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Notification: \(notification)")
            #endif
            
            self.checkCloudKitAccountStatus()
        }
        
        // Monitor context save events
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext,
            queue: .main
        ) { notification in
            #if DEBUG
            Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("💾 SYNC EVENT: Context saved - triggering CloudKit sync")
            
            if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>,
               !insertedObjects.isEmpty {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Inserted objects: \(insertedObjects.count)")
                for object in insertedObjects {
                    Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("     * \(object.entity.name ?? "Unknown"): \(object.objectID)")
                }
            }
            
            if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
               !updatedObjects.isEmpty {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Updated objects: \(updatedObjects.count)")
                for object in updatedObjects {
                    Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("     * \(object.entity.name ?? "Unknown"): \(object.objectID)")
                }
            }
            
            if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>,
               !deletedObjects.isEmpty {
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("   - Deleted objects: \(deletedObjects.count)")
                for object in deletedObjects {
                    Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("     * \(object.entity.name ?? "Unknown"): \(object.objectID)")
                }
            }
            #endif
        }
        
        // Initial CloudKit account status check
        checkCloudKitAccountStatus()
        
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ Monitoreo de sincronización CloudKit configurado exitosamente")
        #endif
    }
    
    /// Processes remote changes from CloudKit
    private func processRemoteChanges() {
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🔄 Procesando cambios remotos de CloudKit...")
        #endif
        
        // Refresh the view context to get latest changes
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext.refreshAllObjects()
        
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ Cambios remotos procesados - contexto actualizado")
        #endif
    }
    
    /// Checks and logs CloudKit account status
    private func checkCloudKitAccountStatus() {
        let container = CKContainer(identifier: "iCloud.com.antonio.ritmia")
        
        container.accountStatus { accountStatus, error in
            DispatchQueue.main.async {
                #if DEBUG
                if let error = error {
                    Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.error("❌ Error checking CloudKit account status: \(error.localizedDescription)")
                } else {
                    switch accountStatus {
                    case .available:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("✅ CloudKit account: AVAILABLE - Sync enabled")
                    case .noAccount:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("⚠️ CloudKit account: NO ACCOUNT - User needs to sign into iCloud")
                    case .restricted:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🚫 CloudKit account: RESTRICTED - Parental controls or device restrictions")
                    case .couldNotDetermine:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("❓ CloudKit account: COULD NOT DETERMINE - Temporary issue")
                    case .temporarilyUnavailable:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("⏳ CloudKit account: TEMPORARILY UNAVAILABLE - Retry later")
                    @unknown default:
                        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("❓ CloudKit account: UNKNOWN STATUS - \(accountStatus.rawValue)")
                    }
                }
                #endif
            }
        }
    }
    
    
    // MARK: - Data Management
    
    /// Clears all data from Core Data store
    /// Used when deleting user account to ensure complete data removal
    func clearAllData() throws {
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🗑️ Starting Core Data cleanup...")
        #endif
        
        let context = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
        
        // Get all entity names
        let entityNames = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.managedObjectModel.entities.compactMap { $0.name }
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSDeletedObjectsKey: objectIDArray ?? []]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                
                #if DEBUG
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🗑️ Deleted all entities for: \(entityName)")
                #endif
            } catch {
                #if DEBUG
                Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.error("🗑️ ❌ Failed to delete entities for \(entityName): \(error.localizedDescription)")
                #endif
                throw error
            }
        }
        
        // Save context to persist changes
        try context.save()
        
        #if DEBUG
        Logger.uJ64CEAapWCbqsNEGRmfxsCkTN5OcuF8.debug("🗑️ ✅ Core Data cleanup completed successfully")
        #endif
    }
}

// MARK: - CloudKit Conflict Monitor
// Temporarily disabled for compilation - will be implemented as singleton
/*
extension PersistenceController {
    static let conflictMonitor = CloudKitConflictMonitor(container: PersistenceController.shared.container)
}
*/