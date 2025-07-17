import SwiftUI

@main
struct bznZq23oqpIdNqA1wbzgsmcc11mjbUC2: App {
    @StateObject private var authViewModel = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
    @StateObject private var persistenceController = c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var userProfileManager = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var navigationStateManager = NavigationStateManager()
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
