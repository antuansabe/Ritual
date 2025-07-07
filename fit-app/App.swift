import SwiftUI

@main
struct FitApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var weeklyGoalManager = WeeklyGoalManager.shared
    @StateObject private var userProfileManager = UserProfileManager.shared
    
    private var hasSeenWelcome: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.showingGoodbye {
                    // Show goodbye screen during logout process
                    GoodbyeView()
                        .environmentObject(authViewModel)
                        .environmentObject(userProfileManager)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else if authViewModel.isAuthenticated {
                    if hasSeenWelcome {
                        // Returning user - go directly to main app
                        ZStack {
                            MainAppView()
                                .environmentObject(authViewModel)
                                .environmentObject(weeklyGoalManager)
                                .environmentObject(userProfileManager)
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
                        // First-time user - show welcome screen
                        WelcomeView()
                            .environmentObject(authViewModel)
                            .environmentObject(userProfileManager)
                            .preferredColorScheme(.dark)
                            .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(userProfileManager)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
            .animation(.easeInOut(duration: 0.7), value: hasSeenWelcome)
            .animation(.easeInOut(duration: 0.5), value: authViewModel.showingGoodbye)
        }
    }
}
