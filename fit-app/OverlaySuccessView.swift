import SwiftUI

struct wWSZ1770xFoHrYLOXIX3QK1M31SV1wMj: View {
    let title: String
    let subtitle: String
    @Binding var isVisible: Bool
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var checkmarkScale: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            // Success card
            VStack(spacing: 24) {
                // Checkmark icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.green.opacity(0.2), Color.green.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.green)
                        .scaleEffect(checkmarkScale)
                }
                
                // Text content
                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(scale)
        }
        .opacity(opacity)
        .onChange(of: isVisible) { visible in
            if visible {
                XBKRsaOVB7IubKbKig2RNYsBUWknczOR()
            } else {
                qvEAPFg3nnMJNsSlfoeqYYPPwHzzkuHi()
            }
        }
        .onAppear {
            if isVisible {
                XBKRsaOVB7IubKbKig2RNYsBUWknczOR()
            }
        }
    }
    
    private func XBKRsaOVB7IubKbKig2RNYsBUWknczOR() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            opacity = 1
            scale = 1
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2)) {
            checkmarkScale = 1
        }
        
        // Auto-hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            qvEAPFg3nnMJNsSlfoeqYYPPwHzzkuHi()
        }
    }
    
    private func qvEAPFg3nnMJNsSlfoeqYYPPwHzzkuHi() {
        withAnimation(.easeInOut(duration: 0.4)) {
            opacity = 0
            scale = 0.8
        }
        
        // Reset for next time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if isVisible {
                isVisible = false
            }
            scale = 0.5
            checkmarkScale = 0
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        wWSZ1770xFoHrYLOXIX3QK1M31SV1wMj(
            title: "¡Entrenamiento guardado!",
            subtitle: "Sigue así y alcanza tus metas",
            isVisible: .constant(true)
        )
    }
}