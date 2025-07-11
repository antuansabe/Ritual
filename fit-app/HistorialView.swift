import SwiftUI
import CoreData

struct GkjEDEAm9UyaMK6Kk0bByhUgGKoNBp9n: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.dismiss) private var dismiss
    @State private var animateOnAppear = false
    @State private var currentDate = Date()
    @StateObject private var motivationalManager = XiotqQDHiBDxqWDO0uwhKXZcSWBnijF5()
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
            currentStreak: ES0BZT8uITuIRS240cz0GJ4YC02PSyRU()
        )
    }
    
    var body: some View {
        ZStack {
            Image("historialBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
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
                .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
                .padding(.top, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.MClncXuDMA0DqsjaIRrg0bNnW3Yqs1En)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if showingTrainingDetail {
                nXGgxr19LIpVKcd4cUEVl275ihvhFfMi(
                    workouts: selectedDateWorkouts,
                    selectedDate: selectedDate,
                    isPresented: $showingTrainingDetail
                )
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.TY7ZW5houGPwMVFGImNlC3I3EcEAN4GI.Z7xsdjw2hnYbjHVMQnLaw3tNvHBSqyDS)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX) {
            // Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.WGScMqI3Q6T0pZ22WIc8o7hkW683p3YO) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Atrás")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX)
                    .padding(.vertical, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.WGScMqI3Q6T0pZ22WIc8o7hkW683p3YO)
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.LN3B4n9YFxSm5ylLDbkTP1ORcAc8zVlA)
                            .fill(.ultraThinMaterial.opacity(0.7))
                    )
                }
                .accessibilityLabel("Volver atrás")
                
                Spacer()
            }
            
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
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -20)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: 24) {
            oceDsSstWUWphwxip8d8NBirtHgG7NaD(
                workouts: Array(workouts),
                currentDate: $currentDate,
                onDateTapped: tl87jyemPGoeAbhiIqFd9TgmT6nD12Dv
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
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
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
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
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
                        value: "\(yearStats.totalWorkouts)",
                        label: "Entrenamientos",
                        color: .blue,
                        accentColor: .blue.opacity(0.2)
                    )
                    
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "clock.fill",
                        value: "\(yearStats.totalMinutes)",
                        label: "Minutos",
                        color: .green,
                        accentColor: .green.opacity(0.2)
                    )
                }
                
                HStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                        icon: "flame.fill",
                        value: "\(yearStats.currentStreak)",
                        label: "Racha actual",
                        color: .orange,
                        accentColor: .orange.opacity(0.2)
                    )
                    
                    Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
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
                    N7eL9gZE0A11qwNe9gQnqZgiUbl9xJNG(
                        icon: "calendar.badge.plus",
                        title: "Consistencia es clave",
                        description: "Intenta entrenar al menos 3 días por semana para ver mejores resultados.",
                        color: .blue
                    )
                }
                
                if yearStats.currentStreak < 2 {
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
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateOnAppear)
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
    
    // MARK: - Helper Functions for Popup
    private func ywPG64ejD7uBxMvKVW2dv1WUKfTklcvp(_ date: Date) -> [WorkoutEntity] {
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), inSameDayAs: date)
        }
    }
    
    private func tl87jyemPGoeAbhiIqFd9TgmT6nD12Dv(for date: Date) {
        let dayWorkouts = ywPG64ejD7uBxMvKVW2dv1WUKfTklcvp(date)
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
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateOnAppear)
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
        GkjEDEAm9UyaMK6Kk0bByhUgGKoNBp9n()
    }
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}