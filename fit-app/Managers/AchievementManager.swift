import Foundation
import CoreData
import os.log

class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    @Published var achievements: [Achievement] = []
    
    private let storageKey = "userAchievements"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        loadAchievements()
    }
    
    // MARK: - Persistence
    
    private func loadAchievements() {
        // Try to load from SecureStorage
        if let savedData = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: storageKey),
           let data = Data(base64Encoded: savedData),
           let loadedAchievements = try? decoder.decode([Achievement].self, from: data) {
            self.achievements = loadedAchievements
        } else {
            // Initialize with all achievements locked
            self.achievements = Achievement.allAchievements()
            saveAchievements()
        }
    }
    
    private func saveAchievements() {
        guard let data = try? encoder.encode(achievements),
              let base64String = data.base64EncodedString() as String? else {
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("Failed to encode achievements")
            #endif
            return
        }
        
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(base64String, for: storageKey)
    }
    
    // MARK: - Achievement Evaluation
    
    func evaluateAfterWorkout(totalWorkouts: Int, currentStreak: Int = 0) {
        var hasUnlockedNew = false
        
        // First workout achievement
        if totalWorkouts >= 1 {
            hasUnlockedNew = unlockAchievement(.firstWorkout) || hasUnlockedNew
        }
        
        // Five workouts achievement
        if totalWorkouts >= 5 {
            hasUnlockedNew = unlockAchievement(.fiveWorkouts) || hasUnlockedNew
        }
        
        // Ten workouts achievement
        if totalWorkouts >= 10 {
            hasUnlockedNew = unlockAchievement(.tenWorkouts) || hasUnlockedNew
        }
        
        // Weekly streak achievement
        if currentStreak >= 7 {
            hasUnlockedNew = unlockAchievement(.weeklyStreak) || hasUnlockedNew
        }
        
        if hasUnlockedNew {
            saveAchievements()
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🏆 New achievements unlocked!")
            #endif
        }
    }
    
    func evaluateWithWorkouts(_ workouts: [WorkoutEntity]) {
        let totalCount = workouts.count
        let currentStreak = calculateCurrentStreak(from: workouts)
        
        evaluateAfterWorkout(totalWorkouts: totalCount, currentStreak: currentStreak)
    }
    
    private func calculateCurrentStreak(from workouts: [WorkoutEntity]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var checkDate = today
        
        // Sort workouts by date descending
        let sortedWorkouts = workouts.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        
        for _ in 0..<30 { // Check last 30 days maximum
            let workoutsOnDate = sortedWorkouts.filter { workout in
                guard let workoutDate = workout.date else { return false }
                return calendar.isDate(workoutDate, inSameDayAs: checkDate)
            }
            
            if workoutsOnDate.isEmpty {
                // No workout on this day, check if it's today
                if calendar.isDate(checkDate, inSameDayAs: today) {
                    // Today doesn't have a workout yet, continue checking
                    checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
                    continue
                } else {
                    // Past day with no workout, streak broken
                    break
                }
            } else {
                streak += 1
            }
            
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
    
    private func unlockAchievement(_ kind: Achievement.Kind) -> Bool {
        guard let index = achievements.firstIndex(where: { $0.id == kind }) else {
            return false
        }
        
        if !achievements[index].unlocked {
            achievements[index].unlocked = true
            achievements[index].unlockedDate = Date()
            return true
        }
        
        return false
    }
    
    // MARK: - Public Methods
    
    func unlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.unlocked }
    }
    
    func unlockedCount() -> Int {
        return achievements.filter { $0.unlocked }.count
    }
    
    func resetAchievements() {
        achievements = Achievement.allAchievements()
        saveAchievements()
    }
    
    func getAchievement(_ kind: Achievement.Kind) -> Achievement? {
        return achievements.first { $0.id == kind }
    }
}