import Foundation
import CoreData
import SwiftUI

class Jc55BDpU9b1oI7imy0dSuxhnsfADioo4: ObservableObject {
    @Published var YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = false
    @Published var TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy: String?
    @Published var XBKRsaOVB7IubKbKig2RNYsBUWknczOR = false
    
    func Q6FQiudhsBje7gcQQ0nF3ogoeJ65kYIX(type: String, duration: Int, managedObjectContext: NSManagedObjectContext) async {
        await MainActor.run {
            YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = true
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        }
        
        do {
            let workout = WorkoutEntity(context: managedObjectContext)
            workout.id = UUID()
            workout.type = type
            workout.duration = Int32(duration)
            workout.date = Date()
            workout.calories = Int32(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.macBuYFDgFuotG3Vx9Tc3pppQyU8fFgE(for: duration))
            
            try managedObjectContext.save()
            
            // Notify WeeklyGoalManager about the new workout
            NotificationCenter.default.post(name: .gUTLJd2whxFIrGRCEMVrNZWSFPiU5gq5, object: workout)
            
            await MainActor.run {
                YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = false
                XBKRsaOVB7IubKbKig2RNYsBUWknczOR = true
            }
        } catch {
            await MainActor.run {
                YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = false
                TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = "Error al guardar el entrenamiento: \(error.localizedDescription)"
            }
        }
    }
    
    func EYA1lT4kx4ae526Okh9jsZgBxFHUOAsZ() {
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
    }
    
    func CbgBVsEBDJ2ggnpPf5vwbO3y2nBi8nSf() {
        XBKRsaOVB7IubKbKig2RNYsBUWknczOR = false
    }
    
    func zvBOkPchV1wP5QfjlC5DUSTIXNE21PQK() {
        XBKRsaOVB7IubKbKig2RNYsBUWknczOR = false
    }
}