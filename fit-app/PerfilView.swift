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
                // iOS Calendar
                iOSCalendarView(workouts: viewModel.entrenamientos)
                
                // Legend
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                        Text("Sin entrenar")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                        Text("Con entrenamiento")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
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

struct iOSCalendarView: View {
    let workouts: [Entrenamiento]
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter
    }()
    
    private var monthDays: [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentDate),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startingSpaces = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date] = []
        
        // Add empty dates for spacing
        for _ in 0..<startingSpaces {
            if let date = calendar.date(byAdding: .day, value: -(startingSpaces - days.count), to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        // Add all days of the month
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasWorkout(on date: Date) -> Bool {
        return workouts.contains { workout in
            calendar.isDate(workout.fecha, inSameDayAs: date)
        }
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Month header with navigation
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentDate).capitalized)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 8) {
                // Weekday headers
                HStack(spacing: 0) {
                    ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                    ForEach(monthDays, id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            hasWorkout: hasWorkout(on: date),
                            isCurrentMonth: isCurrentMonth(date),
                            isToday: isToday(date)
                        )
                    }
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentDate = newDate
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let hasWorkout: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Text(dayNumber)
                .font(.system(size: 14, weight: isToday ? .bold : .medium))
                .foregroundColor(textColor)
        }
        .frame(width: 32, height: 32)
        .background(backgroundColor)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isCurrentMonth ? 1.0 : 0.8)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
        .animation(.easeInOut(duration: 0.2), value: hasWorkout)
    }
    
    private var backgroundColor: Color {
        if hasWorkout && isCurrentMonth {
            return Color.green.opacity(0.8)
        } else if isCurrentMonth {
            return Color.gray.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    private var textColor: Color {
        if hasWorkout && isCurrentMonth {
            return .white
        } else if isCurrentMonth {
            return .white.opacity(0.8)
        } else {
            return .gray.opacity(0.5)
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