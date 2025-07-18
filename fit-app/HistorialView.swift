import SwiftUI
import CoreData
import Foundation
import Combine

// MARK: - HistorialViewModel
@MainActor
final class HistorialViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var animateOnAppear = false
    @Published var currentDate = Date()
    @Published var showingTrainingDetail = false
    @Published var selectedDateWorkouts: [WorkoutEntity] = []
    @Published var selectedDate = Date()
    
    // Cached computed properties to avoid recalculation in body
    @Published private(set) var currentMonthWorkouts: Int = 0
    @Published private(set) var uniqueWorkoutDays: Int = 0
    @Published private(set) var yearStats: (totalWorkouts: Int, totalMinutes: Int, currentStreak: Int) = (0, 0, 0)
    
    private let calendar = Calendar.current
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private var workouts: FetchedResults<WorkoutEntity>?
    
    // MARK: - Initialization
    init() {
        // Setup date change monitoring
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCurrentDate()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func configure(with workouts: FetchedResults<WorkoutEntity>) {
        self.workouts = workouts
        updateCachedProperties()
    }
    
    func onAppear() {
        guard !animateOnAppear else { return } // Prevent double animation
        
        withAnimation(.easeOut(duration: 0.8)) {
            animateOnAppear = true
        }
        
        updateCachedProperties()
    }
    
    func onDateTapped(_ date: Date) {
        guard let workouts = workouts else { return }
        let dayWorkouts = workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }
        if !dayWorkouts.isEmpty {
            selectedDate = date
            selectedDateWorkouts = dayWorkouts
            showingTrainingDetail = true
        }
    }
    
    func updateCurrentDate() {
        let newDate = Date()
        if !calendar.isDate(currentDate, inSameDayAs: newDate) {
            currentDate = newDate
            updateCachedProperties()
        }
    }
    
    // MARK: - Private Methods
    private func updateCachedProperties() {
        guard let workouts = workouts else { return }
        
        // Calculate values asynchronously to avoid blocking UI
        Task { @MainActor in
            let currentMonth = self.calendar.component(.month, from: self.currentDate)
            let currentYear = self.calendar.component(.year, from: self.currentDate)
            
            // Calculate current month workouts
            let monthWorkouts = Array(workouts).filter { workout in
                let workoutMonth = self.calendar.component(.month, from: workout.date ?? Date())
                let workoutYear = self.calendar.component(.year, from: workout.date ?? Date())
                return workoutMonth == currentMonth && workoutYear == currentYear
            }.count
            
            // Calculate unique workout days
            let workoutDates = Set(Array(workouts).compactMap { workout in
                let workoutMonth = self.calendar.component(.month, from: workout.date ?? Date())
                let workoutYear = self.calendar.component(.year, from: workout.date ?? Date())
                if workoutMonth == currentMonth && workoutYear == currentYear {
                    return self.calendar.startOfDay(for: workout.date ?? Date())
                }
                return nil
            })
            let uniqueDays = workoutDates.count
            
            // Calculate year stats
            let yearWorkouts = Array(workouts).filter {
                self.calendar.component(.year, from: $0.date ?? Date()) == currentYear
            }
            
            let totalWorkouts = yearWorkouts.count
            let totalMinutes = yearWorkouts.reduce(0) { $0 + Int($1.duration) }
            let currentStreak = await self.calculateCurrentStreak(from: Array(workouts))
            
            // Update properties directly since we're already on MainActor
            self.currentMonthWorkouts = monthWorkouts
            self.uniqueWorkoutDays = uniqueDays
            self.yearStats = (totalWorkouts: totalWorkouts, totalMinutes: totalMinutes, currentStreak: currentStreak)
        }
    }
    
    private func calculateCurrentStreak(from workouts: [WorkoutEntity]) async -> Int {
        let today = Date()
        let sortedWorkouts = workouts
    
            .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        
        var streak = 0
        var currentDate = today
        let calendar = Calendar.current
        
        // Check if we worked out today or yesterday to start streak
        let hasWorkoutToday = sortedWorkouts.contains { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: today)
        }
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let hasWorkoutYesterday = sortedWorkouts.contains { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: yesterday)
        }
        
        if hasWorkoutToday {
            currentDate = today
        } else if hasWorkoutYesterday {
            currentDate = yesterday
        } else {
            return 0 // No recent workouts
        }
        
        // Count consecutive days with workouts
        for i in 0..<30 { // Limit to 30 days to prevent long calculations
            let checkDate = calendar.date(byAdding: .day, value: -i, to: currentDate) ?? currentDate
            
            let hasWorkout = sortedWorkouts.contains { workout in
                calendar.isDate(workout.date ?? Date(), inSameDayAs: checkDate)
            }
            
            if hasWorkout {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
}

struct HistorialView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.navigationContext) private var navigationContext
    @EnvironmentObject private var navigationStateManager: NavigationStateManager
    @StateObject private var viewModel = HistorialViewModel()
    @StateObject private var motivationalManager = XiotqQDHiBDxqWDO0uwhKXZcSWBnijF5()
    
    private let calendar = Calendar.current
    
    // Check if this is the root view (no navigation stack)
    private var isRoot: Bool {
        return navigationStateManager.isRootView()
    }
    
    var body: some View {
        ReusableBackgroundView {
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
                .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
                .padding(.top, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.MClncXuDMA0DqsjaIRrg0bNnW3Yqs1En)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(navigationContext.isFromTab)
        .navigationBarBackButtonHidden(isRoot)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isRoot {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Atrás") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .overlay {
            if viewModel.showingTrainingDetail {
                nXGgxr19LIpVKcd4cUEVl275ihvhFfMi(
                    workouts: viewModel.selectedDateWorkouts,
                    selectedDate: viewModel.selectedDate,
                    isPresented: $viewModel.showingTrainingDetail
                )
            }
        }
        .onAppear {
            viewModel.configure(with: workouts)
            viewModel.onAppear()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX) {
            
            // Title Section
            VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
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
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
        .opacity(viewModel.animateOnAppear ? 1 : 0)
        .offset(y: viewModel.animateOnAppear ? 0 : -20)
        .animation(.easeOut(duration: 0.6), value: viewModel.animateOnAppear)
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: 24) {
            oceDsSstWUWphwxip8d8NBirtHgG7NaD(
                workouts: Array(workouts),
                currentDate: $viewModel.currentDate,
                onDateTapped: viewModel.onDateTapped
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb(), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                )
        )
        .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.bTCtL4JJ6s6CZeDy20yfXlv4bGc83wHJ)
        .opacity(viewModel.animateOnAppear ? 1 : 0)
        .offset(y: viewModel.animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: viewModel.animateOnAppear)
    }
    
    // MARK: - Month Summary Section
    private var monthSummarySection: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX) {
            HStack {
                VStack(alignment: .leading, spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.GPTIMVzXVhYLFkeR151yq7JxB8fmAAgB) {
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
            
            HStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX) {
                // Días entrenados
                VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "calendar.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.GPTIMVzXVhYLFkeR151yq7JxB8fmAAgB) {
                        Text("\(viewModel.uniqueWorkoutDays)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(viewModel.uniqueWorkoutDays == 1 ? "día entrenado" : "días entrenados")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
                .background(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                        .overlay(
                            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Total entrenamientos
                VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "figure.run.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                    }
                    
                    VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.GPTIMVzXVhYLFkeR151yq7JxB8fmAAgB) {
                        Text("\(viewModel.currentMonthWorkouts)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(viewModel.currentMonthWorkouts == 1 ? "entrenamiento" : "entrenamientos")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
                .background(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                        .overlay(
                            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .opacity(viewModel.animateOnAppear ? 1 : 0)
        .offset(y: viewModel.animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: viewModel.animateOnAppear)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX) {
            HStack {
                VStack(alignment: .leading, spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.GPTIMVzXVhYLFkeR151yq7JxB8fmAAgB) {
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
            
            VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                HStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "figure.walk.circle.fill",
                        value: "\(viewModel.yearStats.totalWorkouts)",
                        label: "Entrenamientos",
                        color: .blue,
                        accentColor: .blue.opacity(0.2)
                    )
                    
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "clock.fill",
                        value: "\(viewModel.yearStats.totalMinutes)",
                        label: "Minutos",
                        color: .green,
                        accentColor: .green.opacity(0.2)
                    )
                }
                
                HStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "flame.fill",
                        value: "\(viewModel.yearStats.currentStreak)",
                        label: "Racha actual",
                        color: .orange,
                        accentColor: .orange.opacity(0.2)
                    )
                    
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "heart.circle.fill",
                        value: "\(Int(Double(viewModel.yearStats.totalMinutes) * 8.0))",
                        label: "Calorías quemadas",
                        color: .red,
                        accentColor: .red.opacity(0.2)
                    )
                }
            }
        }
        .opacity(viewModel.animateOnAppear ? 1 : 0)
        .offset(y: viewModel.animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: viewModel.animateOnAppear)
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
                if viewModel.uniqueWorkoutDays < 3 {
                    N7eL9gZE0A11qwNe9gQnqZgiUbl9xJNG(
                        icon: "calendar.badge.plus",
                        title: "Consistencia es clave",
                        description: "Intenta entrenar al menos 3 días por semana para ver mejores resultados.",
                        color: .blue
                    )
                }
                
                if viewModel.yearStats.currentStreak < 2 {
                    N7eL9gZE0A11qwNe9gQnqZgiUbl9xJNG(
                        icon: "flame",
                        title: "Construye una racha",
                        description: "Entrenar días consecutivos te ayudará a crear un hábito duradero.",
                        color: .orange
                    )
                }
                
                N7eL9gZE0A11qwNe9gQnqZgiUbl9xJNG(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Toca los días verdes",
                    description: "Puedes tocar cualquier día con entrenamientos para ver los detalles.",
                    color: .green
                )
            }
        }
        .opacity(viewModel.animateOnAppear ? 1 : 0)
        .offset(y: viewModel.animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: viewModel.animateOnAppear)
    }
    
    // MARK: - Helper Functions
    private func ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() -> Int {
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
            let message = motivationalManager.Ybk5XOhw1M7TunRE3Dn538FHOpTonv3u(for: .Tif5QvZbPrNxdiMJjqB4Pdn0BsvZ7HHX)
            F86UW67ccAWVKtMzac7t2afh26jfxsLy(message: message, style: .prominent)
            
            // Empty state illustration
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "figure.run.circle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.8), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.6)],
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
            .opacity(viewModel.animateOnAppear ? 1 : 0)
            .offset(y: viewModel.animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: viewModel.animateOnAppear)
        }
        .padding(.top, 60)
    }
}

// MARK: - Historial Calendar Component
struct oceDsSstWUWphwxip8d8NBirtHgG7NaD: View {
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
    
    private func I5QHsgWv2XdgE8VXWpNhUE9yI61yQBYz(on date: Date) -> Bool {
        return workouts.contains { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }
    }
    
    private func BWTR4Vgb1weh4426ZM6Sc1cFb9jEevSR(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    private func ykbetZRJo3OKvmT68bNRhKbN98vh2Tfa(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func quGNjxwNr6bMGLmIjninKcK5mhqTZz8S(for date: Date) -> Int {
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Month header with navigation
            HStack {
                Button(action: { phuNA2QE28qZfTQFibb6uOKGWTixpvSn(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentDate).capitalized)
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { phuNA2QE28qZfTQFibb6uOKGWTixpvSn(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
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
                        mDqHln5jpNpX9aXfdeepN8vGoNsyrK6F(
                            date: date,
                            hasWorkout: I5QHsgWv2XdgE8VXWpNhUE9yI61yQBYz(on: date),
                            isCurrentMonth: BWTR4Vgb1weh4426ZM6Sc1cFb9jEevSR(date),
                            isToday: ykbetZRJo3OKvmT68bNRhKbN98vh2Tfa(date),
                            isFuture: date > Date(),
                            workoutCount: quGNjxwNr6bMGLmIjninKcK5mhqTZz8S(for: date),
                            onTap: onDateTapped
                        )
                    }
                }
            }
            
            // Enhanced Legend
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    v9d1B8mYymhWhGKFTSBC3IHqtFBZuol1(color: .green, label: "Con entrenamientos")
                    v9d1B8mYymhWhGKFTSBC3IHqtFBZuol1(color: .blue, label: "Hoy")
                }
                
                HStack(spacing: 16) {
                    v9d1B8mYymhWhGKFTSBC3IHqtFBZuol1(color: .white.opacity(0.1), label: "Sin entrenamientos")
                    v9d1B8mYymhWhGKFTSBC3IHqtFBZuol1(color: .white.opacity(0.05), label: "Días futuros")
                }
            }
        }
    }
    
    private func phuNA2QE28qZfTQFibb6uOKGWTixpvSn(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentDate = newDate
            }
        }
    }
}

// MARK: - Enhanced Calendar Day View
struct mDqHln5jpNpX9aXfdeepN8vGoNsyrK6F: View {
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

struct v9d1B8mYymhWhGKFTSBC3IHqtFBZuol1: View {
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


struct GP7fIuwXYVLPbSohw6PU7LnEgTOlS3dT: View {
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

struct N7eL9gZE0A11qwNe9gQnqZgiUbl9xJNG: View {
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
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}

// MARK: - Training Detail Popup View Component
struct nXGgxr19LIpVKcd4cUEVl275ihvhFfMi: View {
    let workouts: [WorkoutEntity]
    let selectedDate: Date
    @Binding var isPresented: Bool
    @State private var animateOnAppear = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "es_ES")
        return formatter
    }()
    
    private func yABx61qWD7PwWueiyg0PAv2nhCa3HW7b(for type: String) -> String {
        switch type {
        case "Cardio": return "heart.circle.fill"
        case "Fuerza": return "dumbbell.fill"
        case "Yoga": return "figure.mind.and.body"
        case "Caminata": return "figure.walk"
        case "Ciclismo": return "bicycle"
        case "Natación": return "figure.pool.swim"
        case "Striking": return "figure.boxing"
        case "Jiu Jitsu": return "figure.martial.arts"
        default: return "figure.walk.circle.fill"
        }
    }
    
    private func pHqJYdyeSs1Bb7xNvO3B8rgRJtiXBSN8(for type: String) -> Color {
        switch type {
        case "Cardio": return .red
        case "Fuerza": return .blue
        case "Yoga": return .purple
        case "Caminata": return .green
        case "Ciclismo": return .yellow
        case "Natación": return .cyan
        case "Striking": return .red
        case "Jiu Jitsu": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    iSwvwIR1ECPW7Q9WvcFq3vb42IbDnJVO()
                }
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Entrenamientos")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(dateFormatter.string(from: selectedDate))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Button(action: iSwvwIR1ECPW7Q9WvcFq3vb42IbDnJVO) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Text("\(workouts.count) entrenamiento\(workouts.count > 1 ? "s" : "") registrado\(workouts.count > 1 ? "s" : "")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 20)
                
                // Workouts list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(workouts.enumerated()), id: \.element.objectID) { index, workout in
                            GP7fIuwXYVLPbSohw6PU7LnEgTOlS3dT(workout: workout)
                                .opacity(animateOnAppear ? 1 : 0)
                                .offset(y: animateOnAppear ? 0 : 30)
                                .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: animateOnAppear)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .frame(maxHeight: 400)
                
                // Close button
                Button(action: iSwvwIR1ECPW7Q9WvcFq3vb42IbDnJVO) {
                    Text("Entendido")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.BRZumEEKLDNhpWlIssXSSHs7tRJDkiWk)
                        )
                        .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
            .scaleEffect(animateOnAppear ? 1 : 0.9)
            .opacity(animateOnAppear ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateOnAppear)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                animateOnAppear = true
            }
        }
    }
    
    private func iSwvwIR1ECPW7Q9WvcFq3vb42IbDnJVO() {
        withAnimation(.easeInOut(duration: 0.2)) {
            animateOnAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}
