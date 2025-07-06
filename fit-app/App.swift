import SwiftUI

@main
struct FitApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var weeklyGoalManager = WeeklyGoalManager.shared
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ZStack {
                    MainAppView()
                        .environmentObject(authViewModel)
                        .environmentObject(weeklyGoalManager)
                        .preferredColorScheme(.dark)
                    
                    GlobalGoalAchievementOverlay()
                        .environmentObject(weeklyGoalManager)
                }
                    .onAppear {
                        // Set default username if not already set
                        if UserDefaults.standard.string(forKey: "userName") == nil {
                            UserDefaults.standard.set("Antonio", forKey: "userName")
                        }
                    }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}