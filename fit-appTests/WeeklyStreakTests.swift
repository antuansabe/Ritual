import XCTest
import CoreData
@testable import fit_app

final class WeeklyStreakTests: XCTestCase {
    var viewModel: WorkoutViewModel!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Create in-memory Core Data stack for testing
        let container = NSPersistentContainer(name: "fit_app")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        context = container.viewContext
        viewModel = WorkoutViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }
    
    func testWeeklyStreakCalculation() throws {
        let calendar = Calendar.current
        let today = Date()
        
        // Create workouts for Monday, Tuesday, Thursday of current week (2 weeks with activity)
        let mondayThisWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let tuesdayThisWeek = calendar.date(byAdding: .day, value: 1, to: mondayThisWeek)!
        let thursdayThisWeek = calendar.date(byAdding: .day, value: 3, to: mondayThisWeek)!
        
        // Previous week workouts
        let mondayLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: mondayThisWeek)!
        let wednesdayLastWeek = calendar.date(byAdding: .day, value: 2, to: mondayLastWeek)!
        
        let workouts = [
            createMockWorkout(date: mondayThisWeek),
            createMockWorkout(date: tuesdayThisWeek),
            createMockWorkout(date: thursdayThisWeek),
            createMockWorkout(date: mondayLastWeek),
            createMockWorkout(date: wednesdayLastWeek)
        ]
        
        // Test weekly streak calculation
        let weeklyStreak = viewModel.calculateWeeklyStreak(workouts: workouts)
        
        // Should return 2 (current week + last week both have workouts)
        XCTAssertEqual(weeklyStreak, 2, "Weekly streak should be 2 for workouts in current and previous week")
    }
    
    func testWeeklyStreakWithGap() throws {
        let calendar = Calendar.current
        let today = Date()
        
        // Create workouts for current week and 2 weeks ago (gap in between)
        let mondayThisWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let monday2WeeksAgo = calendar.date(byAdding: .weekOfYear, value: -2, to: mondayThisWeek)!
        
        let workouts = [
            createMockWorkout(date: mondayThisWeek),
            createMockWorkout(date: monday2WeeksAgo)
        ]
        
        let weeklyStreak = viewModel.calculateWeeklyStreak(workouts: workouts)
        
        // Should return 1 (only current week, gap breaks streak)
        XCTAssertEqual(weeklyStreak, 1, "Weekly streak should be 1 when there's a gap")
    }
    
    func testEmptyWorkouts() throws {
        let weeklyStreak = viewModel.calculateWeeklyStreak(workouts: [])
        XCTAssertEqual(weeklyStreak, 0, "Weekly streak should be 0 for empty workouts")
    }
    
    private func createMockWorkout(date: Date) -> WorkoutEntity {
        let workout = WorkoutEntity(context: context)
        workout.date = date
        workout.type = "Cardio"
        workout.duration = 30
        workout.calories = 200
        return workout
    }
}