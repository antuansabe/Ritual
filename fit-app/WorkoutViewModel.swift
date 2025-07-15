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

// MARK: - Workout Analysis Extension
extension XiotqQDHiBDxqWDO0uwhKXZcSWBnijF5 {
    func XpXjs2s0i38zzDWZ3PBpGos6nHfcnQ9A(workouts: [WorkoutEntity]) -> Int {
        guard let lastWorkout = workouts.first else { return Int.max }
        
        let calendar = Calendar.current
        let today = Date()
        let lastWorkoutDate = lastWorkout.date ?? today
        
        return calendar.dateComponents([.day], from: lastWorkoutDate, to: today).day ?? 0
    }
    
    func ES0BZT8uITuIRS240cz0GJ4YC02PSyRU(workouts: [WorkoutEntity]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var checkDate = today
        
        for _ in 0..<30 { // Check last 30 days maximum
            let workoutsOnDate = workouts.compactMap { workout -> WorkoutEntity? in
                guard let workoutDate = workout.date else { return nil }
                return calendar.isDate(workoutDate, inSameDayAs: checkDate) ? workout : nil
            }
            
            if workoutsOnDate.isEmpty {
                break
            } else {
                streak += 1
            }
            
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
}