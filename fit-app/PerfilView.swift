import SwiftUI
import CoreData
import CloudKit

struct PerfilView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userProfileManager: UserProfileManager
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @StateObject private var motivationalManager = MotivationalMessageManager()
    
    @State private var showingCloudKitTest = false
    @State private var showingCloudKitConflicts = false
    @State private var showingWeeklyGoal = false
    @State private var showingLogoutConfirmation = false
    
    // Name editing states
    @State private var isEditingName = false
    @State private var editingName = ""
    @State private var showingNameUpdatedMessage = false
    
    private var weeklyGoal: Int {
        let defaultGoal = UserDefaults.standard.integer(forKey: "weeklyGoal")
        return defaultGoal == 0 ? 3 : defaultGoal
    }
    
    private var currentUserName: String {
        if !userProfileManager.displayName.isEmpty && userProfileManager.displayName != "Atleta" {
            return userProfileManager.displayName
        }
        return UserDefaults.standard.string(forKey: "userName") ?? "Usuario"
    }
    
    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header with gradient background
                headerSection
                
                // Main content
                VStack(spacing: 32) {
                    // Motivational message
                    motivationalSection
                    
                    // Network status
                    networkStatusSection
                    
                    // Quick stats
                    statsSection
                    
                    // Weekly progress
                    weeklyProgressSection
                    
                    // Recent activity summary
                    recentActivitySection
                    
                    // Achievements
                    achievementsSection
                    
                    // Settings section with logout
                    settingsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 100)
            }
        }
        .background(
            ZStack {
                Image("profileBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [Color.black.opacity(0.7), Color(.systemGray6).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        )
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCloudKitTest) {
            SimpleCloudKitTestView()
        }
        .sheet(isPresented: $showingCloudKitConflicts) {
            // CloudKitConflictView() // Temporarily disabled
            Text("CloudKit Monitor en desarrollo")
                .navigationTitle("CloudKit Monitor")
        }
        .sheet(isPresented: $showingWeeklyGoal) {
            WeeklyGoalView()
        }
        .alert("Cerrar sesión", isPresented: $showingLogoutConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
        .overlay(
            // Name updated success message
            Group {
                if showingNameUpdatedMessage {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.green)
                            
                            Text("Nombre actualizado")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.green.opacity(0.6), lineWidth: 1.5)
                                )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
        )
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)
            
            VStack(spacing: 16) {
                Spacer()
                
                // Profile picture
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                // User info with editable name
                VStack(spacing: 8) {
                    if isEditingName {
                        nameEditingView
                    } else {
                        nameDisplayView
                    }
                    
                    Text("Miembro desde Enero 2024")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Estadísticas")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "figure.walk.circle.fill",
                    value: "\(workouts.count)",
                    label: "Entrenamientos",
                    color: .blue,
                    accentColor: .blue.opacity(0.2)
                )
                
                StatCard(
                    icon: "clock.fill",
                    value: "\(workouts.reduce(0) { $0 + Int($1.duration) })",
                    label: "Minutos",
                    color: .green,
                    accentColor: .green.opacity(0.2)
                )
                
                StatCard(
                    icon: "flame.fill",
                    value: "\(workouts.reduce(0) { $0 + Int($1.calories) })",
                    label: "Calorías",
                    color: .orange,
                    accentColor: .orange.opacity(0.2)
                )
            }
        }
    }
    
    // MARK: - Weekly Progress Section
    private var weeklyProgressSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Meta Semanal")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(workoutsThisWeek) / CGFloat(weeklyGoal), 1.0))
                        .stroke(
                            LinearGradient(
                                colors: workoutsThisWeek >= weeklyGoal ? [.green, .blue] : [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: workoutsThisWeek)
                    
                    VStack(spacing: 4) {
                        Text("\(workoutsThisWeek)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("de \(weeklyGoal)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Entrena \(weeklyGoal) \(weeklyGoal == 1 ? "vez" : "veces") esta semana")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    if workoutsThisWeek >= weeklyGoal {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("¡Meta completada!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(20)
                    } else {
                        let remaining = weeklyGoal - workoutsThisWeek
                        HStack(spacing: 8) {
                            Image(systemName: "target")
                                .foregroundColor(.blue)
                            Text("Faltan \(remaining) \(remaining == 1 ? "entrenamiento" : "entrenamientos")")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
                
                // Change Goal Button
                Button(action: {
                    showingWeeklyGoal = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppConstants.Design.electricBlue)
                        
                        Text("Cambiar meta semanal")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppConstants.Design.electricBlue.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: AppConstants.Design.electricBlue.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.2), value: showingWeeklyGoal)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Actividad Reciente")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Tus últimos entrenamientos")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                NavigationLink(destination: HistorialView()) {
                    HStack(spacing: 6) {
                        Text("Ver todo")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 16) {
                if workouts.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "figure.walk.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("Aún no hay entrenamientos")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Registra tu primer entrenamiento para empezar a ver tu progreso")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.vertical, 40)
                } else {
                    // Recent workouts summary
                    let recentWorkouts = Array(workouts.prefix(3))
                    
                    VStack(spacing: 12) {
                        ForEach(recentWorkouts, id: \.id) { workout in
                            RecentWorkoutRow(workout: workout)
                        }
                    }
                    
                    if workouts.count > 3 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                        
                        HStack {
                            Text("Y \(workouts.count - 3) entrenamientos más")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Logros")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("\(achievements.count) desbloqueados")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(achievements, id: \.id) { achievement in
                    ModernAchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Configuración")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // CloudKit Test Button
                Button(action: {
                    showingCloudKitTest = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "icloud.and.arrow.up.and.arrow.down")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Text("Test CloudKit")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // CloudKit Conflict Monitor Button
                Button(action: {
                    showingCloudKitConflicts = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                        
                        Text("Monitor CloudKit")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.orange)
                        
                        Spacer()
                        
                        // Show conflict count if any (temporarily disabled)
                        /*
                        if PersistenceController.conflictMonitor.conflicts.count > 0 {
                            Text("\(PersistenceController.conflictMonitor.conflicts.count)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        */
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // Reset Welcome Button (for testing)
                Button(action: {
                    authViewModel.resetWelcomeFlag()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.yellow)
                        
                        Text("Reset Welcome (Test)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.yellow)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.yellow.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // Logout Button using reusable component
                SignOutButton(style: .card)
            }
        }
    }
    
    // MARK: - Motivational Section
    private var motivationalSection: some View {
        let workoutArray = Array(workouts)
        let daysSinceLastWorkout = motivationalManager.calculateDaysSinceLastWorkout(workouts: workoutArray)
        let currentStreak = motivationalManager.calculateCurrentStreak(workouts: workoutArray)
        let message = motivationalManager.getMessage(for: .profile, daysSinceLastWorkout: daysSinceLastWorkout, currentStreak: currentStreak)
        
        return MotivationalCardView(message: message, style: .prominent)
    }
    
    // MARK: - Network Status Section
    private var networkStatusSection: some View {
        NetworkStatusCard()
    }
    
    // MARK: - Helper Functions
    
    private var achievements: [Achievement] {
        [
            Achievement(id: 1, title: "Primer Paso", description: "Completa tu primer entrenamiento", icon: "star.fill", color: .yellow, isUnlocked: workouts.count > 0),
            Achievement(id: 2, title: "Constancia", description: "5 días seguidos entrenando", icon: "flame.fill", color: .orange, isUnlocked: calculateCurrentStreak() >= 5),
            Achievement(id: 3, title: "Meta Semanal", description: "Completa tu meta semanal", icon: "target", color: .blue, isUnlocked: workoutsThisWeek >= weeklyGoal),
            Achievement(id: 4, title: "Disciplinado", description: "10 entrenamientos completados", icon: "figure.walk", color: .green, isUnlocked: workouts.count >= 10)
        ]
    }
    
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
    
    // MARK: - Name Editing Views
    
    private var nameDisplayView: some View {
        HStack(spacing: 12) {
            Text(currentUserName)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            Button(action: {
                editingName = currentUserName
                withAnimation(.easeInOut(duration: 0.3)) {
                    isEditingName = true
                }
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            .accessibilityLabel("Editar nombre")
            .accessibilityHint("Toca para editar tu nombre de usuario")
        }
    }
    
    private var nameEditingView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Tu nombre", text: $editingName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .onSubmit {
                        saveNameChange()
                    }
            }
            
            HStack(spacing: 16) {
                // Cancel button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isEditingName = false
                        editingName = ""
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Cancelar")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.red.opacity(0.5), lineWidth: 1)
                            )
                    )
                }
                
                // Save button
                Button(action: {
                    saveNameChange()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Guardar")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.blue.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.green.opacity(0.5), lineWidth: 1)
                            )
                    )
                    .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .disabled(editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || editingName.count > 30)
                .opacity(editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || editingName.count > 30 ? 0.6 : 1.0)
            }
            
            // Character limit indicator
            if editingName.count > 25 {
                Text("\(editingName.count)/30 caracteres")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(editingName.count > 30 ? .red : .white.opacity(0.7))
            }
        }
    }
    
    // MARK: - Name Editing Actions
    
    private func saveNameChange() {
        let trimmedName = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation
        guard !trimmedName.isEmpty else {
            return
        }
        
        guard trimmedName.count <= 30 else {
            return
        }
        
        // Update UserProfileManager
        userProfileManager.updateDisplayName(trimmedName)
        
        // Also update UserDefaults for backwards compatibility
        UserDefaults.standard.set(trimmedName, forKey: "userName")
        
        // Exit editing mode with animation
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditingName = false
            editingName = ""
        }
        
        // Show success message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingNameUpdatedMessage = true
        }
        
        // Hide success message after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingNameUpdatedMessage = false
            }
        }
        
        print("✅ User name updated to: \(trimmedName)")
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: AppConstants.UI.spacingM) {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 60, height: 60)
                    .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: AppConstants.UI.spacingXS) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppConstants.UI.spacingL)
        .padding(.horizontal, AppConstants.UI.spacingM)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}


struct ModernAchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(achievement.isUnlocked ? 0.05 : 0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.isUnlocked ? achievement.color.opacity(0.3) : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

struct RecentWorkoutRow: View {
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
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(workoutColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: workoutIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(workoutColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(workout.type ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: workout.date ?? Date()))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text("\(workout.duration) min • \(workout.calories) kcal")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Data Models

struct Achievement {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

// MARK: - Simple CloudKit Test View
struct SimpleCloudKitTestView: View {
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var testResults: [String] = []
    @State private var isRunningTest = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    workoutDataSection
                    testActionsSection
                    testResultsSection
                }
                .padding()
            }
            .navigationTitle("CloudKit Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            addTestResult("📱 Vista de testing CloudKit iniciada")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "icloud.and.arrow.up.and.arrow.down")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("CloudKit Sync Test")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Prueba la sincronización de datos con iCloud")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    private var workoutDataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Datos Locales (\(workouts.count) entrenamientos)")
                .font(.headline)
                .fontWeight(.semibold)
            
            if workouts.isEmpty {
                Text("No hay entrenamientos guardados")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(workouts.prefix(5).enumerated()), id: \.element.objectID) { index, workout in
                        HStack {
                            Text("\(index + 1).")
                                .fontWeight(.medium)
                                .frame(width: 20, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(workout.type ?? "Unknown")
                                    .fontWeight(.medium)
                                
                                Text("\(workout.duration) min • \(workout.calories) kcal")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(formatDate(workout.date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var testActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Acciones de Testing")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                testButton(
                    title: "Verificar Cuenta iCloud",
                    icon: "person.icloud",
                    action: testCloudKitAccount
                )
                
                testButton(
                    title: "Crear Entrenamiento de Prueba",
                    icon: "plus.circle",
                    action: createTestWorkout
                )
                
                testButton(
                    title: "Limpiar Logs",
                    icon: "trash",
                    action: clearTestResults
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var testResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Logs de Testing")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(testResults.enumerated()), id: \.offset) { index, result in
                        Text(result)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(12)
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private func testButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(title)
                Spacer()
                if isRunningTest {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .disabled(isRunningTest)
    }
    
    private func testCloudKitAccount() {
        isRunningTest = true
        addTestResult("🔍 Verificando cuenta iCloud...")
        
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                self.isRunningTest = false
                
                if let error = error {
                    self.addTestResult("❌ Error: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .available:
                    self.addTestResult("✅ Cuenta iCloud disponible")
                    self.addTestResult("📊 Entrenamientos locales: \(self.workouts.count)")
                case .noAccount:
                    self.addTestResult("❌ No hay cuenta iCloud configurada")
                case .restricted:
                    self.addTestResult("❌ Cuenta iCloud restringida")
                case .couldNotDetermine:
                    self.addTestResult("❌ No se pudo determinar estado iCloud")
                case .temporarilyUnavailable:
                    self.addTestResult("⚠️ iCloud temporalmente no disponible")
                @unknown default:
                    self.addTestResult("❓ Estado iCloud desconocido")
                }
            }
        }
    }
    
    private func createTestWorkout() {
        isRunningTest = true
        addTestResult("🏋️‍♂️ Creando entrenamiento de prueba...")
        
        let context = managedObjectContext
        let testWorkout = WorkoutEntity(context: context)
        testWorkout.id = UUID()
        testWorkout.type = "Test CloudKit"
        testWorkout.duration = Int32.random(in: 15...60)
        testWorkout.date = Date()
        testWorkout.calories = Int32(testWorkout.duration * 8)
        
        do {
            try context.save()
            addTestResult("✅ Entrenamiento de prueba creado")
            addTestResult("📤 Sincronización CloudKit iniciada automáticamente")
            print("🏃‍♂️ Nuevo entrenamiento Test CloudKit guardado - iniciando sincronización CloudKit")
            print("📊 Tipo: Test CloudKit, Duración: \(testWorkout.duration) min")
            isRunningTest = false
        } catch {
            addTestResult("❌ Error al crear entrenamiento: \(error.localizedDescription)")
            isRunningTest = false
        }
    }
    
    private func clearTestResults() {
        testResults.removeAll()
        addTestResult("🧹 Logs limpiados")
    }
    
    private func addTestResult(_ message: String) {
        let timestamp = DateFormatter.testTimeFormatter.string(from: Date())
        testResults.append("[\(timestamp)] \(message)")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static let testTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    NavigationStack {
        PerfilView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(AuthViewModel())
}