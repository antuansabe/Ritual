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

            // Subtle glass lighting effect
            Color.white.opacity(scheme == .dark ? 0.03 : 0.02)
                .blur(radius: 80)
                .ignoresSafeArea()

            content()
        }
        .onAppear { appear = true }
    }
    
    /// Returns a professional, subtle gradient
    private var currentBrandGradient: LinearGradient {
        scheme == .dark
            ? LinearGradient(colors: [.purple.opacity(0.4), .black.opacity(0.8)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            : LinearGradient(colors: [.purple.opacity(0.3), .white.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
    }
}