import SwiftUI

struct ApJ08JFGfVrR1tOMiHbVWMDwIafd73iX: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm
    @State private var animateContent = false
    @State private var showButton = false
    
    private var userName: String {
        // Try to get name from UserProfileManager first
        if !userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.isEmpty && userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 != "Atleta" {
            return userProfileManager.XBRN83PxWbEPMDPcnWx7eC9WBTmYZNbu
        }
        
        // Get name from secure storage only
        if let name = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd), !name.isEmpty {
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
            d7HgIV9FgJHiFpzRNEYuKEhOXIrjilkO()
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
            Text("👋")
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
                
                Text("¡Nos vemos pronto! 💪")
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
            AmLhUYJYwG4J77oV0J1VDvw8Iy2IDoOz()
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
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT,
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .scaleEffect(showButton ? 1.0 : 0.8)
        .opacity(showButton ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showButton)
    }
    
    // MARK: - Actions
    private func d7HgIV9FgJHiFpzRNEYuKEhOXIrjilkO() {
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
            if authViewModel.ZcyV56DImmWj4Y96j2b459YI8SvPQpMA {
                AmLhUYJYwG4J77oV0J1VDvw8Iy2IDoOz()
            }
        }
    }
    
    private func AmLhUYJYwG4J77oV0J1VDvw8Iy2IDoOz() {
        print("🏠 Returning to login from goodbye screen")
        
        withAnimation(.easeInOut(duration: 0.5)) {
            authViewModel.WclnnxV7r3qvqAkYbmZKSt0rHWBOFLp7()
        }
    }
}

// MARK: - Previews
#Preview {
    ApJ08JFGfVrR1tOMiHbVWMDwIafd73iX()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
        .environmentObject(gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX)
}