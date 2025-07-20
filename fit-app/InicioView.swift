import SwiftUI
import CoreData
import CloudKit
import Combine

// MARK: - Reusable Components
struct rji5oBHeH5tqY2OwV0PYO7wSVw6bBkHN: View {
    let icon: String
    let value: String
    let label: String
    let tint: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(tint)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                    .accessibilityLabel("\(value) \(label)")
                
                Text(label)
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                .overlay(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb(), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                )
        )
        .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.bTCtL4JJ6s6CZeDy20yfXlv4bGc83wHJ)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct EWDw9mu6qEuNiuUcgPj0IepRcg2x8IdN: View {
    let workout: WorkoutEntity
    
    private var workoutIcon: String {
        switch workout.type ?? "" {
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
    
    private var workoutColor: Color {
        switch workout.type ?? "" {
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(workoutColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: workoutIcon)
                    .font(.title3)
                    .foregroundColor(workoutColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(workout.type ?? "")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qnotkIGWtshhYry4tQS0eVmv25ZankxQ)
                    .foregroundColor(.white)
                
                Text("\(workout.duration) min • \(workout.calories) kcal")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: workout.date ?? Date()))
                .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
        .padding(.vertical, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
        .background(
            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                .overlay(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb(), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                )
        )
        .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.bTCtL4JJ6s6CZeDy20yfXlv4bGc83wHJ)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(workout.type ?? "") workout, \(workout.duration) minutes, \(workout.calories) calories, \(dateFormatter.string(from: workout.date ?? Date()))")
    }
}


struct nGHHMNtoBwM0IFT4HW5NflwlHlDPD5KZ: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    
    @ObservedObject private var offlineManager = f44CM3JdBo3CztstNOncNr1s4UV8ejD1.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @ObservedObject private var networkMonitor = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @ObservedObject private var userProfileManager = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var animateOnAppear = false
    @State private var showingRegistro = false
    @State private var showingHistorial = false
    @State private var showingLogoutConfirmation = false
    @Namespace private var heroAnimation
    
    
    // Add TabView selection binding
    @Binding var selectedTab: Int
    
    var body: some View {
        ReusableBackgroundView {
            ScrollView {
                LazyVStack(spacing: 40) {
                    headerSection
                    metricsSection
                    recentWorkoutsSection
                }
                .padding(.top, 20)
            }
            .safeAreaInset(edge: .bottom) { 
                Spacer().frame(height: 80) 
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHistorial) {
            HistorialView()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animateOnAppear = true
            }
        }
        .alert("Cerrar sesión", isPresented: $showingLogoutConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                authViewModel.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.MClncXuDMA0DqsjaIRrg0bNnW3Yqs1En) {
            // Motivational greeting with user name and daily phrase
            om15Jvsg84ivdDdMag8SIylK1uDB5JNJ()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
    }
    
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Progreso")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.VbiaN8et3V1H9i33HGvaIjSMOPgfM5UL)
                    .foregroundColor(.white)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.1), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            HStack {
                Spacer()
                HStack(spacing: 12) {
                    rji5oBHeH5tqY2OwV0PYO7wSVw6bBkHN(
                        icon: "figure.walk.circle.fill",
                        value: "\(workouts.count)",
                        label: "Entrenamientos",
                        tint: .blue
                    )
                    .matchedGeometryEffect(id: "workouts", in: heroAnimation)
                    
                    rji5oBHeH5tqY2OwV0PYO7wSVw6bBkHN(
                        icon: "clock.fill",
                        value: "\(workouts.reduce(0) { $0 + Int($1.duration) })",
                        label: "Minutos",
                        tint: .green
                    )
                    .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                    
                    rji5oBHeH5tqY2OwV0PYO7wSVw6bBkHN(
                        icon: "flame.fill",
                        value: "\(workouts.reduce(0) { $0 + Int($1.calories) })",
                        label: "Calorías",
                        tint: .orange
                    )
                    .matchedGeometryEffect(id: "calories", in: heroAnimation)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(x: animateOnAppear ? 0 : -50)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
        }
    }
    
    // MARK: - Recent Workouts Section
    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Entrenamientos recientes")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.VbiaN8et3V1H9i33HGvaIjSMOPgfM5UL)
                    .foregroundColor(.white)
                
                Spacer()
                
                if workouts.count > 3 {
                    Button("Ver historial") {
                        showingHistorial = true
                    }
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
                    .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr)
                }
            }
            .padding(.horizontal, 20)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateOnAppear)
            
            if !workouts.isEmpty {
                VStack(spacing: 12) {
                    ForEach(Array(workouts.prefix(3).enumerated()), id: \.element.objectID) { index, workout in
                        EWDw9mu6qEuNiuUcgPj0IepRcg2x8IdN(workout: workout)
                            .opacity(animateOnAppear ? 1 : 0)
                            .offset(y: animateOnAppear ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(0.4 + Double(index) * 0.1), value: animateOnAppear)
                    }
                }
                .padding(.horizontal, 20)
            } else {
                emptyStateView
                    .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
                .opacity(0.6)
            
            VStack(spacing: 8) {
                Text("Comienza tu viaje")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.VbiaN8et3V1H9i33HGvaIjSMOPgfM5UL)
                    .foregroundColor(.white)
                
                Text("Registra tu primer entrenamiento para comenzar a ver tu progreso")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qnotkIGWtshhYry4tQS0eVmv25ZankxQ)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button("Empezar ahora") {
                selectedTab = 1 // Navigate to Registrar tab
            }
            .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qnotkIGWtshhYry4tQS0eVmv25ZankxQ)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.BRZumEEKLDNhpWlIssXSSHs7tRJDkiWk)
            )
            .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.bTCtL4JJ6s6CZeDy20yfXlv4bGc83wHJ)
        }
        .padding(.vertical, 60)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - CloudKit Sync Section
    private var cloudKitSyncSection: some View {
        VStack(spacing: 16) {
            S5Y9Yc6Ooa6f2NuGIzvEGtIUI7akBoxu()
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateOnAppear)
        }
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
    }
    
    // MARK: - Sync Status Section
    private var syncStatusSection: some View {
        VStack(spacing: 16) {
            Rf9EmfwK66p5t78UXWHBzw52tpz7Fe6b()
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.25), value: animateOnAppear)
        }
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
    }
    
    // MARK: - Daily Summary Section
    private var dailySummarySection: some View {
        VStack(spacing: 0) {
            // Main card content
            VStack(spacing: 20) {
                dailySummaryHeaderSection
                dailySummaryStatusSection
                if ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 0 {
                    dailySummaryStreakSection
                }
                dailySummaryMotivationalSection
                dailySummaryQuickActionsSection
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.1), value: animateOnAppear)
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
    }
    
    // MARK: - Daily Summary Components
    
    // Computed properties for daily summary
    private var userName: String {
        userProfileManager.XBRN83PxWbEPMDPcnWx7eC9WBTmYZNbu
    }
    
    private var hasWorkoutToday: Bool {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.contains { workout in
            calendar.isDate(workout.date ?? Date.distantPast, inSameDayAs: today)
        }
    }
    
    private var todaysWorkouts: [WorkoutEntity] {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date.distantPast, inSameDayAs: today)
        }
    }
    
    private var dailySummaryHeaderSection: some View {
        HStack(spacing: 12) {
            // Profile circle with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.2)],
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
                Text("¡Hola, \(userName)!")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(dailyMessage)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // User menu button
            Menu {
                Button("Perfil", action: {
                    selectedTab = 3 // Navigate to Profile tab
                })
                
                Divider()
                
                Button("Cerrar sesión", role: .destructive, action: {
                    showingLogoutConfirmation = true
                })
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR)
            }
        }
    }
    
    private var dailySummaryStatusSection: some View {
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
    
    private var dailySummaryStreakSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20))
                .foregroundColor(.orange)
            
            Text("Racha: \(ES0BZT8uITuIRS240cz0GJ4YC02PSyRU()) día\(ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 1 ? "s" : "") seguido\(ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 1 ? "s" : "")")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("🔥")
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
    
    private var dailySummaryMotivationalSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 16))
                    .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR)
                
                Text("Frase del día")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            
            Text(Hen9DPHUaV3U90FVALLhUmHDtQHzFH5u())
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
                        colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.1), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    private var dailySummaryQuickActionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Acciones rápidas")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                huM94mVLDQIylRoMpinZ5UCCdJ8jxiCP(
                    title: hasWorkoutToday ? "Entrenar más" : "Entrenar ahora",
                    icon: "figure.walk",
                    color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT,
                    action: {
                        selectedTab = 1 // Navigate to Registro tab
                    }
                )
                
                huM94mVLDQIylRoMpinZ5UCCdJ8jxiCP(
                    title: "Ver progreso",
                    icon: "chart.bar.fill",
                    color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0,
                    action: {
                        selectedTab = 2 // Navigate to Historial tab
                    }
                )
                
                huM94mVLDQIylRoMpinZ5UCCdJ8jxiCP(
                    title: "Perfil",
                    icon: "person.circle.fill",
                    color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR,
                    action: {
                        selectedTab = 3 // Navigate to Perfil tab
                    }
                )
            }
        }
    }
    
    // Computed Properties for Daily Summary UI
    private var dailyMessage: String {
        if hasWorkoutToday {
            return "¡Excelente trabajo hoy! 💪"
        } else {
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                return "Hoy es un gran día para moverte 🌅"
            case 12..<18:
                return "Aún puedes regalarte unos minutos 🧘‍♂️"
            default:
                return "Relájate, mañana es otro día 🌙"
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
        } else if ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 0 {
            return "Mantén tu racha activa"
        } else {
            return "Todo bien, hoy puedes retomar"
        }
    }
    
    private var statusIcon: String {
        if hasWorkoutToday {
            return "checkmark.circle.fill"
        } else if ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 0 {
            return "figure.run.circle"
        } else {
            return "leaf.circle"
        }
    }
    
    private var statusColor: Color {
        if hasWorkoutToday {
            return pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT
        } else if ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 0 {
            return .orange
        } else {
            return pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0
        }
    }
    
    private func Hen9DPHUaV3U90FVALLhUmHDtQHzFH5u() -> String {
        let quotes = B3ItwUWFBPGf9Q1QQ8B3djtVIdtfZna5()
        return quotes.randomElement() ?? "Cada paso cuenta 🌟"
    }
    
    private func B3ItwUWFBPGf9Q1QQ8B3djtVIdtfZna5() -> [String] {
        if hasWorkoutToday {
            return [
                "¡Qué bien te has cuidado hoy! Tu cuerpo te lo agradece 💙",
                "Cada movimiento fue un acto de amor propio 🤗",
                "Has plantado una semilla de bienestar hoy 🌻",
                "Tu energía positiva se nota desde aquí ⚡",
                "Completaste algo hermoso para ti mismo 🌈"
            ]
        } else if ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() > 0 {
            return [
                "Cada día que eliges cuidarte construyes algo hermoso 🏗️",
                "Tu constancia es tu superpoder silencioso 💫",
                "Paso a paso, estás creando la mejor versión de ti 🦋",
                "Tu dedicación se nota, sigue escribiendo tu historia 📖",
                "Cada entrenamiento es una carta de amor a tu futuro yo 💌"
            ]
        } else {
            return [
                "Descansar también es entrenar tu constancia 🧘‍♂️",
                "Tu cuerpo sabe cuándo necesita una pausa, escúchalo 🎵",
                "Mañana será otro día para brillar ⭐",
                "A veces el mejor entrenamiento es cuidar tu mente 🌙",
                "No hay prisa, tu bienestar es un viaje, no una carrera 🛤️"
            ]
        }
    }
    
    // MARK: - Quick Action Button Component
    struct huM94mVLDQIylRoMpinZ5UCCdJ8jxiCP: View {
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
    
    // MARK: - Helper Functions
    private func ES0BZT8uITuIRS240cz0GJ4YC02PSyRU() -> Int {
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
}

// MARK: - CloudKit Status Card
struct S5Y9Yc6Ooa6f2NuGIzvEGtIUI7akBoxu: View {
    @State private var syncStatus: hqXuDXGEi3CgVnZUkg0zod2KJVFWdQ5j = .unknown
    @State private var showingAlert = false
    @State private var errorMessage: String?
    @State private var lastSyncDate: Date?
    // @ObservedObject var conflictMonitor = PersistenceController.conflictMonitor // Temporarily disabled
    
    enum hqXuDXGEi3CgVnZUkg0zod2KJVFWdQ5j {
        case unknown, syncing, success, failed
        
        var W5TVRE97oSlHf67bpUXP80LgXeYzET6B: String {
            switch self {
            case .unknown: return "Estado desconocido"
            case .syncing: return "Sincronizando..."
            case .success: return "Sincronización exitosa"
            case .failed: return "Error de sincronización"
            }
        }
        
        var QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color {
            switch self {
            case .unknown: return .gray
            case .syncing: return .orange
            case .success: return .green
            case .failed: return .red
            }
        }
        
        var QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: String {
            switch self {
            case .unknown: return "questionmark.circle"
            case .syncing: return "arrow.triangle.2.circlepath"
            case .success: return "checkmark.circle.fill"
            case .failed: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: syncStatus.QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj)
                    .foregroundColor(syncStatus.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Estado CloudKit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    
                    Text(syncStatus.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)
                        .font(.caption)
                        .foregroundColor(syncStatus.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Button("Test Sync") {
                        UkzrT9BnAMID7iPrFAKmDawtXvBer6Rw()
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    // Show conflict count if any (temporarily disabled)
                    /*
                    if conflictMonitor.conflicts.count > 0 {
                        Text("\(conflictMonitor.conflicts.count) conflictos")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    */
                }
            }
            
            if let lastSync = lastSyncDate {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    
                    Text("Última sync: \(WPhHoE1PLwqQatnfUREd9LegNnFZKRjV(lastSync))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("CloudKit Error", isPresented: $showingAlert) {
            Button("OK") {
                showingAlert = false
            }
        } message: {
            Text(errorMessage ?? "Error desconocido")
        }
        .onAppear {
            UUyTtHVgmHJutTbSbpStz61v1xOt395L()
        }
    }
    
    private func UkzrT9BnAMID7iPrFAKmDawtXvBer6Rw() {
        print("[SYNC] Iniciando test de sincronización CloudKit...")
        syncStatus = .syncing
        
        // Simulate checking CloudKit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Check CloudKit account status
            CKContainer.default().accountStatus { status, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("🔴 CloudKit Error: \(error.localizedDescription)")
                        self.syncStatus = .failed
                        self.errorMessage = error.localizedDescription
                        self.showingAlert = true
                        return
                    }
                    
                    switch status {
                    case .available:
                        print("[OK] CloudKit disponible - datos sincronizados")
                        self.syncStatus = .success
                        self.lastSyncDate = Date()
                    case .noAccount:
                        print("[ERR] No hay cuenta iCloud")
                        self.syncStatus = .failed
                        self.errorMessage = "No hay cuenta iCloud configurada"
                        self.showingAlert = true
                    default:
                        print("[WARN]️ CloudKit no disponible")
                        self.syncStatus = .failed
                        self.errorMessage = "iCloud no está disponible"
                        self.showingAlert = true
                    }
                }
            }
        }
    }
    
    private func UUyTtHVgmHJutTbSbpStz61v1xOt395L() {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                if error != nil {
                    self.syncStatus = .failed
                } else {
                    switch status {
                    case .available:
                        self.syncStatus = .success
                        self.lastSyncDate = Date()
                    case .noAccount:
                        self.syncStatus = .failed
                    default:
                        self.syncStatus = .unknown
                    }
                }
            }
        }
    }
    
    private func WPhHoE1PLwqQatnfUREd9LegNnFZKRjV(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        nGHHMNtoBwM0IFT4HW5NflwlHlDPD5KZ(selectedTab: .constant(0))
    }
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}
