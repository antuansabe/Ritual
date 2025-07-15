import SwiftUI

@main
struct bznZq23oqpIdNqA1wbzgsmcc11mjbUC2: App {
    @StateObject private var FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
    @StateObject private var KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr = c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9 = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @State private var hasCompletedOnboarding = false
    
    private var Eipluq8LD9geJrV1Io29kimcg2nhUc0k: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    private var hasSeenOnboarding: Bool {
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding") ?? false
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.showGoodbyeView {
                    // Show goodbye screen when logging out
                    ApJ08JFGfVrR1tOMiHbVWMDwIafd73iX()
                        .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                        .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                        .preferredColorScheme(.dark)
                        .transition(.scale.combined(with: .opacity))
                } else if FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.isLoggedIn {
                    // Check if user has seen onboarding
                    if !hasSeenOnboarding && !hasCompletedOnboarding {
                        // Show onboarding for first-time users
                        OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                            .transition(.opacity)
                    } else if Eipluq8LD9geJrV1Io29kimcg2nhUc0k {
                        // Returning user - go directly to main app
                        ZStack {
                            KQMbB3ZqQUMbSR2AGsJpCknS8pSLtpb6()
                                .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                                .environmentObject(KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr)
                                .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                                .preferredColorScheme(.dark)
                            
                            isqjtgeChdmyuavMEwRRyV8yoeHAhS9Z()
                                .environmentObject(KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // First-time user - show welcome screen
                        FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
                            .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                            .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                            .preferredColorScheme(.dark)
                            .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    // Not logged in - show login view
                    wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
                        .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                        .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.isLoggedIn)
            .animation(.easeInOut(duration: 0.7), value: Eipluq8LD9geJrV1Io29kimcg2nhUc0k)
            .animation(.easeInOut(duration: 0.5), value: FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.isLoading)
            .animation(.easeInOut(duration: 0.5), value: FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.showGoodbyeView)
            .animation(.easeInOut(duration: 0.3), value: hasCompletedOnboarding)
        }
    }
}
