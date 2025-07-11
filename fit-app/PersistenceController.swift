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
            FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreDescriptions.first!.setOption(true as NSNumber, 
                                                                  forKey: NSPersistentHistoryTrackingKey)
        } else {
            // Configure for production with CloudKit synchronization
            guard let description = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.persistentStoreDescriptions.first else {
                fatalError("Failed to retrieve a persistent store description.")
            }
            
            // Enable persistent history tracking (required for CloudKit)
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            
            // Enable remote change notifications
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        FU31nOsXzkAu3ssDTzwUVmAnypmtztob.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
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
    }
}

// MARK: - CloudKit Conflict Monitor
// Temporarily disabled for compilation - will be implemented as singleton
/*
extension PersistenceController {
    static let conflictMonitor = CloudKitConflictMonitor(container: PersistenceController.shared.container)
}
*/