import Foundation
import CoreData
import SwiftUI

// MARK: - Week Engine for Centralized Week Calculations
final class WeekEngine {
    static let shared = WeekEngine()
    private init() { }

    private let calendar = Calendar.current

    func weekStart(for date: Date) -> Date {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = 2  // Monday
        return calendar.date(from: components)!
    }
    
    func weekEnd(for date: Date) -> Date {
        let start = weekStart(for: date)
        return calendar.date(byAdding: .day, value: 6, to: start)!
    }

    func workoutsThisWeek(in context: NSManagedObjectContext) throws -> [WorkoutEntity] {
        let start = weekStart(for: Date())
        let end = calendar.date(byAdding: .day, value: 7, to: start)!
        
        let request = WorkoutEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
        
        return try context.fetch(request)
    }

    func currentStreak(from workouts: [WorkoutEntity]) -> Int {
        let trainingDays = Set(workouts.compactMap { workout -> Date? in
            guard let workoutDate = workout.date else { return nil }
            return calendar.startOfDay(for: workoutDate)
        })
        
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())
        let weekStartDate = weekStart(for: Date())
        
        while currentDay >= weekStartDate {
            if trainingDays.contains(currentDay) {
                streak += 1
                currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    func weeklyTotals(in context: NSManagedObjectContext) throws -> (workouts: Int, minutes: Int, calories: Int) {
        let workouts = try workoutsThisWeek(in: context)
        
        let totalWorkouts = workouts.count
        let totalMinutes = workouts.reduce(0) { $0 + Int($1.duration) }
        let totalCalories = workouts.reduce(0) { $0 + Int($1.calories) }
        
        return (workouts: totalWorkouts, minutes: totalMinutes, calories: totalCalories)
    }
    
    func localStartOfDay(for date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }
    
    func daysRemainingInWeek() -> Int {
        let today = Date()
        let weekEnd = self.weekEnd(for: today)
        let daysRemaining = calendar.dateComponents([.day], from: calendar.startOfDay(for: today), to: calendar.startOfDay(for: weekEnd)).day ?? 0
        return max(0, daysRemaining)
    }
    
    func isInCurrentWeek(_ date: Date) -> Bool {
        let currentWeekStart = weekStart(for: Date())
        let currentWeekEnd = weekEnd(for: Date())
        return date >= currentWeekStart && date <= currentWeekEnd
    }
    
    func dayOfWeek(for date: Date) -> Int {
        let weekStart = self.weekStart(for: date)
        let days = calendar.dateComponents([.day], from: weekStart, to: date).day ?? 0
        return days + 1 // 1-based (Monday = 1, Sunday = 7)
    }
}

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
            
            // Evaluate achievements after saving workout
            let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
            let allWorkouts = try managedObjectContext.fetch(fetchRequest)
            
            await MainActor.run {
                AchievementManager.shared.evaluateWithWorkouts(allWorkouts)
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
        // Use WeekEngine for consistent streak calculation
        return WeekEngine.shared.currentStreak(from: workouts)
    }
    
    func calculateWeeklyStreak(workouts: [WorkoutEntity]) -> Int {
        // Delegate to WeekEngine for centralized calculation
        return WeekEngine.shared.currentStreak(from: workouts)
    }
}