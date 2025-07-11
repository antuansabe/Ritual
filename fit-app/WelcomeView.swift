import SwiftUI

struct FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm
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
            KQMbB3ZqQUMbSR2AGsJpCknS8pSLtpb6()
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
            if !userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.isEmpty && userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 != "Atleta" {
                Text("¡Hola, \(userProfileManager.XBRN83PxWbEPMDPcnWx7eC9WBTmYZNbu)! 👋")
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
                            .fill(feature.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: feature.QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(feature.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA)
                    }
                    
                    // Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(feature.FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(feature.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)
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
            GwDLI3Vd1xgQDmn0reP2tOYadou91TXo()
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
                        pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT,
                        pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(28)
            .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), radius: 15, x: 0, y: 8)
        }
        .scaleEffect(animateContent ? 1.0 : 0.8)
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.8), value: animateContent)
    }
    
    // MARK: - Data
    private let features = [
        rR0L7k2YdOzl6VXfh0gsdYto1NgC9a0H(
            QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "figure.walk.circle.fill",
            FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: "Registra entrenamientos",
            W5TVRE97oSlHf67bpUXP80LgXeYzET6B: "Lleva control de tus sesiones de ejercicio",
            QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .blue
        ),
        rR0L7k2YdOzl6VXfh0gsdYto1NgC9a0H(
            QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "chart.bar.fill",
            FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: "Sigue tu progreso",
            W5TVRE97oSlHf67bpUXP80LgXeYzET6B: "Visualiza tu evolución y mejoras",
            QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .green
        ),
        rR0L7k2YdOzl6VXfh0gsdYto1NgC9a0H(
            QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "target",
            FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: "Alcanza tus metas",
            W5TVRE97oSlHf67bpUXP80LgXeYzET6B: "Establece objetivos y cúmplelos",
            QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .orange
        )
    ]
    
    // MARK: - Actions
    private func GwDLI3Vd1xgQDmn0reP2tOYadou91TXo() {
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
struct rR0L7k2YdOzl6VXfh0gsdYto1NgC9a0H {
    let QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: String
    let FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: String
    let W5TVRE97oSlHf67bpUXP80LgXeYzET6B: String
    let QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color
}

// MARK: - Previews
#Preview {
    FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
        .environmentObject(gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX)
}