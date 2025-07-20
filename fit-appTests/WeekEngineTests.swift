import XCTest
import CoreData
@testable import fit_app

final class WeekEngineTests: XCTestCase {
    var weekEngine: WeekEngine!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        weekEngine = WeekEngine.shared
        
        // Create in-memory Core Data stack for testing
        let container = NSPersistentContainer(name: "WorkoutHeroModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        context = container.viewContext
    }
    
    override func tearDownWithError() throws {
        weekEngine = nil
        context = nil
    }
    
    // MARK: - Week Start Tests
    
    func testWeekStartMonday() throws {
        // Test with GMT timezone
        let gmt = TimeZone(secondsFromGMT: 0)!
        var calendar = Calendar.current
        calendar.timeZone = gmt
        
        // Friday, July 18, 2025
        let friday = calendar.date(from: DateComponents(year: 2025, month: 7, day: 18))!
        let weekStart = weekEngine.weekStart(for: friday)
        
        // Should return Monday, July 14, 2025
        XCTAssertEqual(calendar.component(.weekday, from: weekStart), 2, "Week should start on Monday")
        XCTAssertEqual(calendar.component(.day, from: weekStart), 14, "Should be July 14th")
        XCTAssertEqual(calendar.component(.month, from: weekStart), 7, "Should be July")
        XCTAssertEqual(calendar.component(.year, from: weekStart), 2025, "Should be 2025")
    }
    
    func testWeekStartDifferentTimezones() throws {
        // Test with different timezones
        let timezones = [
            TimeZone(secondsFromGMT: -6 * 3600)!, // GMT-6
            TimeZone(secondsFromGMT: 0)!,         // GMT
            TimeZone(secondsFromGMT: 1 * 3600)!   // GMT+1
        ]
        
        for timezone in timezones {
            var calendar = Calendar.current
            calendar.timeZone = timezone
            
            // Same input date for each timezone
            let testDate = calendar.date(from: DateComponents(year: 2025, month: 7, day: 18, hour: 15))!
            let weekStart = weekEngine.weekStart(for: testDate)
            
            // All should return Monday
            XCTAssertEqual(calendar.component(.weekday, from: weekStart), 2, 
                          "Week should start on Monday for timezone \(timezone.identifier)")
        }
    }
    
    // MARK: - Streak Tests
    
    func testStreakResetsOnMonday() throws {
        // Create fake workouts: Thu + Fri + Sat (previous week) then Mon (this week)
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        // Previous week: Thursday, Friday, Saturday
        let prevWeekThu = calendar.date(byAdding: .day, value: -4, to: thisWeekStart)!
        let prevWeekFri = calendar.date(byAdding: .day, value: -3, to: thisWeekStart)!
        let prevWeekSat = calendar.date(byAdding: .day, value: -2, to: thisWeekStart)!
        
        // This week: Monday
        let thisWeekMon = thisWeekStart
        
        let workouts = [
            createMockWorkout(date: prevWeekThu),
            createMockWorkout(date: prevWeekFri),
            createMockWorkout(date: prevWeekSat),
            createMockWorkout(date: thisWeekMon)
        ]
        
        let streak = weekEngine.currentStreak(from: workouts)
        
        // Should only count Monday (this week), not previous week
        XCTAssertEqual(streak, 1, "Streak should reset on Monday, only counting current week")
    }
    
    func testStreakConsecutiveDaysThisWeek() throws {
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        // Monday, Tuesday, Wednesday of this week
        let monday = thisWeekStart
        let tuesday = calendar.date(byAdding: .day, value: 1, to: monday)!
        let wednesday = calendar.date(byAdding: .day, value: 2, to: monday)!
        
        let workouts = [
            createMockWorkout(date: monday),
            createMockWorkout(date: tuesday),
            createMockWorkout(date: wednesday)
        ]
        
        // If today is Wednesday or later in the week
        if calendar.compare(today, to: wednesday, toGranularity: .day) != .orderedAscending {
            let streak = weekEngine.currentStreak(from: workouts)
            XCTAssertEqual(streak, 3, "Should count 3 consecutive days if today is Wed or later")
        }
    }
    
    func testStreakWithGap() throws {
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        // Monday and Wednesday (skip Tuesday)
        let monday = thisWeekStart
        let wednesday = calendar.date(byAdding: .day, value: 2, to: monday)!
        
        let workouts = [
            createMockWorkout(date: monday),
            createMockWorkout(date: wednesday)
        ]
        
        let streak = weekEngine.currentStreak(from: workouts)
        
        // If today is Wednesday, streak should be 1 (only Wednesday, gap broke it)
        if calendar.isDate(today, inSameDayAs: wednesday) {
            XCTAssertEqual(streak, 1, "Streak should be broken by gap")
        }
    }
    
    // MARK: - Weekly Workouts Tests
    
    func testWorkoutsThisWeek() throws {
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        // Create workouts in this week and previous week
        let mondayThisWeek = thisWeekStart
        let tuesdayThisWeek = calendar.date(byAdding: .day, value: 1, to: mondayThisWeek)!
        let sundayLastWeek = calendar.date(byAdding: .day, value: -1, to: mondayThisWeek)!
        
        let thisWeekWorkout1 = createMockWorkout(date: mondayThisWeek)
        let thisWeekWorkout2 = createMockWorkout(date: tuesdayThisWeek)
        let lastWeekWorkout = createMockWorkout(date: sundayLastWeek)
        
        // Save to context
        try context.save()
        
        let thisWeekWorkouts = try weekEngine.workoutsThisWeek(in: context)
        
        // Should only include this week's workouts
        XCTAssertEqual(thisWeekWorkouts.count, 2, "Should return only this week's workouts")
        
        let thisWeekDates = thisWeekWorkouts.compactMap { $0.date }
        XCTAssertTrue(thisWeekDates.contains { calendar.isDate($0, inSameDayAs: mondayThisWeek) })
        XCTAssertTrue(thisWeekDates.contains { calendar.isDate($0, inSameDayAs: tuesdayThisWeek) })
        XCTAssertFalse(thisWeekDates.contains { calendar.isDate($0, inSameDayAs: sundayLastWeek) })
    }
    
    // MARK: - Date Utilities Tests
    
    func testIsInCurrentWeek() throws {
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        let mondayThisWeek = thisWeekStart
        let sundayThisWeek = calendar.date(byAdding: .day, value: 6, to: mondayThisWeek)!
        let mondayNextWeek = calendar.date(byAdding: .day, value: 7, to: mondayThisWeek)!
        
        XCTAssertTrue(weekEngine.isInCurrentWeek(mondayThisWeek), "Monday this week should be in current week")
        XCTAssertTrue(weekEngine.isInCurrentWeek(sundayThisWeek), "Sunday this week should be in current week")
        XCTAssertFalse(weekEngine.isInCurrentWeek(mondayNextWeek), "Monday next week should not be in current week")
    }
    
    func testDayOfWeek() throws {
        let calendar = Calendar.current
        let today = Date()
        let thisWeekStart = weekEngine.weekStart(for: today)
        
        let monday = thisWeekStart
        let tuesday = calendar.date(byAdding: .day, value: 1, to: monday)!
        let sunday = calendar.date(byAdding: .day, value: 6, to: monday)!
        
        XCTAssertEqual(weekEngine.dayOfWeek(for: monday), 1, "Monday should be day 1")
        XCTAssertEqual(weekEngine.dayOfWeek(for: tuesday), 2, "Tuesday should be day 2")
        XCTAssertEqual(weekEngine.dayOfWeek(for: sunday), 7, "Sunday should be day 7")
    }
    
    // MARK: - Midnight Crossing Tests
    
    func testMidnightCrossingWorkout() throws {
        let calendar = Calendar.current
        
        // Create a workout that would cross midnight in some timezones
        let components = DateComponents(year: 2025, month: 7, day: 18, hour: 23, minute: 45)
        let workoutDate = calendar.date(from: components)!
        
        let workout = createMockWorkout(date: workoutDate)
        
        // The workout should be assigned to July 18th regardless of timezone interpretation
        let workoutDay = weekEngine.localStartOfDay(for: workout.date!)
        let expectedDay = calendar.startOfDay(for: workoutDate)
        
        XCTAssertEqual(workoutDay, expectedDay, "Workout should be assigned to start date")
    }
    
    // MARK: - Helper Methods
    
    private func createMockWorkout(date: Date) -> WorkoutEntity {
        let workout = WorkoutEntity(context: context)
        workout.date = date
        workout.type = "Cardio"
        workout.duration = 30
        workout.calories = 200
        workout.id = UUID()
        return workout
    }
}