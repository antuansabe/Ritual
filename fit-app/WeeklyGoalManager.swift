import SwiftUI
import CoreData
import Combine
import os.log

// MARK: - Weekly Goal Manager
class WeeklyGoalManager: ObservableObject {
    static let shared = WeeklyGoalManager()
    
    @Published var showGoalAchievedPopup = false
    @Published var currentWeeklyGoal: Int = 3
    @Published var workoutsThisWeek: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let calendar = Calendar.current
    
    // Key for tracking when goal was last achieved (week identifier)
    private let lastGoalAchievedWeekKey = "lastGoalAchievedWeek"
    
    private init() {
        // Load current weekly goal from UserDefaults
        loadWeeklyGoal()
        
        // Listen for weekly goal changes
        NotificationCenter.default.publisher(for: .weeklyGoalChanged)
            .sink { [weak self] notification in
                if let newGoal = notification.object as? Int {
                    self?.currentWeeklyGoal = newGoal
                }
            }
            .store(in: &cancellables)
        
        // Listen for workout saves
        NotificationCenter.default.publisher(for: .workoutSaved)
            .sink { [weak self] notification in
                self?.handleWorkoutSaved()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    private func handleWorkoutSaved() {
        // Fetch current workouts from Core Data
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        
        do {
            let workouts = try context.fetch(request)
            checkWorkoutCompleted(workouts: workouts)
        } catch {
            #if DEBUG
            Logger.general.debug("Error fetching workouts for goal check: \(error)")
            #endif
        }
    }
    
    func checkWorkoutCompleted(workouts: [WorkoutEntity]) {
        let newWorkoutCount = calculateWorkoutsThisWeek(workouts: workouts)
        let previousCount = workoutsThisWeek
        workoutsThisWeek = newWorkoutCount
        
        // Check if goal was just achieved
        if newWorkoutCount >= currentWeeklyGoal && 
           previousCount < currentWeeklyGoal && 
           !hasShownGoalThisWeek() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showGoalAchievedPopup = true
                self.markGoalShownThisWeek()
            }
        }
    }
    
    func updateWorkoutCount(workouts: [WorkoutEntity]) {
        workoutsThisWeek = calculateWorkoutsThisWeek(workouts: workouts)
    }
    
    func dismissGoalPopup() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showGoalAchievedPopup = false
        }
    }
    
    // MARK: - Private Methods
    
    private func loadWeeklyGoal() {
        let storedGoal = UserDefaults.standard.integer(forKey: "weeklyGoal")
        currentWeeklyGoal = storedGoal == 0 ? 3 : storedGoal
    }
    
    private func calculateWorkoutsThisWeek(workouts: [WorkoutEntity]) -> Int {
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    private func getCurrentWeekIdentifier() -> String {
        let today = Date()
        let year = calendar.component(.yearForWeekOfYear, from: today)
        let week = calendar.component(.weekOfYear, from: today)
        return "\(year)-W\(week)"
    }
    
    private func hasShownGoalThisWeek() -> Bool {
        let currentWeek = getCurrentWeekIdentifier()
        let lastShownWeek = UserDefaults.standard.string(forKey: lastGoalAchievedWeekKey)
        return currentWeek == lastShownWeek
    }
    
    private func markGoalShownThisWeek() {
        let currentWeek = getCurrentWeekIdentifier()
        UserDefaults.standard.set(currentWeek, forKey: lastGoalAchievedWeekKey)
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let weeklyGoalChanged = Notification.Name("weeklyGoalChanged")
    static let workoutSaved = Notification.Name("workoutSaved")
}

// MARK: - Global Goal Achievement Popup
struct GlobalGoalAchievementOverlay: View {
    @EnvironmentObject var goalManager: WeeklyGoalManager
    @State private var animateContent = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            if goalManager.showGoalAchievedPopup {
                // Background overlay
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .opacity(animateBackground ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: animateBackground)
                    .onTapGesture {
                        goalManager.dismissGoalPopup()
                    }
                
                // Achievement popup
                GoalAchievementPopupContent()
                    .scaleEffect(animateContent ? 1.0 : 0.3)
                    .opacity(animateContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)
            }
        }
        .onChange(of: goalManager.showGoalAchievedPopup) { isShowing in
            if isShowing {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animateBackground = true
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateContent = true
                }
                
                // Auto-dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    goalManager.dismissGoalPopup()
                }
            } else {
                animateContent = false
                animateBackground = false
            }
        }
    }
}

// MARK: - Goal Achievement Popup Content
struct GoalAchievementPopupContent: View {
    @EnvironmentObject var goalManager: WeeklyGoalManager
    @State private var sparkleAnimation = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Achievement icon with sparkle effect
            ZStack {
                // Outer glow ring
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow.opacity(0.4), .orange.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 0.8)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                
                // Main achievement circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: .yellow.opacity(0.4), radius: 12, x: 0, y: 6)
                
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(sparkleAnimation ? 10 : -10))
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: sparkleAnimation)
                
                // Sparkle effects
                ForEach(0..<6, id: \.self) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.yellow)
                        .offset(
                            x: cos(Double(index) * .pi / 3) * 70,
                            y: sin(Double(index) * .pi / 3) * 70
                        )
                        .opacity(sparkleAnimation ? 1 : 0.3)
                        .scaleEffect(sparkleAnimation ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: sparkleAnimation)
                }
            }
            
            // Achievement text
            VStack(spacing: 12) {
                Text("¡Meta Semanal Alcanzada!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("¡Felicidades! Has completado \(goalManager.currentWeeklyGoal) entrenamientos esta semana")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Progress indicator
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.green)
                    
                    Text("\(goalManager.workoutsThisWeek)/\(goalManager.currentWeeklyGoal) entrenamientos")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.green.opacity(0.4), lineWidth: 1)
                        )
                )
            }
            
            // Motivational message
            VStack(spacing: 8) {
                Text("[U+1F31F] Tu constancia es inspiradora [U+1F31F]")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.yellow)
                
                Text("Cada entrenamiento te acerca más a tus objetivos")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            // Dismiss button
            Button(action: {
                goalManager.dismissGoalPopup()
            }) {
                Text("¡Genial!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [AppConstants.Design.electricBlue, AppConstants.Design.softPurple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: AppConstants.Design.electricBlue.opacity(0.4), radius: 8, x: 0, y: 4)
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 32)
        .onAppear {
            sparkleAnimation = true
            pulseAnimation = true
        }
    }
}