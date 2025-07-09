import SwiftUI

struct GlobalGoalAchievementOverlay: View {
    @EnvironmentObject var weeklyGoalManager: WeeklyGoalManager
    @State private var animateOverlay = false
    
    var body: some View {
        ZStack {
            if weeklyGoalManager.showGoalAchievedPopup {
                // Background overlay
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .animation(.easeOut(duration: 0.3), value: weeklyGoalManager.showGoalAchievedPopup)
                
                // Achievement card
                VStack(spacing: 24) {
                    // Success icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.green.opacity(0.3), Color.green.opacity(0.1)],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange.opacity(0.5), radius: 4, x: 0, y: 2)
                            .scaleEffect(animateOverlay ? 1.2 : 1.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).repeatCount(2, autoreverses: true), value: animateOverlay)
                    }
                    
                    // Achievement text
                    VStack(spacing: 12) {
                        Text("¡Meta Semanal Cumplida!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Has completado \(weeklyGoalManager.currentWeeklyGoal) entrenamientos esta semana")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                        Text("¡Sigue así! [U+1F4AA]")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.yellow)
                            .padding(.top, 8)
                    }
                    
                    // Close button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            weeklyGoalManager.showGoalAchievedPopup = false
                        }
                    }) {
                        Text("¡Genial!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.green, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 20)
                .scaleEffect(weeklyGoalManager.showGoalAchievedPopup ? 1 : 0.8)
                .opacity(weeklyGoalManager.showGoalAchievedPopup ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: weeklyGoalManager.showGoalAchievedPopup)
                .onAppear {
                    // Trigger trophy animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animateOverlay = true
                    }
                }
                .onDisappear {
                    animateOverlay = false
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        GlobalGoalAchievementOverlay()
            .environmentObject({
                let manager = WeeklyGoalManager.shared
                manager.showGoalAchievedPopup = true
                return manager
            }())
    }
}