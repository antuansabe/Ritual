import SwiftUI

struct PerfilView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    
    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let today = Date()
        
        return viewModel.entrenamientos.filter { workout in
            calendar.isDate(workout.fecha, equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header with gradient background
                headerSection
                
                // Main content
                VStack(spacing: 24) {
                    // Quick stats
                    statsSection
                    
                    // Weekly progress
                    weeklyProgressSection
                    
                    // Activity heatmap
                    activitySection
                    
                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 100)
            }
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color(.systemGray6).opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)
            
            VStack(spacing: 16) {
                Spacer()
                
                // Profile picture
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                // User info
                VStack(spacing: 8) {
                    Text("Antonio Dromundo")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Miembro desde Enero 2024")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Estadísticas")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "figure.walk.circle.fill",
                    value: "\(viewModel.totalWorkouts)",
                    label: "Entrenamientos",
                    color: .blue,
                    accentColor: .blue.opacity(0.2)
                )
                
                StatCard(
                    icon: "clock.fill",
                    value: "\(viewModel.totalMinutes)",
                    label: "Minutos",
                    color: .green,
                    accentColor: .green.opacity(0.2)
                )
                
                StatCard(
                    icon: "flame.fill",
                    value: "\(viewModel.totalCalories)",
                    label: "Calorías",
                    color: .orange,
                    accentColor: .orange.opacity(0.2)
                )
            }
        }
    }
    
    // MARK: - Weekly Progress Section
    private var weeklyProgressSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Meta Semanal")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(workoutsThisWeek) / 3.0)
                        .stroke(
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: workoutsThisWeek)
                    
                    VStack(spacing: 4) {
                        Text("\(workoutsThisWeek)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("de 3")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Entrena 3 veces esta semana")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    if workoutsThisWeek >= 3 {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("¡Meta completada!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Activity Section
    private var activitySection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Actividad")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Tu constancia durante el año")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Heatmap
                ModernHeatmapView(data: generateHeatmapData())
                
                // Legend
                HStack {
                    Text("Menos")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { intensity in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(heatmapColor(for: intensity))
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text("Más")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Logros")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("\(achievements.count) desbloqueados")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(achievements, id: \.id) { achievement in
                    ModernAchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func heatmapColor(for intensity: Int) -> Color {
        switch intensity {
        case 0: return Color.gray.opacity(0.2)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
    
    private func generateHeatmapData() -> [HeatmapDay] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let startOfYear = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
        
        var data: [HeatmapDay] = []
        
        for dayOffset in 0..<365 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfYear) {
                let intensity = Int.random(in: 0...4)
                data.append(HeatmapDay(date: date, intensity: intensity))
            }
        }
        
        return data
    }
    
    private var achievements: [Achievement] {
        [
            Achievement(id: 1, title: "Primer Paso", description: "Completa tu primer entrenamiento", icon: "star.fill", color: .yellow, isUnlocked: true),
            Achievement(id: 2, title: "Constancia", description: "5 días seguidos entrenando", icon: "flame.fill", color: .orange, isUnlocked: true),
            Achievement(id: 3, title: "Meta Semanal", description: "Completa tu meta semanal", icon: "target", color: .blue, isUnlocked: workoutsThisWeek >= 3),
            Achievement(id: 4, title: "Caminador", description: "Camina 10,000 pasos", icon: "figure.walk", color: .green, isUnlocked: true)
        ]
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct ModernHeatmapView: View {
    let data: [HeatmapDay]
    
    var body: some View {
        let weeks = organizeByWeeks(data)
        
        HStack(spacing: 3) {
            ForEach(0..<weeks.count, id: \.self) { weekIndex in
                if weekIndex < weeks.count {
                    VStack(spacing: 3) {
                        ForEach(weeks[weekIndex], id: \.date) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(colorForIntensity(day.intensity))
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
        }
    }
    
    private func organizeByWeeks(_ days: [HeatmapDay]) -> [[HeatmapDay]] {
        let calendar = Calendar.current
        var weeks: [[HeatmapDay]] = []
        var currentWeek: [HeatmapDay] = []
        
        for day in days {
            if currentWeek.isEmpty {
                currentWeek.append(day)
            } else if calendar.component(.weekOfYear, from: day.date) == calendar.component(.weekOfYear, from: currentWeek.first!.date) {
                currentWeek.append(day)
            } else {
                weeks.append(currentWeek)
                currentWeek = [day]
            }
        }
        
        if !currentWeek.isEmpty {
            weeks.append(currentWeek)
        }
        
        return weeks
    }
    
    private func colorForIntensity(_ intensity: Int) -> Color {
        switch intensity {
        case 0: return Color.gray.opacity(0.2)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
}

struct ModernAchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(achievement.isUnlocked ? 0.05 : 0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.isUnlocked ? achievement.color.opacity(0.3) : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Data Models

struct HeatmapDay {
    let date: Date
    let intensity: Int
}

struct Achievement {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

#Preview {
    NavigationStack {
        PerfilView(viewModel: EntrenamientoViewModel())
    }
}