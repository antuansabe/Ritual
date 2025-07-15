import SwiftUI
import CoreData
import CloudKit
import os.log

struct q29ClCI2LABu3hQnTLcu6EAO6vHtllJW: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @EnvironmentObject var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    @StateObject private var motivationalManager = XiotqQDHiBDxqWDO0uwhKXZcSWBnijF5()
    @StateObject private var achievementManager = AchievementManager.shared
    
    @State private var showingCloudKitTest = false
    @State private var showingCloudKitConflicts = false
    @State private var showingWeeklyGoal = false
    @State private var showingLogoutConfirmation = false
    @State private var showingDeleteAccountConfirmation = false
    @State private var isDeletingAccount = false
    @State private var showingAccountDeletedMessage = false
    
    // Name editing states
    @State private var isEditingName = false
    @State private var editingName = ""
    @State private var nameError: String? = nil
    
    private let validator = VknfqtmwStiiWr4ox76LjSmWY9bPAg8Z.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @State private var showingNameUpdatedMessage = false
    
    private var weeklyGoal: Int {
        let defaultGoal = UserDefaults.standard.integer(forKey: "weeklyGoal")
        return defaultGoal == 0 ? 3 : defaultGoal
    }
    
    private var currentUserName: String {
        if !userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.isEmpty && userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 != "Atleta" {
            return userProfileManager.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8
        }
        // Get from SecureStorage only
        if let secureUserName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) {
            return secureUserName
        }
        return "Usuario"
    }
    
    private var memberSinceText: String {
        let authService = wnGKnVVY25VSc4eWkvgZ2MLHXV6csLz2.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
        
        guard let registrationDate = authService.getUserRegistrationDate() else {
            return "Miembro desde 2025"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        
        return "Miembro desde \(formatter.string(from: registrationDate))"
    }
    
    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let today = Date()
        
        return workouts.filter { workout in
            calendar.isDate(workout.date ?? Date(), equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    var body: some View {
        ReusableBackgroundView {
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
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCloudKitTest) {
            PkzOiTS3hyl3qrAITSwTANM7qA0J5n4Q()
        }
        .sheet(isPresented: $showingCloudKitConflicts) {
            // CloudKitConflictView() // Temporarily disabled
            Text("CloudKit Monitor en desarrollo")
                .navigationTitle("CloudKit Monitor")
        }
        .sheet(isPresented: $showingWeeklyGoal) {
            Xj3WJQIjdqYVZ7GRqNsGGOF8t6wx845J()
        }
        .customAlert(
            title: "Cerrar sesión",
            message: "¿Estás seguro de que quieres cerrar sesión?",
            primaryButton: AlertButton(
                title: "Cerrar sesión",
                icon: "rectangle.portrait.and.arrow.right",
                style: .destructive,
                action: {
                    authViewModel.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
                }
            ),
            secondaryButton: AlertButton(
                title: "Cancelar",
                style: .cancel,
                action: {}
            ),
            isPresented: $showingLogoutConfirmation
        )
        .customAlert(
            title: "Eliminar cuenta",
            message: "Esta acción es irreversible. Se eliminarán todos tus datos y entrenamientos permanentemente.",
            primaryButton: AlertButton(
                title: "Eliminar",
                icon: "trash",
                style: .destructive,
                action: {
                    Task {
                        await deleteUserAccount()
                    }
                }
            ),
            secondaryButton: AlertButton(
                title: "Cancelar",
                style: .cancel,
                action: {}
            ),
            isPresented: $showingDeleteAccountConfirmation
        )
        .overlay(
            // Success messages
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
                } else if showingAccountDeletedMessage {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.green)
                            
                            Text("Cuenta eliminada")
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
                    
                    Text(memberSinceText)
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
                Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                    icon: "figure.walk.circle.fill",
                    value: "\(workouts.count)",
                    label: "Entrenamientos",
                    color: .blue,
                    accentColor: .blue.opacity(0.2)
                )
                
                Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
                    icon: "clock.fill",
                    value: "\(workouts.reduce(0) { $0 + Int($1.duration) })",
                    label: "Minutos",
                    color: .green,
                    accentColor: .green.opacity(0.2)
                )
                
                Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1(
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
                            .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT)
                        
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
                                    .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.2), radius: 6, x: 0, y: 3)
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
                            fM0AZDH6Yec2hzQWdXDePaBvu63dLdVu(workout: workout)
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
                    Text("\(achievementManager.unlockedCount()) desbloqueados")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(achievementManager.achievements, id: \.id) { achievement in
                    AchievementCardView(achievement: achievement)
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
                    authViewModel.ztuC6ouObpK3d02zNnL26mSYTqqAWYcM()
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
                fdsNnzsNuc4ubtpYpSbsrJfmPuz1AmGM(style: .card)
                
                // Delete Account Button (App Store requirement 5.1.1 v)
                Button(action: {
                    showingDeleteAccountConfirmation = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.red)
                        
                        Text("Eliminar cuenta y datos")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        if isDeletingAccount {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.red)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .disabled(isDeletingAccount)
            }
        }
    }
    
    // MARK: - Motivational Section
    private var motivationalSection: some View {
        let workoutArray = Array(workouts)
        let daysSinceLastWorkout = motivationalManager.XpXjs2s0i38zzDWZ3PBpGos6nHfcnQ9A(workouts: workoutArray)
        let currentStreak = motivationalManager.ES0BZT8uITuIRS240cz0GJ4YC02PSyRU(workouts: workoutArray)
        let message = motivationalManager.Ybk5XOhw1M7TunRE3Dn538FHOpTonv3u(for: .NIJGfl8FprvAwRkQeEKJnzDz3BsWlUb1, daysSinceLastWorkout: daysSinceLastWorkout, currentStreak: currentStreak)
        
        return F86UW67ccAWVKtMzac7t2afh26jfxsLy(message: message, style: .prominent)
    }
    
    // MARK: - Network Status Section
    private var networkStatusSection: some View {
        kpzgruBC1Plnfc1qqU6PbDLy9aJwEMTS()
    }
    
    // MARK: - Helper Functions
    
    // Legacy achievements removed - now using AchievementManager
    
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
                                    .stroke(
                                        nameError != nil ? Color.red.opacity(0.8) : Color.white.opacity(0.4), 
                                        lineWidth: nameError != nil ? 2 : 1.5
                                    )
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .onChange(of: editingName) { _ in
                        ycDqjzbaCRg5L1YpaodzGsvd17YjtTKN()
                    }
                    .onSubmit {
                        lCnkV0T45rorjsNFEjlYtQLAF58nRYcs()
                    }
            }
            
            // Name error message
            if let nameError = nameError {
                Text(nameError)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red.opacity(0.9))
                    .padding(.horizontal, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
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
                    lCnkV0T45rorjsNFEjlYtQLAF58nRYcs()
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
    
    private func ycDqjzbaCRg5L1YpaodzGsvd17YjtTKN() {
        let result = validator.GukvlHdwqqo9fBJgWjzJJvFe5OMUEOjg(editingName)
        withAnimation(.easeInOut(duration: 0.3)) {
            nameError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func lCnkV0T45rorjsNFEjlYtQLAF58nRYcs() {
        // Validate first
        let validationResult = validator.GukvlHdwqqo9fBJgWjzJJvFe5OMUEOjg(editingName)
        guard validationResult.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP else {
            nameError = validationResult.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
            return
        }
        // Sanitize the input
        let sanitizedName = validator.S1FcBW204dzhY83hyyJGO8udFCyY9l66(editingName)
        
        // Clear any existing error
        nameError = nil
        
        // Update UserProfileManager
        userProfileManager.wFHSixC97l4MCTtHzG1HCsCLxkuaU2Tl(sanitizedName)
        
        // Store securely in Keychain
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(sanitizedName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        // UserDefaults removed - using SecureStorage only for security
        
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
        
        print("[OK] User name updated to: \(sanitizedName)")
    }
    
    // MARK: - Account Deletion
    
    /// Deletes user account and all associated data
    /// Implements App Store requirement 5.1.1 v for account deletion
    @MainActor
    private func deleteUserAccount() async {
        isDeletingAccount = true
        
        do {
            // Get current user ID for deletion
            let userID = authViewModel.currentUserID.isEmpty ? authViewModel.currentUserEmail : authViewModel.currentUserID
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.warning("🗑️ User initiated account deletion for Apple ID: \(userID)")
            #endif
            
            // Step 1: Clear Apple Sign In authentication data from Keychain
            await authViewModel.clearAuthenticationData()
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple Sign In data cleared from Keychain")
            #endif
            
            // Step 2: Clear all Core Data and CloudKit data
            try GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.clearAllData()
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Core Data and CloudKit data cleared")
            #endif
            
            // Step 3: Clear user profile data
            userProfileManager.clearUserProfile()
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ User profile cleared")
            #endif
            
            // Step 4: Clear UserDefaults (goals, preferences, etc.)
            clearAllUserDefaults()
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ UserDefaults cleared")
            #endif
            
            // Step 5: Log successful deletion
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.warning("✅ Account deletion completed - all local data cleared")
            #endif
            
            // Step 6: Show success message and sign out
            isDeletingAccount = false
            showingAccountDeletedMessage = true
            
            // Auto-hide success message after 3 seconds and sign out
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showingAccountDeletedMessage = false
                authViewModel.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
            }
            
        } catch {
            await handleDeletionError(error)
        }
    }
    
    /// Handles deletion errors with user feedback
    private func handleDeletionError(_ error: Error) async {
        isDeletingAccount = false
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.error("🗑️ ❌ Account deletion failed: \(error.localizedDescription)")
        #endif
        
        // Show error to user (you might want to add an error state here)
        // For now, we'll just log the error - in a production app you'd show an alert
        print("Error deleting account: \(error.localizedDescription)")
    }
    
    /// Clears all user preferences and settings from UserDefaults
    private func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        
        // Clear fitness-related preferences
        defaults.removeObject(forKey: "weeklyGoal")
        defaults.removeObject(forKey: "hasSeenWelcome")
        defaults.removeObject(forKey: "hasShownWelcome")
        defaults.removeObject(forKey: "userPreferredName")
        defaults.removeObject(forKey: "lastWorkoutDate")
        defaults.removeObject(forKey: "totalWorkouts")
        defaults.removeObject(forKey: "preferredWorkoutTime")
        defaults.removeObject(forKey: "notificationsEnabled")
        
        // Clear any other app-specific keys
        defaults.removeObject(forKey: "appFirstLaunch")
        defaults.removeObject(forKey: "onboardingCompleted")
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🗑️ UserDefaults cleared")
        #endif
    }
}

// MARK: - Supporting Views

struct Y3kSrLJTjGyFcVLD2gLfj1iTmlK5Cvm1: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX) {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 60, height: 60)
                    .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.GPTIMVzXVhYLFkeR151yq7JxB8fmAAgB) {
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
        .padding(.vertical, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.cLCfL2nwBEWw5KG2ecDz3CrS4DrWXUHX)
        .padding(.horizontal, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.eolKpLnBV18B5zFVYquf59EJN7NQGzrX)
        .background(
            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}


struct AchievementCardView: View {
    let achievement: Achievement
    
    private var achievementColor: Color {
        switch achievement.id {
        case .firstWorkout:
            return .yellow
        case .fiveWorkouts:
            return .orange
        case .tenWorkouts:
            return .green
        case .weeklyStreak:
            return .blue
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievementColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.id.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(achievement.unlocked ? achievementColor : .gray)
            }
            
            VStack(spacing: 4) {
                Text(achievement.id.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(achievement.unlocked ? .white : .gray)
                    .multilineTextAlignment(.center)
                
                Text(achievement.id.description)
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
                .fill(Color.white.opacity(achievement.unlocked ? 0.05 : 0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.unlocked ? achievementColor.opacity(0.3) : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(achievement.unlocked ? 1.0 : 0.95)
        .opacity(achievement.unlocked ? 1.0 : 0.6)
    }
}

struct fM0AZDH6Yec2hzQWdXDePaBvu63dLdVu: View {
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

struct EABnaL1XzCUCZkIaZIAdA7g308u3aHKs {
    let joqflDa9yaeZ68zS1fMy0Sb4Y2oQFTEI: Int
    let FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: String
    let W5TVRE97oSlHf67bpUXP80LgXeYzET6B: String
    let QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: String
    let QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color
    let WPOomtGamDTA3limTrUPOXHSA1x0PB4H: Bool
}

// MARK: - Simple CloudKit Test View
struct PkzOiTS3hyl3qrAITSwTANM7qA0J5n4Q: View {
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
            L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("📱 Vista de testing CloudKit iniciada")
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
                            
                            Text(zTTSnqpXq6fSCVYCQZOyyMNzvBlGR5AA(workout.date))
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
                xBPGLLcydtR2Wllc3ZTM59D0Cn2NIS5q(
                    title: "Verificar Cuenta iCloud",
                    icon: "person.icloud",
                    action: B3YZQEnGjkCz1g9zmFgN3DKtHFITZRfN
                )
                
                xBPGLLcydtR2Wllc3ZTM59D0Cn2NIS5q(
                    title: "Crear Entrenamiento de Prueba",
                    icon: "plus.circle",
                    action: sVa7YmFr3rTDgZ3R0liQq3FnIhxhoG4k
                )
                
                xBPGLLcydtR2Wllc3ZTM59D0Cn2NIS5q(
                    title: "Limpiar Logs",
                    icon: "trash",
                    action: ox16CIsNFFKVrRHvY0jfQW3Jh5zxGAkJ
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
    
    private func xBPGLLcydtR2Wllc3ZTM59D0Cn2NIS5q(title: String, icon: String, action: @escaping () -> Void) -> some View {
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
    
    private func B3YZQEnGjkCz1g9zmFgN3DKtHFITZRfN() {
        isRunningTest = true
        L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("🔍 Verificando cuenta iCloud...")
        
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                self.isRunningTest = false
                
                if let error = error {
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[ERR] Error: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .available:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[OK] Cuenta iCloud disponible")
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("📊 Entrenamientos locales: \(self.workouts.count)")
                case .noAccount:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[ERR] No hay cuenta iCloud configurada")
                case .restricted:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[ERR] Cuenta iCloud restringida")
                case .couldNotDetermine:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[ERR] No se pudo determinar estado iCloud")
                case .temporarilyUnavailable:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[WARN]️ iCloud temporalmente no disponible")
                @unknown default:
                    self.L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("❓ Estado iCloud desconocido")
                }
            }
        }
    }
    
    private func sVa7YmFr3rTDgZ3R0liQq3FnIhxhoG4k() {
        isRunningTest = true
        L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("🏋️‍♂️ Creando entrenamiento de prueba...")
        
        let context = managedObjectContext
        let testWorkout = WorkoutEntity(context: context)
        testWorkout.id = UUID()
        testWorkout.type = "Test CloudKit"
        testWorkout.duration = Int32.random(in: 15...60)
        testWorkout.date = Date()
        testWorkout.calories = Int32(testWorkout.duration * 8)
        
        do {
            try context.save()
            L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[OK] Entrenamiento de prueba creado")
            L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("📤 Sincronización CloudKit iniciada automáticamente")
            print("🏃‍♂️ Nuevo entrenamiento Test CloudKit guardado - iniciando sincronización CloudKit")
            print("📊 Tipo: Test CloudKit, Duración: \(testWorkout.duration) min")
            isRunningTest = false
        } catch {
            L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("[ERR] Error al crear entrenamiento: \(error.localizedDescription)")
            isRunningTest = false
        }
    }
    
    private func ox16CIsNFFKVrRHvY0jfQW3Jh5zxGAkJ() {
        testResults.removeAll()
        L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG("🧹 Logs limpiados")
    }
    
    private func L5uIA3yf0pJGeKMe39M5fHbDp8xg1jmG(_ message: String) {
        let timestamp = DateFormatter.hMl76nYPbWZBlEIhQPvRP0ghxaKPqSvL.string(from: Date())
        testResults.append("[\(timestamp)] \(message)")
    }
    
    private func zTTSnqpXq6fSCVYCQZOyyMNzvBlGR5AA(_ date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static let hMl76nYPbWZBlEIhQPvRP0ghxaKPqSvL: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    NavigationStack {
        q29ClCI2LABu3hQnTLcu6EAO6vHtllJW()
    }
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
    .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
}