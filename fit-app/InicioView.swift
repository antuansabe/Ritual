import SwiftUI

// MARK: - Reusable Components
struct MetricCardView: View {
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
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                    .accessibilityLabel("\(value) \(label)")
                
                Text(label)
                    .font(AppConstants.Design.footnoteFont)
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
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                .fill(AppConstants.Design.cardBackground())
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                )
        )
        .shadow(color: AppConstants.Design.cardShadow(), radius: AppConstants.UI.shadowRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct TrainingListItem: View {
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
                    .font(AppConstants.Design.bodyFont)
                    .foregroundColor(.white)
                
                Text("\(workout.duration) min • \(workout.calories) kcal")
                    .font(AppConstants.Design.captionFont)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: workout.date ?? Date()))
                .font(AppConstants.Design.captionFont)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, AppConstants.UI.spacingL)
        .padding(.vertical, AppConstants.UI.spacingL)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                .fill(AppConstants.Design.cardBackground())
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                )
        )
        .shadow(color: AppConstants.Design.cardShadow(), radius: AppConstants.UI.shadowRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(workout.type ?? "") workout, \(workout.duration) minutes, \(workout.calories) calories, \(dateFormatter.string(from: workout.date ?? Date()))")
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(AppConstants.Design.primaryButtonGradient)
                        .shadow(color: AppConstants.Design.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel("Add new workout")
        .accessibilityHint("Opens the workout registration form")
    }
}

struct InicioView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    
    @State private var animateOnAppear = false
    @State private var showingRegistro = false
    @State private var showingHistorial = false
    @Namespace private var heroAnimation
    
    // Add TabView selection binding
    @Binding var selectedTab: Int
    
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
                    metricsSection
                    recentWorkoutsSection
                }
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        selectedTab = 1 // Navigate to Registrar tab
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 44)
                }
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
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(AppConstants.User.greeting), \(AppConstants.User.defaultName) \(AppConstants.User.welcomeEmoji)")
                .font(AppConstants.Design.titleFont)
                .foregroundColor(.white)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: animateOnAppear)
            
            Text("¿Qué entrenamiento harás hoy?")
                .font(AppConstants.Design.bodyFont)
                .foregroundColor(.white.opacity(0.8))
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.1), value: animateOnAppear)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Progreso")
                    .font(AppConstants.Design.headerFont)
                    .foregroundColor(.white)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    MetricCardView(
                        icon: "figure.walk.circle.fill",
                        value: "\(workouts.count)",
                        label: "Entrenamientos",
                        tint: .blue
                    )
                    .matchedGeometryEffect(id: "workouts", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "clock.fill",
                        value: "\(workouts.reduce(0) { $0 + Int($1.duration) })",
                        label: "Minutos",
                        tint: .green
                    )
                    .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "flame.fill",
                        value: "\(workouts.reduce(0) { $0 + Int($1.calories) })",
                        label: "Calorías",
                        tint: .orange
                    )
                    .matchedGeometryEffect(id: "calories", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "calendar.circle.fill",
                        value: "\(calculateCurrentStreak())",
                        label: "Racha",
                        tint: .purple
                    )
                    .matchedGeometryEffect(id: "streak", in: heroAnimation)
                }
                .padding(.horizontal, 16)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(x: animateOnAppear ? 0 : -50)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateOnAppear)
        }
    }
    
    // MARK: - Recent Workouts Section
    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Entrenamientos recientes")
                    .font(AppConstants.Design.headerFont)
                    .foregroundColor(.white)
                
                Spacer()
                
                if workouts.count > 3 {
                    Button("Ver historial") {
                        showingHistorial = true
                    }
                    .font(AppConstants.Design.captionFont)
                    .foregroundColor(AppConstants.Design.blue)
                }
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
            
            if !workouts.isEmpty {
                VStack(spacing: 8) {
                    ForEach(Array(workouts.prefix(3).enumerated()), id: \.element.objectID) { index, workout in
                        TrainingListItem(workout: workout)
                            .opacity(animateOnAppear ? 1 : 0)
                            .offset(y: animateOnAppear ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(0.5 + Double(index) * 0.1), value: animateOnAppear)
                    }
                }
                .padding(.horizontal, 16)
            } else {
                emptyStateView
                    .padding(.horizontal, 16)
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
                    .font(AppConstants.Design.headerFont)
                    .foregroundColor(.white)
                
                Text("Registra tu primer entrenamiento para comenzar a ver tu progreso")
                    .font(AppConstants.Design.bodyFont)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button("Empezar ahora") {
                selectedTab = 1 // Navigate to Registrar tab
            }
            .font(AppConstants.Design.bodyFont)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppConstants.Design.primaryButtonGradient)
            )
            .shadow(color: AppConstants.Design.cardShadow(), radius: AppConstants.UI.shadowRadius)
        }
        .padding(.vertical, 60)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Helper Functions
    private func calculateCurrentStreak() -> Int {
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

#Preview {
    NavigationStack {
        InicioView(selectedTab: .constant(0))
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
