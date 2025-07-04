import CoreData
import CloudKit
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
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

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "WorkoutHeroModel")
        
        if inMemory {
            // Configure for preview/testing with in-memory store
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            // Disable CloudKit for preview mode
            container.persistentStoreDescriptions.first!.setOption(true as NSNumber, 
                                                                  forKey: NSPersistentHistoryTrackingKey)
        } else {
            // Configure for production with CloudKit synchronization
            guard let description = container.persistentStoreDescriptions.first else {
                fatalError("Failed to retrieve a persistent store description.")
            }
            
            // Enable persistent history tracking (required for CloudKit)
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            
            // Enable remote change notifications
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Configure view context for optimal CloudKit synchronization
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Enable query generation tokens for consistent reads
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            print("Failed to pin viewContext to the current generation: \(error)")
        }
    }
}