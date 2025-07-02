import SwiftUI

struct PerfilView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    
    // Calculate workouts this week
    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let today = Date()
        
        return viewModel.entrenamientos.filter { workout in
            calendar.isDate(workout.fecha, equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 32) {
                headerSection
                metricsSection
                weeklyGoalSection
                habitsSection
                achievementsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 100)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text("Antonio Dromundo")
                .font(.title.bold())
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "figure.walk.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    VStack(spacing: 4) {
                        Text("\(viewModel.totalWorkouts)")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        Text("Entrenamientos")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }
                .frame(width: 100, height: 100)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                    
                    VStack(spacing: 4) {
                        Text("\(viewModel.totalMinutes)")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        Text("Minutos")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }
                .frame(width: 100, height: 100)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    
                    VStack(spacing: 4) {
                        Text("\(viewModel.totalCalories)")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        Text("Calorías")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }
                .frame(width: 100, height: 100)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Weekly Goal Section
    private var weeklyGoalSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Meta semanal")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                
                Text("Entrena al menos 3 veces esta semana 💪")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                ProgressView(value: Double(workoutsThisWeek), total: 3.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .frame(height: 12)
                    .cornerRadius(6)
                    .padding(.vertical, 8)
                
                Text("\(workoutsThisWeek) de 3 entrenamientos")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Habits Section
    private var habitsSection: some View {
        VStack(spacing: 16) {
            Text("Tu constancia 🟩")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 12) {
                    CalendarHeatmapView()
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(spacing: 16) {
            Text("Logros 🏆")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                AchievementCardView(icon: "star.fill", title: "Primer entrenamiento", color: .yellow)
                AchievementCardView(icon: "bolt.fill", title: "5 días seguidos", color: .orange)
                AchievementCardView(icon: "target", title: "Meta semanal", color: .blue)
                AchievementCardView(icon: "figure.walk", title: "Caminador estrella", color: .green)
            }
        }
    }
}

// MARK: - Achievement Card Component
struct AchievementCardView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Calendar Heatmap Component
struct CalendarHeatmapView: View {
    // Datos simulados para el calendario
    private let simulatedData: [String: Int] = {
        var data: [String: Int] = [:]
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let startOfYear = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
        
        // Generar algunos datos simulados aleatorios
        for dayOffset in 0..<365 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfYear) {
                let dateString = DateFormatter.yyyyMMdd.string(from: date)
                // 30% de probabilidad de tener entrenamiento
                if Int.random(in: 1...10) <= 3 {
                    data[dateString] = Int.random(in: 15...120) // Minutos aleatorios
                }
            }
        }
        return data
    }()
    
    var body: some View {
        LazyHGrid(rows: Array(repeating: GridItem(.fixed(12), spacing: 2), count: 7), spacing: 2) {
            ForEach(0..<52, id: \.self) { week in
                ForEach(0..<7, id: \.self) { day in
                    let dayOffset = week * 7 + day
                    let currentYear = Calendar.current.component(.year, from: Date())
                    let startOfYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
                    
                    if let currentDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfYear),
                       Calendar.current.component(.year, from: currentDate) == currentYear {
                        
                        let dateString = DateFormatter.yyyyMMdd.string(from: currentDate)
                        let minutes = simulatedData[dateString] ?? 0
                        
                        CalendarDaySquare(minutes: minutes)
                    } else {
                        Color.clear
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Calendar Day Square Component
struct CalendarDaySquare: View {
    let minutes: Int
    
    private var squareColor: Color {
        switch minutes {
        case 0:
            return .gray.opacity(0.2)
        case 1...20:
            return .green.opacity(0.3)
        case 21...40:
            return .green.opacity(0.5)
        case 41...60:
            return .green.opacity(0.7)
        default:
            return .green.opacity(1.0)
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(squareColor)
            .frame(width: 12, height: 12)
            .cornerRadius(2)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}


#Preview {
    NavigationStack {
        PerfilView(viewModel: EntrenamientoViewModel())
    }
}