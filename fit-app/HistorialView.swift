import SwiftUI
import CoreData

struct HistorialView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.dismiss) private var dismiss
    @State private var animateOnAppear = false
    @State private var currentDate = Date()
    
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
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    calendarSection
                    monthSummarySection
                    statsSection
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
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            Spacer()
            
            VStack(spacing: AppConstants.UI.spacingS) {
                Text("Historial de Entrenamientos")
                    .font(AppConstants.Design.headerFont)
                    .foregroundColor(.white)
                
                Text("Tu actividad mensual")
                    .font(AppConstants.Design.bodyFont)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            // Espacio para balancear el botón izquierdo
            Color.clear
                .frame(width: 40, height: 40)
        }
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
        VStack(spacing: 16) {
            HStack {
                Text("Resumen del mes")
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(uniqueWorkoutDays)")
                                .font(AppConstants.Design.subheaderFont)
                                .foregroundColor(.white)
                            Text(uniqueWorkoutDays == 1 ? "día entrenado" : "días entrenados")
                                .font(AppConstants.Design.captionFont)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "figure.run.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(currentMonthWorkouts)")
                                .font(AppConstants.Design.subheaderFont)
                                .foregroundColor(.white)
                            Text(currentMonthWorkouts == 1 ? "entrenamiento" : "entrenamientos")
                                .font(AppConstants.Design.captionFont)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppConstants.Design.cardBackground())
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                    )
            )
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            Text("Estadísticas del año")
                .font(AppConstants.Design.headerFont)
                .foregroundColor(.white)
            
            HStack(spacing: AppConstants.UI.spacingL) {
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
                
                StatCard(
                    icon: "flame.fill",
                    value: "\(yearStats.currentStreak)",
                    label: "Racha actual",
                    color: .orange,
                    accentColor: .orange.opacity(0.2)
                )
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