import SwiftUI

struct ReusableBackgroundView<Content: View>: View {
    @Environment(\.colorScheme) var scheme
    @ViewBuilder var content: () -> Content
    @State private var appear = false
    
    var body: some View {
        ZStack {
            // Brand gradient with instant appearance and fade-in
            currentBrandGradient
                .ignoresSafeArea()
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.25), value: appear)

            // Glass lighting effect
            Color.white.opacity(scheme == .dark ? 0.08 : 0.04)
                .blur(radius: 60)
                .ignoresSafeArea()

            content()
        }
        .onAppear { appear = true }
    }
    
    /// Returns the exact brand gradient used in the project
    private var currentBrandGradient: LinearGradient {
        LinearGradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
}