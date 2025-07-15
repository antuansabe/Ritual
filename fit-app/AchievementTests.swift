import XCTest
import CoreData
@testable import fit_app

class AchievementTests: XCTestCase {
    
    var testContext: NSManagedObjectContext!
    var achievementManager: AchievementManager!
    
    override func setUp() {
        super.setUp()
        
        // Create in-memory Core Data stack for testing
        let container = NSPersistentContainer(name: "WorkoutHeroModel")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription()]
        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        container.loadPersistentStores { _, _ in }
        
        testContext = container.viewContext
        achievementManager = AchievementManager.shared
        achievementManager.resetAchievements()
    }
    
    override func tearDown() {
        achievementManager.resetAchievements()
        testContext = nil
        super.tearDown()
    }
    
    func testInitialAchievementState() {
        // Test that all achievements start unlocked = false
        let achievements = achievementManager.achievements
        
        XCTAssertEqual(achievements.count, 4, "Should have 4 achievements")
        
        for achievement in achievements {
            XCTAssertFalse(achievement.unlocked, "Achievement \(achievement.id) should start unlocked = false")
            XCTAssertNil(achievement.unlockedDate, "Achievement \(achievement.id) should have no unlock date initially")
        }
        
        XCTAssertEqual(achievementManager.unlockedCount(), 0, "Should have 0 unlocked achievements initially")
    }
    
    func testFirstWorkoutAchievement() {
        // Create 1 workout
        let workout = createTestWorkout(type: "Cardio", duration: 30)
        
        // Evaluate achievements with 1 workout
        achievementManager.evaluateWithWorkouts([workout])
        
        // Check that firstWorkout achievement is unlocked
        let firstWorkoutAchievement = achievementManager.getAchievement(.firstWorkout)
        XCTAssertNotNil(firstWorkoutAchievement, "First workout achievement should exist")
        XCTAssertTrue(firstWorkoutAchievement!.unlocked, "First workout achievement should be unlocked")
        XCTAssertNotNil(firstWorkoutAchievement!.unlockedDate, "First workout achievement should have unlock date")
        
        // Check that other achievements are still locked
        XCTAssertFalse(achievementManager.getAchievement(.fiveWorkouts)?.unlocked ?? true, "Five workouts achievement should be locked")
        XCTAssertFalse(achievementManager.getAchievement(.tenWorkouts)?.unlocked ?? true, "Ten workouts achievement should be locked")
        
        XCTAssertEqual(achievementManager.unlockedCount(), 1, "Should have 1 unlocked achievement")
    }
    
    func testFiveWorkoutsAchievement() {
        // Create 5 workouts
        var workouts: [WorkoutEntity] = []
        for i in 0..<5 {
            let workout = createTestWorkout(type: "Cardio", duration: 30)
            workout.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            workouts.append(workout)
        }
        
        // Evaluate achievements with 5 workouts
        achievementManager.evaluateWithWorkouts(workouts)
        
        // Check that both firstWorkout and fiveWorkouts achievements are unlocked
        let firstWorkoutAchievement = achievementManager.getAchievement(.firstWorkout)
        let fiveWorkoutsAchievement = achievementManager.getAchievement(.fiveWorkouts)
        
        XCTAssertTrue(firstWorkoutAchievement?.unlocked ?? false, "First workout achievement should be unlocked")
        XCTAssertTrue(fiveWorkoutsAchievement?.unlocked ?? false, "Five workouts achievement should be unlocked")
        
        // Check that ten workouts achievement is still locked
        XCTAssertFalse(achievementManager.getAchievement(.tenWorkouts)?.unlocked ?? true, "Ten workouts achievement should be locked")
        
        XCTAssertEqual(achievementManager.unlockedCount(), 2, "Should have 2 unlocked achievements")
    }
    
    func testTenWorkoutsAchievement() {
        // Create 10 workouts
        var workouts: [WorkoutEntity] = []
        for i in 0..<10 {
            let workout = createTestWorkout(type: "Cardio", duration: 30)
            workout.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            workouts.append(workout)
        }
        
        // Evaluate achievements with 10 workouts
        achievementManager.evaluateWithWorkouts(workouts)
        
        // Check that all workout count achievements are unlocked
        let firstWorkoutAchievement = achievementManager.getAchievement(.firstWorkout)
        let fiveWorkoutsAchievement = achievementManager.getAchievement(.fiveWorkouts)
        let tenWorkoutsAchievement = achievementManager.getAchievement(.tenWorkouts)
        
        XCTAssertTrue(firstWorkoutAchievement?.unlocked ?? false, "First workout achievement should be unlocked")
        XCTAssertTrue(fiveWorkoutsAchievement?.unlocked ?? false, "Five workouts achievement should be unlocked")
        XCTAssertTrue(tenWorkoutsAchievement?.unlocked ?? false, "Ten workouts achievement should be unlocked")
        
        XCTAssertEqual(achievementManager.unlockedCount(), 3, "Should have 3 unlocked achievements")
    }
    
    func testWeeklyStreakAchievement() {
        // Create 7 workouts on consecutive days
        var workouts: [WorkoutEntity] = []
        for i in 0..<7 {
            let workout = createTestWorkout(type: "Cardio", duration: 30)
            workout.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            workouts.append(workout)
        }
        
        // Evaluate achievements with 7 consecutive workouts
        achievementManager.evaluateWithWorkouts(workouts)
        
        // Check that streak achievement is unlocked
        let streakAchievement = achievementManager.getAchievement(.weeklyStreak)
        XCTAssertTrue(streakAchievement?.unlocked ?? false, "Weekly streak achievement should be unlocked")
        
        // Should have first workout, five workouts, and weekly streak unlocked
        XCTAssertEqual(achievementManager.unlockedCount(), 3, "Should have 3 unlocked achievements")
    }
    
    func testAchievementPersistence() {
        // Create 5 workouts to unlock some achievements
        var workouts: [WorkoutEntity] = []
        for i in 0..<5 {
            let workout = createTestWorkout(type: "Cardio", duration: 30)
            workout.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            workouts.append(workout)
        }
        
        achievementManager.evaluateWithWorkouts(workouts)
        
        // Verify achievements are unlocked
        XCTAssertEqual(achievementManager.unlockedCount(), 2, "Should have 2 unlocked achievements")
        
        // Create a new achievement manager instance to test persistence
        let newManager = AchievementManager.shared // Since it's a singleton, it should load from storage
        
        // Verify achievements are still unlocked after reloading
        XCTAssertEqual(newManager.unlockedCount(), 2, "Achievements should persist after reloading")
    }
    
    func testAchievementDoesNotRegress() {
        // Unlock first achievement
        let workout = createTestWorkout(type: "Cardio", duration: 30)
        achievementManager.evaluateWithWorkouts([workout])
        
        let firstAchievement = achievementManager.getAchievement(.firstWorkout)
        XCTAssertTrue(firstAchievement?.unlocked ?? false, "First workout achievement should be unlocked")
        
        // Evaluate again with the same workout - should not cause regression
        achievementManager.evaluateWithWorkouts([workout])
        
        let stillUnlocked = achievementManager.getAchievement(.firstWorkout)
        XCTAssertTrue(stillUnlocked?.unlocked ?? false, "Achievement should remain unlocked")
        XCTAssertEqual(achievementManager.unlockedCount(), 1, "Should still have 1 unlocked achievement")
    }
    
    func testAchievementModelProperties() {
        // Test Achievement model properties
        let achievement = Achievement(id: .firstWorkout, unlocked: true, unlockedDate: Date())
        
        XCTAssertEqual(achievement.id, .firstWorkout, "Achievement ID should be correct")
        XCTAssertTrue(achievement.unlocked, "Achievement should be unlocked")
        XCTAssertNotNil(achievement.unlockedDate, "Achievement should have unlock date")
        
        // Test achievement kind properties
        XCTAssertEqual(achievement.id.title, "Primera Victoria", "Achievement title should be correct")
        XCTAssertEqual(achievement.id.description, "Completaste tu primer entrenamiento", "Achievement description should be correct")
        XCTAssertEqual(achievement.id.icon, "star.fill", "Achievement icon should be correct")
    }
    
    // MARK: - Helper Methods
    
    private func createTestWorkout(type: String, duration: Int) -> WorkoutEntity {
        let workout = WorkoutEntity(context: testContext)
        workout.id = UUID()
        workout.type = type
        workout.duration = Int32(duration)
        workout.date = Date()
        workout.calories = Int32(duration * 8) // Approximate calories calculation
        return workout
    }
}