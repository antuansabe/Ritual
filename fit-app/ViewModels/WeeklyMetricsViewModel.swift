import Foundation
import CoreData
import SwiftUI
import Combine

@MainActor
class WeeklyMetricsViewModel: ObservableObject {
    @Published var weeklyWorkouts: Int = 0
    @Published var weeklyMinutes: Int = 0
    @Published var weeklyCalories: Int = 0
    @Published var weeklyStreak: Int = 0
    @Published var isLoading: Bool = false
    
    private let weekEngine = WeekEngine.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Listen for workout changes to refresh metrics
        NotificationCenter.default.publisher(for: .gUTLJd2whxFIrGRCEMVrNZWSFPiU5gq5)
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.refreshWeeklyStats()
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshWeeklyStats(in context: NSManagedObjectContext? = nil) async {
        guard let context = context ?? getDefaultContext() else { return }
        
        isLoading = true
        
        do {
            let workouts = try weekEngine.workoutsThisWeek(in: context)
            let totals = try weekEngine.weeklyTotals(in: context)
            let streak = weekEngine.currentStreak(from: workouts)
            
            await MainActor.run {
                self.weeklyWorkouts = totals.workouts
                self.weeklyMinutes = totals.minutes
                self.weeklyCalories = totals.calories
                self.weeklyStreak = streak
                self.isLoading = false
            }
        } catch {
            print("Error refreshing weekly stats: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func getDefaultContext() -> NSManagedObjectContext? {
        // Try to get the default context from the persistent container
        return GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
    }
    
    /// Get formatted string for display
    func formattedWeeklyWorkouts() -> String {
        return "\(weeklyWorkouts)"
    }
    
    func formattedWeeklyMinutes() -> String {
        return "\(weeklyMinutes)"
    }
    
    func formattedWeeklyCalories() -> String {
        return "\(weeklyCalories)"
    }
    
    func formattedWeeklyStreak() -> String {
        return "\(weeklyStreak)"
    }
    
    /// Check if it's Monday (metrics reset day)
    func isMetricsResetDay() -> Bool {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: Date()) == 2 // Monday
    }
    
    /// Get days remaining in current week
    func daysRemainingInWeek() -> Int {
        return weekEngine.daysRemainingInWeek()
    }
}