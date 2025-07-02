import Foundation
import CoreData
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false
    
    func saveWorkout(type: String, duration: Int, managedObjectContext: NSManagedObjectContext) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let workout = WorkoutEntity(context: managedObjectContext)
            workout.id = UUID()
            workout.type = type
            workout.duration = Int32(duration)
            workout.date = Date()
            workout.calories = Int32(AppConstants.calculateCalories(for: duration))
            
            try managedObjectContext.save()
            
            await MainActor.run {
                isLoading = false
                showSuccess = true
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = "Error al guardar el entrenamiento: \(error.localizedDescription)"
            }
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func clearSuccess() {
        showSuccess = false
    }
}