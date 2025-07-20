import SwiftUI

struct OnboardingSlide: View {
    let icon: String
    let emoji: String
    let title: String
    let description: String
    let isLastSlide: Bool
    let onGetStarted: (() -> Void)?
    
    init(icon: String, emoji: String = "✨", title: String, description: String, isLastSlide: Bool = false, onGetStarted: (() -> Void)? = nil) {
        self.icon = icon
        self.emoji = emoji
        self.title = title
        self.description = description
        self.isLastSlide = isLastSlide
        self.onGetStarted = onGetStarted
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Glassmorphism Card with Icon and Emoji
            ZStack {
                // Glassmorphism background
                RoundedRectangle(cornerRadius: 30)
                    .fill(.regularMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.indigo.opacity(0.2),
                                        Color.purple.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.indigo.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // SF Symbol
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.indigo, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Emoji overlay
                Text(emoji)
                    .font(.system(size: 24))
                    .offset(x: 35, y: -35)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            
            VStack(spacing: 16) {
                // Title - max 2 lines
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal)
                
                // Description - max 2 lines  
                Text(description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            // Get Started button (only on last slide)
            if isLastSlide {
                Button(action: {
                    onGetStarted?()
                }) {
                    Text("START_BTN".t)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.indigo, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.indigo.opacity(0.3), radius: 12, x: 0, y: 6)
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
        emoji: "⚡",
        title: "Registra tu energía",
        description: "Captura cada entrenamiento y observa cómo tu dedicación se transforma en progreso visible",
        isLastSlide: false
    )
}