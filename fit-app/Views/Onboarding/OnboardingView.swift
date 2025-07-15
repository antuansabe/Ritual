import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    private let slides = [
        (icon: "bolt.heart", title: "ONB_TITLE_1".t, description: "ONB_SUB_1".t),
        (icon: "icloud", title: "ONB_TITLE_2".t, description: "ONB_SUB_2".t),
        (icon: "chart.bar", title: "ONB_TITLE_3".t, description: "ONB_SUB_3".t)
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
                        Text("SKIP_BTN".t)
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
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(
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