import Foundation
import UserNotifications
import CoreData

// MARK: - Notification Scheduler for Motivational Push Notifications
class NotificationScheduler: ObservableObject {
    
    // MARK: - Singleton
    static let shared = NotificationScheduler()
    
    // MARK: - Constants
    private let lastPushDateKey = "lastPushDate"
    private let pushIntervalHours: TimeInterval = 48 // Anti-spam: 48 hours between notifications
    private let notificationIdentifierPrefix = "motivational_"
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Permission Management
    
    /// Request notification permissions on first app launch after login
    func requestPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .denied:
                print("📱 Notifications denied by user")
            case .authorized, .provisional, .ephemeral:
                print("📱 Notifications already authorized")
                self.scheduleRandomMotivationalNotification()
            @unknown default:
                print("📱 Unknown notification authorization status")
            }
        }
    }
    
    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("📱 Notification permission granted")
                    self.scheduleRandomMotivationalNotification()
                } else {
                    print("📱 Notification permission denied")
                }
            }
            
            if let error = error {
                print("📱 Error requesting notifications: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Anti-Spam Logic
    
    private var canSendNotification: Bool {
        guard let lastPushDate = UserDefaults.standard.object(forKey: lastPushDateKey) as? Date else {
            return true // First time, allow notification
        }
        
        let hoursSinceLastPush = Date().timeIntervalSince(lastPushDate) / 3600
        return hoursSinceLastPush >= pushIntervalHours
    }
    
    private func updateLastPushDate() {
        UserDefaults.standard.set(Date(), forKey: lastPushDateKey)
    }
    
    // MARK: - Core Notification Scheduling
    
    /// Schedule a random motivational notification if conditions are met
    func scheduleRandomMotivationalNotification() {
        guard canSendNotification else {
            print("📱 Skipping notification - too soon since last push")
            return
        }
        
        // Clear any existing scheduled notifications
        cancelAllScheduledNotifications()
        
        // Randomly select one of the 8 notification functions
        let notificationFunctions = [
            scheduleN1_MorningMotivation,
            scheduleN2_StreakReminder,
            scheduleN3_ProgressCelebration,
            scheduleN4_GentleEncouragement,
            scheduleN5_WeeklyGoalReminder,
            scheduleN6_RestDayWisdom,
            scheduleN7_PersonalizedProgress,
            scheduleN8_HealthyHabits
        ]
        
        if let randomFunction = notificationFunctions.randomElement() {
            randomFunction()
            updateLastPushDate()
        }
    }
    
    // MARK: - 8 Motivational Notification Functions
    
    /// N1: Morning motivation (7-9 AM)
    private func scheduleN1_MorningMotivation() {
        let userName = getUserName()
        let title = "Buenos días, \(userName) ☀️"
        let body = "Un nuevo día te espera lleno de posibilidades. ¿Qué tipo de energía quieres crear hoy?"
        
        let trigger = createMorningTrigger(hour: 8, minute: 0) // 8:00 AM
        scheduleNotification(identifier: "motivational_n1", title: title, body: body, trigger: trigger)
    }
    
    /// N2: Streak reminder (evening, only if user has a streak)
    private func scheduleN2_StreakReminder() {
        guard getCurrentStreak() > 0 else { return }
        
        let userName = getUserName()
        let streak = getCurrentStreak()
        let title = "¡Increíble, \(userName)! 🔥"
        let body = "Llevas \(streak) día\(streak > 1 ? "s" : "") consecutivo\(streak > 1 ? "s" : "") cuidándote. Tu constancia inspira."
        
        let trigger = createEveningTrigger(hour: 18, minute: 0) // 6:00 PM
        scheduleNotification(identifier: "motivational_n2", title: title, body: body, trigger: trigger)
    }
    
    /// N3: Progress celebration (afternoon, if user has recent workouts)
    private func scheduleN3_ProgressCelebration() {
        guard hasRecentActivity() else { return }
        
        let userName = getUserName()
        let title = "¡Mira tu progreso, \(userName)! 📈"
        let body = "Cada entrenamiento que completas te acerca más a la mejor versión de ti mismo. ¡Sigue así!"
        
        let trigger = createAfternoonTrigger(hour: 15, minute: 30) // 3:30 PM
        scheduleNotification(identifier: "motivational_n3", title: title, body: body, trigger: trigger)
    }
    
    /// N4: Gentle encouragement (mid-morning, if user hasn't worked out recently)
    private func scheduleN4_GentleEncouragement() {
        guard !hasRecentActivity() else { return }
        
        let userName = getUserName()
        let title = "Hola, \(userName) 🌱"
        let body = "No hay prisa. Tu bienestar es un viaje, no una carrera. Cuando te sientas listo, aquí estaremos."
        
        let trigger = createMorningTrigger(hour: 10, minute: 30) // 10:30 AM
        scheduleNotification(identifier: "motivational_n4", title: title, body: body, trigger: trigger)
    }
    
    /// N5: Weekly goal reminder (Sunday evening)
    private func scheduleN5_WeeklyGoalReminder() {
        let userName = getUserName()
        let weeklyGoal = getWeeklyGoal()
        let workoutsThisWeek = getWorkoutsThisWeek()
        let remaining = max(0, weeklyGoal - workoutsThisWeek)
        
        let title = "Reflexión semanal, \(userName) 🎯"
        let body = remaining > 0 ? 
            "Te faltan \(remaining) entrenamiento\(remaining > 1 ? "s" : "") para tu meta. La nueva semana es una oportunidad perfecta." :
            "¡Meta semanal completada! Tu disciplina es admirable. 🌟"
        
        let trigger = createWeeklyTrigger(weekday: 1, hour: 19, minute: 0) // Sunday 7:00 PM
        scheduleNotification(identifier: "motivational_n5", title: title, body: body, trigger: trigger)
    }
    
    /// N6: Rest day wisdom (if user worked out yesterday)
    private func scheduleN6_RestDayWisdom() {
        guard hasWorkedOutYesterday() else { return }
        
        let userName = getUserName()
        let title = "Descanso merecido, \(userName) 🧘‍♂️"
        let body = "El descanso también es parte del entrenamiento. Tu cuerpo necesita tiempo para crecer y recuperarse."
        
        let trigger = createMorningTrigger(hour: 9, minute: 0) // 9:00 AM
        scheduleNotification(identifier: "motivational_n6", title: title, body: body, trigger: trigger)
    }
    
    /// N7: Personalized progress (based on user's favorite workout type)
    private func scheduleN7_PersonalizedProgress() {
        let userName = getUserName()
        let favoriteType = getFavoriteWorkoutType()
        let title = "Tu evolución, \(userName) 💪"
        let body = "Hemos notado que disfrutas \(favoriteType.lowercased()). ¿Qué tal si hoy exploramos esa pasión?"
        
        let trigger = createAfternoonTrigger(hour: 16, minute: 0) // 4:00 PM
        scheduleNotification(identifier: "motivational_n7", title: title, body: body, trigger: trigger)
    }
    
    /// N8: Healthy habits (evening wellness reminder)
    private func scheduleN8_HealthyHabits() {
        let userName = getUserName()
        let title = "Bienestar integral, \(userName) 🌿"
        let body = "El ejercicio es solo una parte. Dormir bien, hidratarte y cuidar tu mente también son actos de amor propio."
        
        let trigger = createEveningTrigger(hour: 20, minute: 30) // 8:30 PM
        scheduleNotification(identifier: "motivational_n8", title: title, body: body, trigger: trigger)
    }
    
    // MARK: - Helper Methods for Triggers
    
    private func createMorningTrigger(hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    private func createAfternoonTrigger(hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    private func createEveningTrigger(hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    private func createWeeklyTrigger(weekday: Int, hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday // 1 = Sunday
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }
    
    // MARK: - Core Data Helper Methods
    
    private func getUserName() -> String {
        // Try SecureStorage first
        if let secureUserName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) {
            return secureUserName
        }
        return "Atleta" // Default fallback
    }
    
    private func getCurrentStreak() -> Int {
        // This would need to access Core Data to calculate streak
        // For now, returning a placeholder
        return UserDefaults.standard.integer(forKey: "currentStreak")
    }
    
    private func hasRecentActivity() -> Bool {
        // Check if user has worked out in last 3 days
        let lastWorkoutDate = UserDefaults.standard.object(forKey: "lastWorkoutDate") as? Date ?? Date.distantPast
        let daysSinceLastWorkout = Calendar.current.dateComponents([.day], from: lastWorkoutDate, to: Date()).day ?? 999
        return daysSinceLastWorkout <= 3
    }
    
    private func hasWorkedOutYesterday() -> Bool {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let lastWorkoutDate = UserDefaults.standard.object(forKey: "lastWorkoutDate") as? Date ?? Date.distantPast
        return Calendar.current.isDate(lastWorkoutDate, inSameDayAs: yesterday)
    }
    
    private func getWeeklyGoal() -> Int {
        return UserDefaults.standard.integer(forKey: "weeklyGoal") == 0 ? 3 : UserDefaults.standard.integer(forKey: "weeklyGoal")
    }
    
    private func getWorkoutsThisWeek() -> Int {
        // This would need Core Data access to count workouts this week
        return UserDefaults.standard.integer(forKey: "workoutsThisWeek")
    }
    
    private func getFavoriteWorkoutType() -> String {
        return UserDefaults.standard.string(forKey: "favoriteWorkoutType") ?? "Cardio"
    }
    
    // MARK: - Notification Scheduling Helper
    
    private func scheduleNotification(identifier: String, title: String, body: String, trigger: UNCalendarNotificationTrigger) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("📱 Error scheduling notification \(identifier): \(error.localizedDescription)")
            } else {
                print("📱 Scheduled notification: \(identifier)")
            }
        }
    }
    
    // MARK: - Notification Management
    
    func cancelAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("📱 Cancelled all scheduled notifications")
    }
    
    func cancelNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("📱 Cancelled notification: \(identifier)")
    }
    
    // MARK: - Public Interface
    
    /// Call this when user completes a workout to update tracking
    func updateWorkoutStats() {
        UserDefaults.standard.set(Date(), forKey: "lastWorkoutDate")
        
        // Update current streak
        let currentStreak = calculateStreakFromWorkouts()
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        
        // Update workouts this week
        let workoutsThisWeek = calculateWorkoutsThisWeek()
        UserDefaults.standard.set(workoutsThisWeek, forKey: "workoutsThisWeek")
    }
    
    private func calculateStreakFromWorkouts() -> Int {
        // Simplified streak calculation - in real app, this would query Core Data
        return getCurrentStreak() + 1
    }
    
    private func calculateWorkoutsThisWeek() -> Int {
        // Simplified calculation - in real app, this would query Core Data
        return getWorkoutsThisWeek() + 1
    }
}

// MARK: - Notification Scheduler Extensions

extension NotificationScheduler {
    
    /// Initialize notifications for first-time user
    func setupForNewUser() {
        requestPermissionIfNeeded()
    }
    
    /// Update user's favorite workout type for personalized notifications
    func updateFavoriteWorkoutType(_ type: String) {
        UserDefaults.standard.set(type, forKey: "favoriteWorkoutType")
    }
    
    /// Check if notifications are authorized
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}