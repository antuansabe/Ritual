import SwiftUI
import CoreData

// MARK: - Daily Summary Card View
struct DailySummaryCardView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    
    @State private var animateOnAppear = false
    @State private var currentMotivationalQuote = ""
    @Binding var selectedTab: Int
    
    // Computed properties
    private var userName: String {
        SecureStorage.shared.retrieveEncrypted(for: SecureStorage.StorageKeys.userDisplayName) ?? "Antonio"
    }
    
    private var hasWorkoutToday: Bool {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.contains { workout in
            calendar.isDate(workout.date ?? Date.distantPast, inSameDayAs: today)
        }
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let sortedWorkouts = workouts.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        guard !sortedWorkouts.isEmpty else { return 0 }
        
        var streak = 0
        var currentDay = Date()
        
        for workout in sortedWorkouts {
            let workoutDay = calendar.startOfDay(for: workout.date ?? Date())
            let currentDayStart = calendar.startOfDay(for: currentDay)
            
            if calendar.isDate(workoutDay, inSameDayAs: currentDayStart) {
                streak += 1
                currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay) ?? Date()
            } else {
                break
            }
        }
        
        return streak
    }
    
    private var todaysWorkouts: [WorkoutEntity] {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date.distantPast, inSameDayAs: today)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main card content
            VStack(spacing: 20) {
                headerSection
                statusSection
                if currentStreak > 0 {
                    streakSection
                }
                motivationalSection
                quickActionsSection
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppConstants.Design.electricBlue.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.1), value: animateOnAppear)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
            selectRandomQuote()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: 12) {
            // Profile circle with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppConstants.Design.electricBlue.opacity(0.3), AppConstants.Design.softPurple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(dayMessage)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Time of day icon
            Image(systemName: timeOfDayIcon)
                .font(.system(size: 24))
                .foregroundColor(AppConstants.Design.lavender)
        }
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
        HStack(spacing: 16) {
            // Status icon
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: statusIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(statusColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(statusTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                
                if hasWorkoutToday && !todaysWorkouts.isEmpty {
                    Text("\(todaysWorkouts.count) entrenamiento\(todaysWorkouts.count > 1 ? "s" : "") completado\(todaysWorkouts.count > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            if hasWorkoutToday {
                Text("[OK]")
                    .font(.title2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Streak Section
    private var streakSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20))
                .foregroundColor(.orange)
            
            Text("Racha: \(currentStreak) día\(currentStreak > 1 ? "s" : "") seguido\(currentStreak > 1 ? "s" : "")")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("[U+1F525]")
                .font(.title3)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.1), Color.red.opacity(0.05)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
    }
    
    // MARK: - Motivational Section
    private var motivationalSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppConstants.Design.lavender)
                
                Text("Frase del día")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            
            Text(currentMotivationalQuote)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.vertical, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [AppConstants.Design.lavender.opacity(0.1), AppConstants.Design.electricBlue.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Acciones rápidas")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: hasWorkoutToday ? "Entrenar más" : "Entrenar ahora",
                    icon: "figure.walk",
                    color: AppConstants.Design.electricBlue,
                    action: {
                        selectedTab = 1 // Navigate to Registro tab
                    }
                )
                
                QuickActionButton(
                    title: "Ver progreso",
                    icon: "chart.bar.fill",
                    color: AppConstants.Design.softPurple,
                    action: {
                        selectedTab = 2 // Navigate to Historial tab
                    }
                )
                
                QuickActionButton(
                    title: "Perfil",
                    icon: "person.circle.fill",
                    color: AppConstants.Design.lavender,
                    action: {
                        selectedTab = 3 // Navigate to Perfil tab
                    }
                )
            }
        }
    }
    
    // MARK: - Computed Properties for UI
    private var greeting: String {
        "¡Hola, \(userName)!"
    }
    
    private var dayMessage: String {
        if hasWorkoutToday {
            return "¡Excelente trabajo hoy! [U+1F4AA]"
        } else {
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                return "Hoy es un gran día para moverte [U+1F305]"
            case 12..<18:
                return "Aún puedes regalarte unos minutos [U+1F9D8]‍♂️"
            default:
                return "Relájate, mañana es otro día [U+1F319]"
            }
        }
    }
    
    private var timeOfDayIcon: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "sun.max.fill"
        case 12..<18: return "sun.haze.fill"
        case 18..<21: return "sunset.fill"
        default: return "moon.stars.fill"
        }
    }
    
    private var statusTitle: String {
        if hasWorkoutToday {
            return "Entrenamiento completado"
        } else if currentStreak > 0 {
            return "Mantén tu racha activa"
        } else {
            return "Todo bien, hoy puedes retomar"
        }
    }
    
    private var statusIcon: String {
        if hasWorkoutToday {
            return "checkmark.circle.fill"
        } else if currentStreak > 0 {
            return "figure.run.circle"
        } else {
            return "leaf.circle"
        }
    }
    
    private var statusColor: Color {
        if hasWorkoutToday {
            return AppConstants.Design.electricBlue
        } else if currentStreak > 0 {
            return .orange
        } else {
            return AppConstants.Design.softPurple
        }
    }
    
    // MARK: - Helper Functions
    private func selectRandomQuote() {
        let quotes = MotivationalQuotes.getDailyQuote(hasWorkoutToday: hasWorkoutToday, streak: currentStreak)
        currentMotivationalQuote = quotes.randomElement() ?? "Cada paso cuenta [U+1F31F]"
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Motivational Quotes Structure
struct MotivationalQuotes {
    static let welcomeQuotes = [
        "Tu bienestar es un regalo que te das cada día [U+1F381]",
        "Aquí estás, y eso ya es un logro [U+1F331]",
        "Cada momento que dedicas a ti mismo vale oro ✨",
        "Tu ritmo es perfecto, no hay prisa [U+1F343]",
        "Hoy es una nueva oportunidad de cuidarte [U+1F305]"
    ]
    
    static let postWorkoutQuotes = [
        "¡Qué bien te has cuidado hoy! Tu cuerpo te lo agradece [U+1F499]",
        "Cada movimiento fue un acto de amor propio [U+1F917]",
        "Has plantado una semilla de bienestar hoy [U+1F33B]",
        "Tu energía positiva se nota desde aquí ⚡",
        "Completaste algo hermoso para ti mismo [U+1F308]"
    ]
    
    static let restDayQuotes = [
        "Descansar también es entrenar tu constancia [U+1F9D8]‍♂️",
        "Tu cuerpo sabe cuándo necesita una pausa, escúchalo [U+1F3B5]",
        "Mañana será otro día para brillar ⭐",
        "A veces el mejor entrenamiento es cuidar tu mente [U+1F319]",
        "No hay prisa, tu bienestar es un viaje, no una carrera [U+1F6E4]️"
    ]
    
    static let streakQuotes = [
        "Cada día que eliges cuidarte construyes algo hermoso [U+1F3D7]️",
        "Tu constancia es tu superpoder silencioso [U+1F4AB]",
        "Paso a paso, estás creando la mejor versión de ti [U+1F98B]",
        "Tu dedicación se nota, sigue escribiendo tu historia [U+1F4D6]",
        "Cada entrenamiento es una carta de amor a tu futuro yo [U+1F48C]"
    ]
    
    static func getDailyQuote(hasWorkoutToday: Bool, streak: Int) -> [String] {
        if hasWorkoutToday {
            return postWorkoutQuotes
        } else if streak > 0 {
            return streakQuotes
        } else {
            return restDayQuotes.isEmpty ? welcomeQuotes : restDayQuotes
        }
    }
}

#Preview {
    DailySummaryCardView(selectedTab: .constant(0))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .background(Color.black)
        .preferredColorScheme(.dark)
}