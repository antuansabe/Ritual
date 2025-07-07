import SwiftUI

@main
struct FitApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var weeklyGoalManager = WeeklyGoalManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
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
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
        }
    }
}
