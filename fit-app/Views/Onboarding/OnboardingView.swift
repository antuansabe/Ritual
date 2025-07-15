import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    private let slides = [
        (icon: "bolt.heart", title: "Registra tu energía", description: "Captura cada entrenamiento y observa cómo tu dedicación se transforma en progreso visible"),
        (icon: "icloud", title: "Sincroniza en iCloud", description: "Mantén tu historial seguro y accesible desde todos tus dispositivos Apple"),
        (icon: "chart.bar", title: "Convierte hábitos en victorias", description: "Visualiza tu evolución y celebra cada paso hacia una vida más activa y saludable")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient (adapts to system theme)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.05, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Omitir")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 50)
                
                // TabView with page style
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        OnboardingSlide(
                            icon: slides[index].icon,
                            title: slides[index].title,
                            description: slides[index].description,
                            isLastSlide: index == slides.count - 1,
                            onGetStarted: {
                                completeOnboarding()
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        // Remove forced dark mode to support both light and dark modes
    }
    
    private func completeOnboarding() {
        // Save the flag to SecureStorage
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(
            true,
            for: "hasSeenOnboarding"
        )
        
        // Update binding to dismiss onboarding
        withAnimation(.easeInOut(duration: 0.3)) {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}