import SwiftUI

struct ReusableBackgroundView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder var content: () -> Content
    @State private var animate = false
    
    var gradientColors: [Color] {
        colorScheme == .dark
            ? [.purple, .black]
            : [.purple.opacity(0.6), .white.opacity(0.1)]
    }
    
    var body: some View {
        ZStack {
            // Gradiente animado entre tonos púrpura
            LinearGradient(colors: animate ? gradientColors : gradientColors.reversed(),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 15)
                .opacity(0.7)
                .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animate)
                .onAppear { animate.toggle() }

            // Efecto de brillo muy sutil (iluminación de fondo)
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 400, height: 400)
                .blur(radius: 100)
                .offset(x: -150, y: -300)

            content()
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.5), value: UUID())
        }
    }
}