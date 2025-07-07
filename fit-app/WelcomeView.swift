import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userProfileManager: UserProfileManager
    @State private var animateContent = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            // Background with gradient
            backgroundView
            
            // Main content
            VStack(spacing: 0) {
                Spacer()
                
                // Welcome content
                welcomeContent
                
                Spacer()
                
                // Get started button
                getStartedButton
                    .padding(.bottom, 60)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2).delay(0.3)) {
                animateContent = true
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainAppView()
                .environmentObject(authViewModel)
                .environmentObject(userProfileManager)
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        ZStack {
            // Background image
            Image("loginBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    Color.black.opacity(0.8),
                    Color.blue.opacity(0.6),
                    Color.purple.opacity(0.4),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Welcome Content
    private var welcomeContent: some View {
        VStack(spacing: 32) {
            // Welcome emoji and title
            VStack(spacing: 16) {
                Text("🎉")
                    .font(.system(size: 80))
                    .scaleEffect(animateContent ? 1.0 : 0.5)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5), value: animateContent)
                
                Text("¡Bienvenido a Fit-App!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateContent)
            }
            
            // Personalized greeting
            if !userProfileManager.displayName.isEmpty && userProfileManager.displayName != "Atleta" {
                Text("¡Hola, \(userProfileManager.formattedDisplayName)! 👋")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.9), value: animateContent)
            }
            
            // Description
            VStack(spacing: 16) {
                Text("Tu compañero ideal para alcanzar tus metas de fitness")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Registra entrenamientos, sigue tu progreso y mantente motivado cada día")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 40)
            .animation(.easeOut(duration: 0.8).delay(1.1), value: animateContent)
            
            // Features highlights
            featuresSection
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 20) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(feature.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: feature.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(feature.color)
                    }
                    
                    // Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(feature.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(feature.description)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(x: animateContent ? 0 : -30)
                .animation(.easeOut(duration: 0.6).delay(1.3 + Double(index) * 0.1), value: animateContent)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Get Started Button
    private var getStartedButton: some View {
        Button(action: {
            handleGetStarted()
        }) {
            HStack(spacing: 12) {
                Text("Comenzar")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [
                        AppConstants.Design.electricBlue,
                        AppConstants.Design.softPurple
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(28)
            .shadow(color: AppConstants.Design.electricBlue.opacity(0.4), radius: 15, x: 0, y: 8)
        }
        .scaleEffect(animateContent ? 1.0 : 0.8)
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.8), value: animateContent)
    }
    
    // MARK: - Data
    private let features = [
        WelcomeFeature(
            icon: "figure.walk.circle.fill",
            title: "Registra entrenamientos",
            description: "Lleva control de tus sesiones de ejercicio",
            color: .blue
        ),
        WelcomeFeature(
            icon: "chart.bar.fill",
            title: "Sigue tu progreso",
            description: "Visualiza tu evolución y mejoras",
            color: .green
        ),
        WelcomeFeature(
            icon: "target",
            title: "Alcanza tus metas",
            description: "Establece objetivos y cúmplelos",
            color: .orange
        )
    ]
    
    // MARK: - Actions
    private func handleGetStarted() {
        print("🎉 User completed welcome flow - marking as seen")
        
        // Mark welcome as seen in UserDefaults
        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
        
        // Navigate to main app with animation
        withAnimation(.easeInOut(duration: 0.5)) {
            showMainApp = true
        }
    }
}

// MARK: - Welcome Feature Model
struct WelcomeFeature {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Previews
#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(UserProfileManager.shared)
}