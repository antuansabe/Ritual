import Foundation
import SwiftUI
import CoreData
import Combine

@MainActor
final class HistorialViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var animateOnAppear = false
    @Published var currentDate = Date()
    @Published var showingTrainingDetail = false
    @Published var selectedDateWorkouts: [WorkoutEntity] = []
    @Published var selectedDate = Date()
    
    // Cached computed properties to avoid recalculation in body
    @Published private(set) var currentMonthWorkouts: Int = 0
    @Published private(set) var uniqueWorkoutDays: Int = 0
    @Published private(set) var yearStats: (totalWorkouts: Int, totalMinutes: Int, currentStreak: Int) = (0, 0, 0)
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2  // Monday
        return cal
    }()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private weak var workouts: FetchedResults<WorkoutEntity>?
    
    // MARK: - Initialization
    init() {
        // Setup date change monitoring
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCurrentDate()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func configure(with workouts: FetchedResults<WorkoutEntity>) {
        self.workouts = workouts
        updateCachedProperties()
    }
    
    func onAppear() {
        guard !animateOnAppear else { return } // Prevent double animation
        
        withAnimation(.easeOut(duration: 0.8)) {
            animateOnAppear = true
        }
        
        updateCachedProperties()
    }
    
    func onDateTapped(_ date: Date, workouts: [WorkoutEntity]) {
        selectedDate = date
        selectedDateWorkouts = getWorkoutsForDate(date, from: Array(self.workouts ?? []))
        showingTrainingDetail = true
    }
    
    func updateCurrentDate() {
        let newDate = Date()
        if !calendar.isDate(currentDate, inSameDayAs: newDate) {
            currentDate = newDate
            updateCachedProperties()
        }
    }
    
    // MARK: - Private Methods
    private func updateCachedProperties() {
        guard let workouts = workouts else { return }
        
        // Calculate values asynchronously to avoid blocking UI
        Task { @MainActor in
            let currentMonth = self.calendar.component(.month, from: self.currentDate)
            let currentYear = self.calendar.component(.year, from: self.currentDate)
            
            // Calculate current month workouts
            let monthWorkouts = Array(workouts).filter { workout in
                let workoutMonth = self.calendar.component(.month, from: workout.date ?? Date())
                let workoutYear = self.calendar.component(.year, from: workout.date ?? Date())
                return workoutMonth == currentMonth && workoutYear == currentYear
            }.count
            
            // Calculate unique workout days
            let workoutDates = Set(Array(workouts).compactMap { workout in
                let workoutMonth = self.calendar.component(.month, from: workout.date ?? Date())
                let workoutYear = self.calendar.component(.year, from: workout.date ?? Date())
                if workoutMonth == currentMonth && workoutYear == currentYear {
                    return self.calendar.startOfDay(for: workout.date ?? Date())
                }
                return nil
            })
            let uniqueDays = workoutDates.count
            
            // Calculate year stats
            let yearWorkouts = Array(workouts).filter {
                self.calendar.component(.year, from: $0.date ?? Date()) == currentYear
            }
            
            let totalWorkouts = yearWorkouts.count
            let totalMinutes = yearWorkouts.reduce(0) { $0 + Int($1.duration) }
            let currentStreak = self.calculateCurrentStreak(from: Array(workouts))
            
            // Update properties directly since we're already on MainActor
            self.currentMonthWorkouts = monthWorkouts
            self.uniqueWorkoutDays = uniqueDays
            self.yearStats = (totalWorkouts: totalWorkouts, totalMinutes: totalMinutes, currentStreak: currentStreak)
        }
    }
    
    private func getWorkoutsForDate(_ date: Date, from workouts: [WorkoutEntity]) -> [WorkoutEntity] {
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
    }
    
    private func calculateCurrentStreak(from workouts: [WorkoutEntity]) -> Int {
        let today = Date()
        let sortedWorkouts = workouts
            .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        
        var streak = 0
        var currentDate = today
        let calendar = Calendar.current
        
        // Check if we worked out today or yesterday to start streak
        let hasWorkoutToday = sortedWorkouts.contains { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: today)
        }
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let hasWorkoutYesterday = sortedWorkouts.contains { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: yesterday)
        }
        
        if hasWorkoutToday {
            currentDate = today
        } else if hasWorkoutYesterday {
            currentDate = yesterday
        } else {
            return 0 // No recent workouts
        }
        
        // Count consecutive days with workouts
        for i in 0..<30 { // Limit to 30 days to prevent long calculations
            let checkDate = calendar.date(byAdding: .day, value: -i, to: currentDate) ?? currentDate
            
            let hasWorkout = sortedWorkouts.contains { workout in
                calendar.isDate(workout.date ?? Date(), inSameDayAs: checkDate)
            }
            
            if hasWorkout {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
}