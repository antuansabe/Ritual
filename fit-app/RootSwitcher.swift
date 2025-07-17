import SwiftUI

struct RootSwitcher: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var persistenceController: c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7
    @EnvironmentObject var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm
    @State private var hasCompletedOnboarding = false
    
    private var hasSeenWelcome: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    private var hasSeenOnboarding: Bool {
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding") ?? false
    }
    
    var body: some View {
        Group {
            if authViewModel.showGoodbyeView {
                // Show goodbye screen when logging out
                ApJ08JFGfVrR1tOMiHbVWMDwIafd73iX()
                    .environmentObject(authViewModel)
                    .environmentObject(userProfileManager)
                    .transition(.scale.combined(with: .opacity))
            } else if !authViewModel.isLoggedIn {
                // Not authenticated - show login
                wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
                    .environmentObject(authViewModel)
                    .environmentObject(userProfileManager)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        // Reset navigation state when user logs out
                        navigationStateManager.showWelcome = false
                        navigationStateManager.rootTab = 0
                    }
            } else if !hasSeenOnboarding && !hasCompletedOnboarding {
                // First-time user - show onboarding
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .transition(.opacity)
                    .onDisappear {
                        // After onboarding, trigger welcome
                        if hasCompletedOnboarding {
                            navigationStateManager.triggerWelcome()
                        }
                    }
            } else if navigationStateManager.showWelcome {
                // Show welcome screen once after login/onboarding
                FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
                    .environmentObject(authViewModel)
                    .environmentObject(userProfileManager)
                    .environmentObject(navigationStateManager)
                    .transition(.scale.combined(with: .opacity))
            } else {
                // Main app - TabBar scaffold
                TabScaffold(selected: $navigationStateManager.rootTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isLoggedIn)
        .animation(.easeInOut(duration: 0.7), value: hasSeenWelcome)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.showGoodbyeView)
        .animation(.easeInOut(duration: 0.3), value: hasCompletedOnboarding)
        .animation(.easeInOut(duration: 0.5), value: navigationStateManager.showWelcome)
        .onAppear {
            setupInitialNavigationState()
        }
    }
    
    private func setupInitialNavigationState() {
        // Set up initial welcome state based on authentication and previous welcome status
        if authViewModel.isLoggedIn && !hasSeenWelcome && hasSeenOnboarding {
            navigationStateManager.triggerWelcome()
        }
    }
}

// Create the TabScaffold view that was referenced
struct TabScaffold: View {
    @Binding var selected: Int
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var persistenceController: c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7
    @EnvironmentObject var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var body: some View {
        ZStack {
            KQMbB3ZqQUMbSR2AGsJpCknS8pSLtpb6()
                .environmentObject(authViewModel)
                .environmentObject(persistenceController)
                .environmentObject(userProfileManager)
                .environmentObject(navigationStateManager)
            
            isqjtgeChdmyuavMEwRRyV8yoeHAhS9Z()
                .environmentObject(persistenceController)
        }
        .catchCrash()
    }
}

#Preview {
    RootSwitcher()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
        .environmentObject(c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX)
        .environmentObject(gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX)
        .environmentObject(NavigationStateManager())
}