import SwiftUI

struct GoodbyeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userProfileManager: UserProfileManager
    @State private var animateContent = false
    @State private var showButton = false
    
    private var userName: String {
        // Try to get name from UserProfileManager first
        if !userProfileManager.displayName.isEmpty && userProfileManager.displayName != "Atleta" {
            return userProfileManager.formattedDisplayName
        }
        
        // Get name from secure storage only
        if let name = SecureStorage.shared.retrieveEncrypted(for: SecureStorage.StorageKeys.userDisplayName), !name.isEmpty {
            return name
        }
        
        // Final fallback
        return "Atleta"
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            backgroundView
            
            // Main content
            VStack(spacing: 0) {
                Spacer()
                
                // Goodbye content
                goodbyeContent
                
                Spacer()
                
                // Return to login button
                if showButton {
                    returnButton
                        .padding(.bottom, 60)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        ZStack {
            // Base dark background
            Color.black.ignoresSafeArea()
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.4),
                    Color.black.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Goodbye Content
    private var goodbyeContent: some View {
        VStack(spacing: 32) {
            // Goodbye emoji with animation
            Text("[U+1F44B]")
                .font(.system(size: 80))
                .scaleEffect(animateContent ? 1.0 : 0.5)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: animateContent)
            
            // Main goodbye message
            VStack(spacing: 20) {
                Text("¡Gracias por entrenar hoy, \(userName)!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.3), value: animateContent)
                
                Text("Recuerda que cada paso cuenta.")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.5), value: animateContent)
                
                Text("¡Nos vemos pronto! [U+1F4AA]")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateContent)
            }
            
            // Motivational section
            motivationalSection
        }
    }
    
    // MARK: - Motivational Section
    private var motivationalSection: some View {
        VStack(spacing: 16) {
            // Achievement badge
            HStack(spacing: 12) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                
                Text("¡Sigue siendo increíble!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
            )
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: animateContent)
            
            // Motivational quote
            Text("\"El éxito no es final, el fracaso no es fatal: lo que cuenta es el coraje de continuar.\"")
                .font(.system(size: 16, weight: .medium, design: .serif))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .italic()
                .padding(.horizontal, 16)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(1.1), value: animateContent)
        }
    }
    
    // MARK: - Return Button
    private var returnButton: some View {
        Button(action: {
            handleReturnToLogin()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "house.fill")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Volver a inicio")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppConstants.Design.electricBlue,
                                AppConstants.Design.softPurple
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: AppConstants.Design.electricBlue.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .scaleEffect(showButton ? 1.0 : 0.8)
        .opacity(showButton ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showButton)
    }
    
    // MARK: - Actions
    private func startAnimations() {
        // Start content animation immediately
        withAnimation {
            animateContent = true
        }
        
        // Show button after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showButton = true
            }
        }
        
        // Auto-navigate to login after 4 seconds if user doesn't interact
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if authViewModel.showingGoodbye {
                handleReturnToLogin()
            }
        }
    }
    
    private func handleReturnToLogin() {
        print("[U+1F3E0] Returning to login from goodbye screen")
        
        withAnimation(.easeInOut(duration: 0.5)) {
            authViewModel.completeLogout()
        }
    }
}

// MARK: - Previews
#Preview {
    GoodbyeView()
        .environmentObject(AuthViewModel())
        .environmentObject(UserProfileManager.shared)
}