import SwiftUI

struct OnboardingSlide: View {
    let icon: String
    let title: String
    let description: String
    let isLastSlide: Bool
    let onGetStarted: (() -> Void)?
    
    init(icon: String, title: String, description: String, isLastSlide: Bool = false, onGetStarted: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isLastSlide = isLastSlide
        self.onGetStarted = onGetStarted
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.4, blue: 1.0),
                                Color(red: 0.4, green: 0.2, blue: 0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: Color(red: 0.5, green: 0.3, blue: 0.9).opacity(0.5), radius: 20, x: 0, y: 10)
                
                Image(systemName: icon)
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Title
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Description
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(4)
            
            Spacer()
            
            // Get Started button (only on last slide)
            if isLastSlide {
                Button(action: {
                    onGetStarted?()
                }) {
                    Text("Empezar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.4, blue: 1.0),
                                    Color(red: 0.4, green: 0.2, blue: 0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color(red: 0.5, green: 0.3, blue: 0.9).opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            } else {
                // Placeholder to maintain consistent spacing
                Color.clear
                    .frame(height: 70)
            }
            
            Spacer()
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    OnboardingSlide(
        icon: "bolt.heart",
        title: "Registra tu energía",
        description: "Captura cada entrenamiento y observa cómo tu dedicación se transforma en progreso visible",
        isLastSlide: false
    )
}