import SwiftUI
import CoreData

struct HistorialView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.dismiss) private var dismiss
    @State private var animateOnAppear = false
    @State private var currentDate = Date()
    @StateObject private var motivationalManager = MotivationalMessageManager()
    
    private let calendar = Calendar.current
    
    // Entrenamientos del mes actual
    private var currentMonthWorkouts: Int {
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        return workouts.filter { workout in
            let workoutMonth = calendar.component(.month, from: workout.date ?? Date())
            let workoutYear = calendar.component(.year, from: workout.date ?? Date())
            return workoutMonth == currentMonth && workoutYear == currentYear
        }.count
    }
    
    // Días únicos con entrenamientos en el mes actual
    private var uniqueWorkoutDays: Int {
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        let workoutDates = Set(workouts.compactMap { workout in
            let workoutMonth = calendar.component(.month, from: workout.date ?? Date())
            let workoutYear = calendar.component(.year, from: workout.date ?? Date())
            if workoutMonth == currentMonth && workoutYear == currentYear {
                return calendar.startOfDay(for: workout.date ?? Date())
            }
            return nil
        })
        
        return workoutDates.count
    }
    
    // Estadísticas del año
    private var yearStats: (totalWorkouts: Int, totalMinutes: Int, currentStreak: Int) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let yearWorkouts = workouts.filter { 
            Calendar.current.component(.year, from: $0.date ?? Date()) == currentYear 
        }
        
        return (
            totalWorkouts: yearWorkouts.count,
            totalMinutes: yearWorkouts.reduce(0) { $0 + Int($1.duration) },
            currentStreak: calculateCurrentStreak()
        )
    }
    
    var body: some View {
        ZStack {
            Image("historialBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            AppConstants.Design.backgroundGradient
                .opacity(0.7)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    if workouts.isEmpty {
                        motivationalEmptySection
                    } else {
                        calendarSection
                        monthSummarySection
                        statsSection
                    }
                }
                .padding(.horizontal, AppConstants.UI.spacingL)
                .padding(.top, AppConstants.UI.spacingXL)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: AppConstants.Animation.entrance)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            // Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: AppConstants.UI.spacingS) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Atrás")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, AppConstants.UI.spacingM)
                    .padding(.vertical, AppConstants.UI.spacingS)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusM)
                            .fill(.ultraThinMaterial.opacity(0.7))
                    )
                }
                .accessibilityLabel("Volver atrás")
                
                Spacer()
            }
            
            // Title Section
            VStack(spacing: AppConstants.UI.spacingM) {
                Text("Historial de Entrenamientos")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Text("Revisa tu progreso y mantente motivado")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, AppConstants.UI.spacingL)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -20)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: 24) {
            HistorialCalendarView(
                workouts: Array(workouts),
                currentDate: $currentDate
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppConstants.Design.cardBackground())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                )
        )
        .shadow(color: AppConstants.Design.cardShadow(), radius: AppConstants.UI.shadowRadius)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Month Summary Section
    private var monthSummarySection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            HStack {
                VStack(alignment: .leading, spacing: AppConstants.UI.spacingXS) {
                    Text("Resumen del mes")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    
                    Text("Tu actividad reciente")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            
            HStack(spacing: AppConstants.UI.spacingL) {
                // Días entrenados
                VStack(spacing: AppConstants.UI.spacingM) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "calendar.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: AppConstants.UI.spacingXS) {
                        Text("\(uniqueWorkoutDays)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(uniqueWorkoutDays == 1 ? "día entrenado" : "días entrenados")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppConstants.UI.spacingL)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .fill(AppConstants.Design.cardBackground())
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Total entrenamientos
                VStack(spacing: AppConstants.UI.spacingM) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "figure.run.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                    }
                    
                    VStack(spacing: AppConstants.UI.spacingXS) {
                        Text("\(currentMonthWorkouts)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(currentMonthWorkouts == 1 ? "entrenamiento" : "entrenamientos")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppConstants.UI.spacingL)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .fill(AppConstants.Design.cardBackground())
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            HStack {
                VStack(alignment: .leading, spacing: AppConstants.UI.spacingXS) {
                    Text("Estadísticas del año")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    
                    Text("Tu progreso anual")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            
            VStack(spacing: AppConstants.UI.spacingM) {
                HStack(spacing: AppConstants.UI.spacingM) {
                    StatCard(
                        icon: "figure.walk.circle.fill",
                        value: "\(yearStats.totalWorkouts)",
                        label: "Entrenamientos",
                        color: .blue,
                        accentColor: .blue.opacity(0.2)
                    )
                    
                    StatCard(
                        icon: "clock.fill",
                        value: "\(yearStats.totalMinutes)",
                        label: "Minutos",
                        color: .green,
                        accentColor: .green.opacity(0.2)
                    )
                }
                
                HStack(spacing: AppConstants.UI.spacingM) {
                    StatCard(
                        icon: "flame.fill",
                        value: "\(yearStats.currentStreak)",
                        label: "Racha actual",
                        color: .orange,
                        accentColor: .orange.opacity(0.2)
                    )
                    
                    StatCard(
                        icon: "heart.circle.fill",
                        value: "\(Int(Double(yearStats.totalMinutes) * 8.0))",
                        label: "Calorías quemadas",
                        color: .red,
                        accentColor: .red.opacity(0.2)
                    )
                }
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Helper Functions
    private func calculateCurrentStreak() -> Int {
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
    
    // MARK: - Motivational Empty Section
    private var motivationalEmptySection: some View {
        VStack(spacing: 40) {
            // Motivational message
            let message = motivationalManager.getMessage(for: .historyEmpty)
            MotivationalCardView(message: message, style: .prominent)
            
            // Empty state illustration
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.Design.lavender.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "figure.run.circle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppConstants.Design.lavender.opacity(0.8), AppConstants.Design.electricBlue.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(spacing: 12) {
                    Text("Tu historial de entrenamientos")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Aquí aparecerán todos tus entrenamientos una vez que comiences tu viaje fitness.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateOnAppear)
        }
        .padding(.top, 60)
    }
}

// MARK: - Historial Calendar Component
struct HistorialCalendarView: View {
    let workouts: [WorkoutEntity]
    @Binding var currentDate: Date
    
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
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Month header with navigation
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(AppConstants.Design.cardBackground())
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentDate).capitalized)
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(AppConstants.Design.cardBackground())
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 12) {
                // Weekday headers
                HStack(spacing: 0) {
                    ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { day in
                        Text(day)
                            .font(AppConstants.Design.captionFont)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                    ForEach(monthDays, id: \.self) { date in
                        HistorialCalendarDayView(
                            date: date,
                            hasWorkout: hasWorkout(on: date),
                            isCurrentMonth: isCurrentMonth(date),
                            isToday: isToday(date)
                        )
                    }
                }
            }
            
            // Legend
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                    Text("Sin entrenar")
                        .font(AppConstants.Design.footnoteFont)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Text("Con entrenamiento")
                        .font(AppConstants.Design.footnoteFont)
                        .foregroundColor(.gray)
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

struct HistorialCalendarDayView: View {
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
        .frame(width: 36, height: 36)
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


#Preview {
    NavigationStack {
        HistorialView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}