import SwiftUI

@main
struct FitApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                MainAppView()
                    .environmentObject(authViewModel)
                    .preferredColorScheme(.dark)
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