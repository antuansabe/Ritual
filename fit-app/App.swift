import SwiftUI

// MARK: - AppNavigationManager
final class AppNavigationManager: ObservableObject {
    @Published var rootTab: Int = 0          // 0-Inicio, 1-Registrar, ...
    @Published var showWelcome = false       // se activa 1 sola vez
    
    // MARK: - Methods
    
    /// Check if current view is root view for back button context
    func isRootView() -> Bool {
        return rootTab == 0
    }
    
    /// Navigate to specific tab
    func navigateToTab(_ tab: Int) {
        rootTab = tab
    }
    
    /// Trigger welcome flow
    func triggerWelcome() {
        showWelcome = true
    }
    
    /// Complete welcome flow
    func completeWelcome() {
        showWelcome = false
    }
}

// MARK: - CrashLogger
final class CrashLogger {
    static let shared = CrashLogger()
    
    private init() {}
    
    func record(_ exception: Notification) {
        print("🚨 Exception caught: \(exception.description)")
    }
    
    func record(error: Error, context: String = "") {
        print("🚨 Error: \(error.localizedDescription) - Context: \(context)")
    }
    
    func recordPerformanceIssue(_ message: String, in view: String) {
        print("⚠️ Performance issue in \(view): \(message)")
    }
}

extension View {
    func catchCrash() -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NSException"))) { notification in
            CrashLogger.shared.record(notification)
        }
    }
}

// MARK: - RootSwitcher
struct RootSwitcher: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var navigationStateManager: AppNavigationManager
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
    @EnvironmentObject var navigationStateManager: AppNavigationManager
    
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

@main
struct bznZq23oqpIdNqA1wbzgsmcc11mjbUC2: App {
    @StateObject private var authViewModel = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
    @StateObject private var persistenceController = c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var userProfileManager = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var navigationStateManager = AppNavigationManager()
    @State private var hasCompletedOnboarding = false
    
    private var Eipluq8LD9geJrV1Io29kimcg2nhUc0k: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    private var hasSeenOnboarding: Bool {
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding") ?? false
    }
    
    var body: some Scene {
        WindowGroup {
            RootSwitcher()
                .environmentObject(authViewModel)
                .environmentObject(persistenceController)
                .environmentObject(userProfileManager)
                .environmentObject(navigationStateManager)
                .preferredColorScheme(.dark)
        }
    }
}
