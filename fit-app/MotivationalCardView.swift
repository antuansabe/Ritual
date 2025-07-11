import SwiftUI

// MARK: - Motivational Card View
struct MotivationalCardView: View {
    let message: MotivationalMessage
    let style: CardStyle
    @State private var animateOnAppear = false
    
    enum CardStyle {
        case prominent      // Para pantallas principales como Perfil
        case subtle         // Para pantallas con más contenido
        case minimal        // Para espacios reducidos
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Emoji container
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppConstants.Design.lavender.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: emojiSize, height: emojiSize)
                
                Text(message.emoji)
                    .font(.system(size: emojiFontSize))
            }
            
            // Message content
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(textFont)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                if style == .prominent {
                    Text("💫 Inspiración del día")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        .italic()
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(cardPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(cardBorder, lineWidth: 1)
                )
        )
        .shadow(color: cardShadow, radius: shadowRadius, x: 0, y: shadowOffset)
        .scaleEffect(animateOnAppear ? 1 : 0.95)
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateOnAppear)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Style Computed Properties
    private var emojiSize: CGFloat {
        switch style {
        case .prominent: return 50
        case .subtle: return 40
        case .minimal: return 32
        }
    }
    
    private var emojiFontSize: CGFloat {
        switch style {
        case .prominent: return 24
        case .subtle: return 20
        case .minimal: return 16
        }
    }
    
    private var textFont: Font {
        switch style {
        case .prominent: return .system(size: 16, weight: .medium, design: .rounded)
        case .subtle: return .system(size: 15, weight: .regular, design: .rounded)
        case .minimal: return .system(size: 14, weight: .regular, design: .rounded)
        }
    }
    
    private var cardPadding: EdgeInsets {
        switch style {
        case .prominent: return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        case .subtle: return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        case .minimal: return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .prominent: return AppConstants.UI.cornerRadiusL
        case .subtle: return AppConstants.UI.cornerRadiusM
        case .minimal: return AppConstants.UI.cornerRadiusS
        }
    }
    
    private var cardBackground: LinearGradient {
        switch style {
        case .prominent:
            return LinearGradient(
                colors: [
                    AppConstants.Design.lavender.opacity(0.15),
                    AppConstants.Design.electricBlue.opacity(0.08),
                    AppConstants.Design.softPurple.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .subtle:
            return LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            return LinearGradient(
                colors: [Color.white.opacity(0.06), Color.white.opacity(0.03)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardBorder: LinearGradient {
        switch style {
        case .prominent:
            return LinearGradient(
                colors: [AppConstants.Design.lavender.opacity(0.3), AppConstants.Design.electricBlue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .subtle, .minimal:
            return LinearGradient(
                colors: [Color.white.opacity(0.15), Color.white.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardShadow: Color {
        switch style {
        case .prominent: return AppConstants.Design.lavender.opacity(0.2)
        case .subtle: return .black.opacity(0.1)
        case .minimal: return .black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .prominent: return 8
        case .subtle: return 4
        case .minimal: return 2
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .prominent: return 4
        case .subtle: return 2
        case .minimal: return 1
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        AppConstants.Design.backgroundGradient
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            MotivationalCardView(
                message: MotivationalMessage(
                    text: "Hoy puedes darte un regalo de movimiento",
                    emoji: "🧘‍♂️",
                    context: .profile
                ),
                style: .prominent
            )
            
            MotivationalCardView(
                message: MotivationalMessage(
                    text: "Tu constancia empieza con pequeños pasos",
                    emoji: "👣",
                    context: .workoutStart
                ),
                style: .subtle
            )
            
            MotivationalCardView(
                message: MotivationalMessage(
                    text: "¡Tu constancia inspira!",
                    emoji: "🔥",
                    context: .streak
                ),
                style: .minimal
            )
        }
        .padding()
    }
}