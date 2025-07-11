import SwiftUI
import CoreData

struct Xj3WJQIjdqYVZ7GRqNsGGOF8t6wx845J: View {
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    
    @State private var weeklyGoal: Int = UserDefaults.standard.integer(forKey: "weeklyGoal") == 0 ? 3 : UserDefaults.standard.integer(forKey: "weeklyGoal")
    @State private var animateOnAppear = false
    @State private var showSuccessAnimation = false
    @State private var savedGoal = false
    
    private let calendar = Calendar.current
    
    // Calculate workouts for current week
    private var workoutsThisWeek: Int {
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    // Calculate progress percentage
    private var progressPercentage: Double {
        guard weeklyGoal > 0 else { return 0 }
        return min(Double(workoutsThisWeek) / Double(weeklyGoal), 1.0)
    }
    
    // Check if goal is completed
    private var isGoalCompleted: Bool {
        workoutsThisWeek >= weeklyGoal
    }
    
    var body: some View {
        ZStack {
            // Background
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
                    goalSelectionSection
                    progressSection
                    motivationalSection
                    saveButtonSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .overlay {
            if showSuccessAnimation {
                JYG4Zkb3ba6hcnjtBVfs2KQZFTjUki2q()
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Navigation
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Atrás")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial.opacity(0.7))
                    )
                }
                
                Spacer()
            }
            
            // Title Section
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "target")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("Meta Semanal")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Configura cuántos entrenamientos quieres realizar por semana")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -30)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Goal Selection Section
    private var goalSelectionSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Selecciona tu meta")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 20) {
                // Large display of selected goal
                VStack(spacing: 12) {
                    Text("\(weeklyGoal)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Text(weeklyGoal == 1 ? "entrenamiento por semana" : "entrenamientos por semana")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 32)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), lineWidth: 2)
                        )
                )
                
                // Goal selection grid
                VStack(spacing: 24) {
                    Text("Toca para seleccionar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(1...6, id: \.self) { goal in
                            wp3MVpi2FPti7HpLzk3imnmHuYR0APUo(
                                goal: goal,
                                isSelected: weeklyGoal == goal,
                                action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        weeklyGoal = goal
                                    }
                                }
                            )
                        }
                    }
                    
                    // Centered button for goal 7
                    HStack {
                        Spacer()
                        wp3MVpi2FPti7HpLzk3imnmHuYR0APUo(
                            goal: 7,
                            isSelected: weeklyGoal == 7,
                            action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    weeklyGoal = 7
                                }
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Progreso esta semana")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 20) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 12)
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .trim(from: 0, to: progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: isGoalCompleted ? 
                                    [.green, .blue] : 
                                    [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.0, dampingFraction: 0.8), value: progressPercentage)
                    
                    VStack(spacing: 4) {
                        Text("\(workoutsThisWeek)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("de \(weeklyGoal)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Progress text
                VStack(spacing: 8) {
                    HStack {
                        Text("Llevas \(workoutsThisWeek)/\(weeklyGoal) entrenamientos esta semana")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        if isGoalCompleted {
                            Text("✅")
                                .font(.system(size: 18))
                        }
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: isGoalCompleted ? 
                                            [.green, .blue] : 
                                            [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progressPercentage, height: 8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progressPercentage)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Motivational Section
    private var motivationalSection: some View {
        VStack(spacing: 16) {
            if isGoalCompleted {
                // Goal completed message
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                        
                        Text("¡Meta completada!")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                    }
                    
                    Text("¡Increíble trabajo! Has alcanzado tu meta semanal. Tu constancia es inspiradora. 🌟")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.green.opacity(0.3), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.green.opacity(0.4), lineWidth: 2)
                        )
                )
            } else {
                // Motivational message
                let remaining = weeklyGoal - workoutsThisWeek
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.pink)
                        
                        Text("¡Sigue así!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Text(remaining == 1 ? 
                        "Solo te falta 1 entrenamiento más para completar tu meta semanal. ¡Tú puedes! 💪" :
                        "Te faltan \(remaining) entrenamientos para completar tu meta. Cada paso cuenta hacia tu bienestar. 🌱"
                    )
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Save Button Section
    private var saveButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: cS3qZBSANJAGCoRhkH1IxMGYPNjMMlMz) {
                HStack(spacing: 12) {
                    if savedGoal {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "target")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(savedGoal ? "Meta guardada" : "Guardar meta")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(savedGoal ? 
                            LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing) :
                            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.BRZumEEKLDNhpWlIssXSSHs7tRJDkiWk
                        )
                )
                .shadow(color: savedGoal ? .green.opacity(0.4) : pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr.opacity(0.4), 
                       radius: 10, x: 0, y: 5)
                .scaleEffect(savedGoal ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: savedGoal)
            }
            
            Text("Tu meta se guardará y podrás ver tu progreso en el perfil")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateOnAppear)
    }
    
    // MARK: - Functions
    private func cS3qZBSANJAGCoRhkH1IxMGYPNjMMlMz() {
        // Validate weekly goal range (1-7 workouts per week is reasonable)
        let validatedGoal = max(1, min(weeklyGoal, 7))
        
        // Update the state if validation changed the value
        if validatedGoal != weeklyGoal {
            weeklyGoal = validatedGoal
        }
        
        UserDefaults.standard.set(validatedGoal, forKey: "weeklyGoal")
        
        // Notify WeeklyGoalManager about the goal change
        NotificationCenter.default.post(name: .PNqxq0lAjFsRRnIb7XoCcURRETBAHPqh, object: weeklyGoal)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            savedGoal = true
        }
        
        if isGoalCompleted {
            withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                showSuccessAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSuccessAnimation = false
                }
            }
        }
        
        // Reset saved state after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                savedGoal = false
            }
        }
    }
}

// MARK: - Success Overlay View
struct JYG4Zkb3ba6hcnjtBVfs2KQZFTjUki2q: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(animate ? 1.0 : 0.5)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                VStack(spacing: 12) {
                    Text("¡Meta Alcanzada!")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Has completado tu meta semanal")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.green.opacity(0.5), lineWidth: 2)
                    )
            )
            .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animate = true
            }
        }
    }
}

// MARK: - Goal Selection Button Component
struct wp3MVpi2FPti7HpLzk3imnmHuYR0APUo: View {
    let goal: Int
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    // Outer glow effect for selected state
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .blur(radius: 8)
                    }
                    
                    // Main button circle
                    Circle()
                        .fill(
                            isSelected ? 
                                LinearGradient(
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? 
                                        LinearGradient(
                                            colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.6), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.4)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.25), Color.white.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                    lineWidth: isSelected ? 3 : 2
                                )
                        )
                        .shadow(
                            color: isSelected ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4) : .black.opacity(0.15),
                            radius: isSelected ? 12 : 6,
                            x: 0,
                            y: isSelected ? 6 : 3
                        )
                    
                    // Goal number
                    Text("\(goal)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                        .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 0.5)
                }
                
                // Goal label
                Text(goal == 1 ? "vez" : "veces")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .shadow(color: isSelected ? .black.opacity(0.2) : .clear, radius: 1, x: 0, y: 0.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel("\(goal) \(goal == 1 ? "entrenamiento" : "entrenamientos") por semana")
        .accessibilityHint("Toca para seleccionar esta meta semanal")
        .accessibilityValue(isSelected ? "Seleccionado" : "No seleccionado")
    }
}

#Preview {
    NavigationStack {
        Xj3WJQIjdqYVZ7GRqNsGGOF8t6wx845J()
    }
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}