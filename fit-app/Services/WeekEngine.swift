import Foundation
import CoreData

/// Centralizes week-based calculations following these rules:
/// - Week runs Monday 00:00 → Sunday 23:59 (user's local timezone)
/// - Weekly goals and daily streak reset every Monday
/// - Streak counts consecutive days training within current week (not consecutive weeks)
/// - Workouts crossing midnight are assigned to start date
/// - All dates stored in UTC; UI always shows in local timezone
final class WeekEngine {
    static let shared = WeekEngine()
    private init() { }

    private let calendar = Calendar.current

    /// Returns the date (Monday) that starts the local week for `date`.
    func weekStart(for date: Date) -> Date {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = 2  // 2 = Monday
        return calendar.date(from: components)!
    }
    
    /// Returns the date (Sunday) that ends the local week for `date`.
    func weekEnd(for date: Date) -> Date {
        let start = weekStart(for: date)
        return calendar.date(byAdding: .day, value: 6, to: start)!
    }

    /// Workouts from current week (Monday to Sunday inclusive)
    func workoutsThisWeek(in context: NSManagedObjectContext) throws -> [WorkoutEntity] {
        let start = weekStart(for: Date())
        let end = calendar.date(byAdding: .day, value: 7, to: start)! // Next Monday 00:00
        
        let request = WorkoutEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
        
        return try context.fetch(request)
    }
    
    /// Workouts from specific week containing the given date
    func workouts(for date: Date, in context: NSManagedObjectContext) throws -> [WorkoutEntity] {
        let start = weekStart(for: date)
        let end = calendar.date(byAdding: .day, value: 7, to: start)! // Next Monday 00:00
        
        let request = WorkoutEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
        
        return try context.fetch(request)
    }

    /// Consecutive days trained from Monday until today (within current week only)
    func currentStreak(from workouts: [WorkoutEntity]) -> Int {
        // Get unique training days, converted to local timezone start of day
        let trainingDays = Set(workouts.compactMap { workout -> Date? in
            guard let workoutDate = workout.date else { return nil }
            return calendar.startOfDay(for: workoutDate)
        })
        
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date()) // Today
        let weekStartDate = weekStart(for: Date())
        
        // Count backwards from today until we find a gap or reach start of week
        while currentDay >= weekStartDate {
            if trainingDays.contains(currentDay) {
                streak += 1
                currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay)!
            } else {
                break // Streak broken
            }
        }
        
        return streak
    }
    
    /// Calculate weekly totals (workouts, minutes, calories) for current week
    func weeklyTotals(in context: NSManagedObjectContext) throws -> (workouts: Int, minutes: Int, calories: Int) {
        let workouts = try workoutsThisWeek(in: context)
        
        let totalWorkouts = workouts.count
        let totalMinutes = workouts.reduce(0) { $0 + Int($1.duration) }
        let totalCalories = workouts.reduce(0) { $0 + Int($1.calories) }
        
        return (workouts: totalWorkouts, minutes: totalMinutes, calories: totalCalories)
    }
    
    /// Check if a date is in the current week
    func isInCurrentWeek(_ date: Date) -> Bool {
        let thisWeekStart = weekStart(for: Date())
        let thisWeekEnd = calendar.date(byAdding: .day, value: 7, to: thisWeekStart)!
        return date >= thisWeekStart && date < thisWeekEnd
    }
    
    /// Get the day of week (1 = Monday, 7 = Sunday) for a date
    func dayOfWeek(for date: Date) -> Int {
        let weekday = calendar.component(.weekday, from: date)
        // Convert Sunday = 1, Monday = 2... to Monday = 1, Sunday = 7
        return weekday == 1 ? 7 : weekday - 1
    }
    
    /// Format date for consistent display in UI (respects user's locale and timezone)
    func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter.string(from: date)
    }
    
    /// Get start of day for a date in local timezone
    func localStartOfDay(for date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }
}

// MARK: - Weekly Goal Support
extension WeekEngine {
    /// Calculate progress towards weekly goal
    func weeklyProgress(goal: Int, in context: NSManagedObjectContext) throws -> Double {
        let totals = try weeklyTotals(in: context)
        guard goal > 0 else { return 0.0 }
        return min(Double(totals.workouts) / Double(goal), 1.0)
    }
    
    /// Days remaining in current week
    func daysRemainingInWeek() -> Int {
        let today = Date()
        let weekEnd = self.weekEnd(for: today)
        let daysRemaining = calendar.dateComponents([.day], from: calendar.startOfDay(for: today), to: calendar.startOfDay(for: weekEnd)).day ?? 0
        return max(0, daysRemaining)
    }
}