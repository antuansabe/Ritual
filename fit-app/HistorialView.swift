import SwiftUI
import CoreData

struct HistorialView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.dismiss) private var dismiss
    @State private var animateOnAppear = false
    @State private var currentDate = Date()
    @StateObject private var motivationalManager = MotivationalMessageManager()
    @State private var showingTrainingDetail = false
    @State private var selectedDateWorkouts: [WorkoutEntity] = []
    @State private var selectedDate = Date()
    
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
                        tipsSection
                    }
                }
                .padding(.horizontal, AppConstants.UI.spacingL)
                .padding(.top, AppConstants.UI.spacingXL)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if showingTrainingDetail {
                TrainingDetailPopupView(
                    workouts: selectedDateWorkouts,
                    selectedDate: selectedDate,
                    isPresented: $showingTrainingDetail
                )
            }
        }
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
                currentDate: $currentDate,
                onDateTapped: showTrainingDetails
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
    
    // MARK: - Tips Section
    private var tipsSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tips para mejorar")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Consejos personalizados")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            
            VStack(spacing: 12) {
                if uniqueWorkoutDays < 3 {
                    TipCard(
                        icon: "calendar.badge.plus",
                        title: "Consistencia es clave",
                        description: "Intenta entrenar al menos 3 días por semana para ver mejores resultados.",
                        color: .blue
                    )
                }
                
                if yearStats.currentStreak < 2 {
                    TipCard(
                        icon: "flame",
                        title: "Construye una racha",
                        description: "Entrenar días consecutivos te ayudará a crear un hábito duradero.",
                        color: .orange
                    )
                }
                
                TipCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Toca los días verdes",
                    description: "Puedes tocar cualquier día con entrenamientos para ver los detalles.",
                    color: .green
                )
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateOnAppear)
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
    
    // MARK: - Helper Functions for Popup
    private func getWorkoutsForDate(_ date: Date) -> [WorkoutEntity] {
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }
    }
    
    private func showTrainingDetails(for date: Date) {
        let dayWorkouts = getWorkoutsForDate(date)
        if !dayWorkouts.isEmpty {
            selectedDate = date
            selectedDateWorkouts = dayWorkouts
            showingTrainingDetail = true
        }
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
    let onDateTapped: (Date) -> Void
    
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
        
        // Fix: Calendar first weekday in Spanish should be Monday (2), not Sunday (1)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        // Convert from Sunday=1 to Monday=1 system
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        let startingSpaces = (adjustedFirstWeekday - 1) % 7
        
        var days: [Date] = []
        
        // Add previous month days for spacing
        for i in 0..<startingSpaces {
            if let date = calendar.date(byAdding: .day, value: -(startingSpaces - i), to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        // Add all days of the current month
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        // Add next month days to complete the grid (to have 42 days total for a complete 6-week view)
        let totalCells = 42
        let currentDaysCount = days.count
        if currentDaysCount < totalCells {
            let lastDayOfMonth = days.last ?? firstDayOfMonth
            for i in 1...(totalCells - currentDaysCount) {
                if let date = calendar.date(byAdding: .day, value: i, to: lastDayOfMonth) {
                    days.append(date)
                }
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
    
    private func getWorkoutCount(for date: Date) -> Int {
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }.count
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
                // Weekday headers - Fixed order starting with Sunday
                HStack(spacing: 0) {
                    ForEach(["D", "L", "M", "M", "J", "V", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Calendar grid - Improved layout
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                    ForEach(monthDays, id: \.self) { date in
                        EnhancedCalendarDayView(
                            date: date,
                            hasWorkout: hasWorkout(on: date),
                            isCurrentMonth: isCurrentMonth(date),
                            isToday: isToday(date),
                            isFuture: date > Date(),
                            workoutCount: getWorkoutCount(for: date),
                            onTap: onDateTapped
                        )
                    }
                }
            }
            
            // Enhanced Legend
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    LegendItem(color: .green, label: "Con entrenamientos")
                    LegendItem(color: .blue, label: "Hoy")
                }
                
                HStack(spacing: 16) {
                    LegendItem(color: .white.opacity(0.1), label: "Sin entrenamientos")
                    LegendItem(color: .white.opacity(0.05), label: "Días futuros")
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

// MARK: - Enhanced Calendar Day View
struct EnhancedCalendarDayView: View {
    let date: Date
    let hasWorkout: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    let isFuture: Bool
    let workoutCount: Int
    let onTap: (Date) -> Void
    
    @State private var isPressed = false
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text(dayNumber)
                .font(.system(size: 14, weight: fontWeight))
                .foregroundColor(textColor)
            
            // Workout indicator dots
            if hasWorkout && isCurrentMonth {
                HStack(spacing: 2) {
                    ForEach(0..<min(workoutCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 3, height: 3)
                    }
                    
                    if workoutCount > 3 {
                        Text("+")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(width: 40, height: 40)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .scaleEffect(scaleEffect)
        .opacity(opacityValue)
        .animation(.easeInOut(duration: 0.2), value: hasWorkout)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            if isCurrentMonth && (hasWorkout || !isFuture) {
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                onTap(date)
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if isCurrentMonth && (hasWorkout || !isFuture) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
    }
    
    private var fontWeight: Font.Weight {
        if isToday { return .bold }
        if hasWorkout { return .semibold }
        return .medium
    }
    
    private var backgroundColor: Color {
        if !isCurrentMonth { return Color.clear }
        if isFuture { return Color.white.opacity(0.05) }
        if hasWorkout { return Color.green.opacity(0.8) }
        if isToday { return Color.blue.opacity(0.3) }
        return Color.white.opacity(0.1)
    }
    
    private var textColor: Color {
        if !isCurrentMonth { return .gray.opacity(0.4) }
        if isFuture { return .white.opacity(0.4) }
        if hasWorkout { return .white }
        if isToday { return .white }
        return .white.opacity(0.7)
    }
    
    private var borderColor: Color {
        if isToday { return Color.blue }
        if hasWorkout && isCurrentMonth { return Color.green.opacity(0.6) }
        return Color.clear
    }
    
    private var borderWidth: CGFloat {
        if isToday || (hasWorkout && isCurrentMonth) { return 2 }
        return 0
    }
    
    private var scaleEffect: CGFloat {
        if !isCurrentMonth { return 0.8 }
        if isPressed { return 0.9 }
        return 1.0
    }
    
    private var opacityValue: Double {
        if !isCurrentMonth { return 0.3 }
        if isFuture { return 0.6 }
        return 1.0
    }
    
    private var accessibilityLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        var label = dateFormatter.string(from: date)
        if isToday { label += ", hoy" }
        if hasWorkout { 
            label += ", \(workoutCount) entrenamiento\(workoutCount == 1 ? "" : "s")"
        }
        return label
    }
    
    private var accessibilityHint: String {
        if !isCurrentMonth { return "Día de otro mes" }
        if isFuture { return "Día futuro" }
        if hasWorkout { return "Toca para ver detalles del entrenamiento" }
        return "Día sin entrenamientos"
    }
}

// MARK: - Supporting Components

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 12, height: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}


struct WorkoutSummaryCard: View {
    let workout: WorkoutEntity
    
    private var activityIcon: String {
        switch workout.type?.lowercased() {
        case "cardio": return "heart.circle.fill"
        case "fuerza": return "dumbbell.fill"
        case "yoga": return "figure.mind.and.body"
        case "caminata": return "figure.walk"
        case "ciclismo": return "bicycle"
        case "jiu jitsu": return "figure.martial.arts"
        default: return "figure.run"
        }
    }
    
    private var activityColor: Color {
        switch workout.type?.lowercased() {
        case "cardio": return .red
        case "fuerza": return .blue
        case "yoga": return .purple
        case "caminata": return .green
        case "ciclismo": return .yellow
        case "jiu jitsu": return .purple
        default: return .orange
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(activityColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: activityIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(activityColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type ?? "Entrenamiento")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Label("\(Int(workout.duration)) min", systemImage: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                    
                    if workout.calories > 0 {
                        Label("\(Int(workout.calories)) cal", systemImage: "flame")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(activityColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        HistorialView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}