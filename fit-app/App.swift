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
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}