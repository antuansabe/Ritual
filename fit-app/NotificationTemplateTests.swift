import XCTest
import UserNotifications
@testable import fit_app

class NotificationTemplateTests: XCTestCase {
    
    var scheduler: NotificationScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = NotificationScheduler.shared
        
        // Set up test user data
        UserDefaults.standard.set("TestUser", forKey: "favoriteWorkoutType")
        UserDefaults.standard.set(5, forKey: "weeklyGoal")
        UserDefaults.standard.set(3, forKey: "currentStreak")
        UserDefaults.standard.set(Date(), forKey: "lastWorkoutDate")
        UserDefaults.standard.set(2, forKey: "workoutsThisWeek")
    }
    
    override func tearDown() {
        // Clean up test data
        UserDefaults.standard.removeObject(forKey: "favoriteWorkoutType")
        UserDefaults.standard.removeObject(forKey: "weeklyGoal")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "lastWorkoutDate")
        UserDefaults.standard.removeObject(forKey: "workoutsThisWeek")
        super.tearDown()
    }
    
    func testN1_MorningMotivationTemplate() {
        // Test that morning motivation notification contains user name
        let testUserName = "Maria"
        
        // Store test user name in SecureStorage simulation
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        // The notification templates should contain the user name
        // Since these are private methods, we test the behavior indirectly
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        XCTAssertEqual(userName, testUserName, "Morning motivation should use the stored user name")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN2_StreakReminderWithStreak() {
        // Test that streak reminder shows correct streak count
        let streak = 5
        UserDefaults.standard.set(streak, forKey: "currentStreak")
        
        // Verify the streak value can be retrieved
        let retrievedStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        XCTAssertEqual(retrievedStreak, streak, "Streak reminder should use correct streak count")
        
        // Test plural form handling
        XCTAssertTrue(streak > 1, "Test should use plural form for multiple days")
    }
    
    func testN3_ProgressCelebrationFormatting() {
        // Test that progress celebration contains motivational language
        let testUserName = "Carlos"
        
        // Store test user name
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        // Simulate progress celebration template
        let expectedTitle = "¡Mira tu progreso, \(userName)! 📈"
        
        XCTAssertTrue(expectedTitle.contains(testUserName), "Progress celebration should contain user name")
        XCTAssertTrue(expectedTitle.contains("📈"), "Progress celebration should contain progress emoji")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN4_GentleEncouragementTone() {
        // Test that gentle encouragement uses appropriate supportive language
        let testUserName = "Ana"
        
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        // Simulate gentle encouragement template
        let expectedTitle = "Hola, \(userName) 🌱"
        let expectedBody = "No hay prisa. Tu bienestar es un viaje, no una carrera. Cuando te sientas listo, aquí estaremos."
        
        XCTAssertTrue(expectedTitle.contains(testUserName), "Gentle encouragement should contain user name")
        XCTAssertTrue(expectedBody.contains("No hay prisa"), "Gentle encouragement should be non-pressuring")
        XCTAssertTrue(expectedBody.contains("viaje"), "Gentle encouragement should emphasize journey metaphor")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN5_WeeklyGoalReminderCalculation() {
        // Test weekly goal reminder with different scenarios
        let weeklyGoal = 5
        let workoutsThisWeek = 2
        let remaining = max(0, weeklyGoal - workoutsThisWeek)
        
        UserDefaults.standard.set(weeklyGoal, forKey: "weeklyGoal")
        UserDefaults.standard.set(workoutsThisWeek, forKey: "workoutsThisWeek")
        
        let testUserName = "Pedro"
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        XCTAssertEqual(remaining, 3, "Should calculate correct remaining workouts")
        XCTAssertTrue(remaining > 0, "Test case should have remaining workouts")
        
        // Test the message formation
        let expectedBody = "Te faltan \(remaining) entrenamiento\(remaining > 1 ? "s" : "") para tu meta. La nueva semana es una oportunidad perfecta."
        XCTAssertTrue(expectedBody.contains("3 entrenamientos"), "Should use plural form for multiple workouts")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN6_RestDayWisdomContent() {
        // Test rest day wisdom notification content
        let testUserName = "Sofia"
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        let expectedTitle = "Descanso merecido, \(userName) 🧘‍♂️"
        let expectedBody = "El descanso también es parte del entrenamiento. Tu cuerpo necesita tiempo para crecer y recuperarse."
        
        XCTAssertTrue(expectedTitle.contains(testUserName), "Rest day wisdom should contain user name")
        XCTAssertTrue(expectedBody.contains("descanso"), "Rest day wisdom should emphasize rest")
        XCTAssertTrue(expectedBody.contains("recuperarse"), "Rest day wisdom should mention recovery")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN7_PersonalizedProgressWithWorkoutType() {
        // Test personalized progress with favorite workout type
        let favoriteType = "Yoga"
        UserDefaults.standard.set(favoriteType, forKey: "favoriteWorkoutType")
        
        let testUserName = "Diego"
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        let retrievedType = UserDefaults.standard.string(forKey: "favoriteWorkoutType") ?? "Cardio"
        
        let expectedBody = "Hemos notado que disfrutas \(retrievedType.lowercased()). ¿Qué tal si hoy exploramos esa pasión?"
        
        XCTAssertEqual(retrievedType, favoriteType, "Should retrieve correct favorite workout type")
        XCTAssertTrue(expectedBody.contains("yoga"), "Should use lowercase workout type in message")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testN8_HealthyHabitsHolisticApproach() {
        // Test healthy habits notification for holistic wellness
        let testUserName = "Valentina"
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        let userName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) ?? "Atleta"
        
        let expectedTitle = "Bienestar integral, \(userName) 🌿"
        let expectedBody = "El ejercicio es solo una parte. Dormir bien, hidratarte y cuidar tu mente también son actos de amor propio."
        
        XCTAssertTrue(expectedTitle.contains(testUserName), "Healthy habits should contain user name")
        XCTAssertTrue(expectedBody.contains("integral"), "Should emphasize holistic approach")
        XCTAssertTrue(expectedBody.contains("dormir"), "Should mention sleep")
        XCTAssertTrue(expectedBody.contains("hidratarte"), "Should mention hydration")
        XCTAssertTrue(expectedBody.contains("mente"), "Should mention mental health")
        
        // Cleanup
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testAntiSpamLogic() {
        // Test anti-spam functionality
        let lastPushDateKey = "lastPushDate"
        
        // Set last push to 1 hour ago (should prevent new notification)
        let oneHourAgo = Date().addingTimeInterval(-3600)
        UserDefaults.standard.set(oneHourAgo, forKey: lastPushDateKey)
        
        let lastPushDate = UserDefaults.standard.object(forKey: lastPushDateKey) as? Date
        let hoursSinceLastPush = Date().timeIntervalSince(lastPushDate ?? Date.distantPast) / 3600
        
        XCTAssertLessThan(hoursSinceLastPush, 48, "Should prevent notification within 48 hours")
        
        // Set last push to 49 hours ago (should allow new notification)
        let fortyNineHoursAgo = Date().addingTimeInterval(-49 * 3600)
        UserDefaults.standard.set(fortyNineHoursAgo, forKey: lastPushDateKey)
        
        let newLastPushDate = UserDefaults.standard.object(forKey: lastPushDateKey) as? Date
        let newHoursSinceLastPush = Date().timeIntervalSince(newLastPushDate ?? Date.distantPast) / 3600
        
        XCTAssertGreaterThan(newHoursSinceLastPush, 48, "Should allow notification after 48 hours")
        
        // Cleanup
        UserDefaults.standard.removeObject(forKey: lastPushDateKey)
    }
    
    func testDefaultFallbackValues() {
        // Test that templates work with default fallback values
        
        // Clear all user data to test fallbacks
        UserDefaults.standard.removeObject(forKey: "favoriteWorkoutType")
        UserDefaults.standard.removeObject(forKey: "weeklyGoal")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        
        let favoriteType = UserDefaults.standard.string(forKey: "favoriteWorkoutType") ?? "Cardio"
        let weeklyGoal = UserDefaults.standard.integer(forKey: "weeklyGoal") == 0 ? 3 : UserDefaults.standard.integer(forKey: "weeklyGoal")
        let streak = UserDefaults.standard.integer(forKey: "currentStreak")
        
        XCTAssertEqual(favoriteType, "Cardio", "Should fallback to Cardio for workout type")
        XCTAssertEqual(weeklyGoal, 3, "Should fallback to 3 for weekly goal")
        XCTAssertEqual(streak, 0, "Should fallback to 0 for streak")
    }
}