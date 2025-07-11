import SwiftUI
import AuthenticationServices

struct wdJa7hhtRa6I67ei2Mi07KjELvqym68b: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @State private var animateOnAppear = false
    
    var body: some View {
        ZStack {
            // Background image
            Image("loginBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Dark overlay
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                headerSection
                
                Spacer()
                
                appleSignInSection
                
                Spacer()
                
                footerSection
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 32) {
            // App logo/icon
            ZStack {
                // Outer circle with gradient
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.3),
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.2),
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 120, height: 120)
                
                // Inner circle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 80, height: 80)
                
                // App icon
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 28, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.pfmjowVfLLdwmIFvy86thx6YHe6khrWx.opacity(0.9),
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(animateOnAppear ? 1 : 0)
            .scaleEffect(animateOnAppear ? 1 : 0.8)
            .rotationEffect(.degrees(animateOnAppear ? 0 : -90))
            .animation(.spring(response: 1.2, dampingFraction: 0.8), value: animateOnAppear)
            
            // App title and subtitle
            VStack(spacing: 16) {
                Text("FitApp")
                    .font(.system(size: 42, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .kerning(3)
                
                // Decorative line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4),
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.3)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: animateOnAppear ? 80 : 0, height: 1.5)
                    .cornerRadius(1)
                    .animation(.easeInOut(duration: 1.0).delay(0.6), value: animateOnAppear)
                
                Text("Tu compañero de entrenamiento")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(1.0)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 1.0).delay(0.4), value: animateOnAppear)
        }
    }
    
    // MARK: - Apple Sign In Section
    private var appleSignInSection: some View {
        VStack(spacing: 24) {
            Text("Inicia sesión de forma segura")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .tracking(0.5)
            
            // Apple Sign In Button
            Button(action: {
                authViewModel.jniddSZKEoGcms9So9T3uUpuM55PjT8X()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("Continuar con Apple")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .disabled(authViewModel.isLoading)
            .opacity(authViewModel.isLoading ? 0.6 : 1.0)
            .scaleEffect(animateOnAppear ? 1 : 0.9)
            .opacity(animateOnAppear ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateOnAppear)
            
            // Loading indicator
            if authViewModel.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                    
                    Text("Iniciando sesión...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 12) {
            Text("Al continuar, aceptas nuestros")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white.opacity(0.6))
            
            HStack(spacing: 8) {
                Button("Términos de Servicio") {
                    // Handle terms
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                
                Text("y")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white.opacity(0.6))
                
                Button("Política de Privacidad") {
                    // Handle privacy policy
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.6).delay(1.0), value: animateOnAppear)
    }
}

#Preview {
    wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
}