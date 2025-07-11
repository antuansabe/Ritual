import SwiftUI
import CoreData
import Combine
import os.log

// MARK: - Weekly Goal Manager
class c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7: ObservableObject {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7()
    
    @Published var FXSqAeHL1HY1LOVtf42C1SP3ty5mvJcz = false
    @Published var keMSUrVMokzCOpVVheeGQD50FQ41fXak: Int = 3
    @Published var r59cI8ba1ct8kBcy0uXMMef36MOqURK5: Int = 0
    
    private var e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg = Set<AnyCancellable>()
    private let Oh4Aurwyqt6m3ECRYNFjDgQ5h2EkCJb0 = Calendar.current
    
    // Key for tracking when goal was last achieved (week identifier)
    private let SYB3nnNkPdYoBTY42ppmebmtS98CoDV6 = "lastGoalAchievedWeek"
    
    private init() {
        // Load current weekly goal from UserDefaults
        Ljqg0j2JEdq2NYwqv5VwzxbJjihGzU6M()
        
        // Listen for weekly goal changes
        NotificationCenter.default.publisher(for: .PNqxq0lAjFsRRnIb7XoCcURRETBAHPqh)
            .sink { [weak self] notification in
                if let newGoal = notification.object as? Int {
                    self?.keMSUrVMokzCOpVVheeGQD50FQ41fXak = newGoal
                }
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
        
        // Listen for workout saves
        NotificationCenter.default.publisher(for: .gUTLJd2whxFIrGRCEMVrNZWSFPiU5gq5)
            .sink { [weak self] notification in
                self?.WLoxguEswq4CuQfdpHwKlvTqsFuI2GJO()
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
    }
    
    // MARK: - Public Methods
    
    private func WLoxguEswq4CuQfdpHwKlvTqsFuI2GJO() {
        // Fetch current workouts from Core Data
        let context = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        
        do {
            let workouts = try context.fetch(request)
            OyouN4YSTDcoHEPkN83goxp5YNzg3TVt(workouts: workouts)
        } catch {
            #if DEBUG
            Logger.Ob4SnetCO7LMPevIhjhaA06irglkRYx7.debug("Error fetching workouts for goal check: \(error)")
            #endif
        }
    }
    
    func OyouN4YSTDcoHEPkN83goxp5YNzg3TVt(workouts: [WorkoutEntity]) {
        let newWorkoutCount = YGfyA4j6n8VpKAbvWRChLrm5MMbM8kAQ(workouts: workouts)
        let previousCount = r59cI8ba1ct8kBcy0uXMMef36MOqURK5
        r59cI8ba1ct8kBcy0uXMMef36MOqURK5 = newWorkoutCount
        
        // Check if goal was just achieved
        if newWorkoutCount >= keMSUrVMokzCOpVVheeGQD50FQ41fXak && 
           previousCount < keMSUrVMokzCOpVVheeGQD50FQ41fXak && 
           !YvmcFpfE3rTFyo1k7a8LjB3QOxbm7hxV() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.FXSqAeHL1HY1LOVtf42C1SP3ty5mvJcz = true
                self.nFIWoczddTtIJs8mn0Hfbf03eILIbeL3()
            }
        }
    }
    
    func uH7nVg4PqbRQECupKyNXkrosiKgHDGfi(workouts: [WorkoutEntity]) {
        r59cI8ba1ct8kBcy0uXMMef36MOqURK5 = YGfyA4j6n8VpKAbvWRChLrm5MMbM8kAQ(workouts: workouts)
    }
    
    func dIdZKmE5aRz3ApThTedBMePDOG2RyaPA() {
        withAnimation(.easeInOut(duration: 0.3)) {
            FXSqAeHL1HY1LOVtf42C1SP3ty5mvJcz = false
        }
    }
    
    // MARK: - Private Methods
    
    private func Ljqg0j2JEdq2NYwqv5VwzxbJjihGzU6M() {
        let storedGoal = UserDefaults.standard.integer(forKey: "weeklyGoal")
        keMSUrVMokzCOpVVheeGQD50FQ41fXak = storedGoal == 0 ? 3 : storedGoal
    }
    
    private func YGfyA4j6n8VpKAbvWRChLrm5MMbM8kAQ(workouts: [WorkoutEntity]) -> Int {
        let today = Date()
        
        return workouts.filter { workout in
            Oh4Aurwyqt6m3ECRYNFjDgQ5h2EkCJb0.isDate(workout.date ?? Date(), equalTo: today, toGranularity: .weekOfYear)
        }.count
    }
    
    private func fH9FnbIw8yM9fqRBC2DUZny0y3FXbx1I() -> String {
        let today = Date()
        let year = Oh4Aurwyqt6m3ECRYNFjDgQ5h2EkCJb0.component(.yearForWeekOfYear, from: today)
        let week = Oh4Aurwyqt6m3ECRYNFjDgQ5h2EkCJb0.component(.weekOfYear, from: today)
        return "\(year)-W\(week)"
    }
    
    private func YvmcFpfE3rTFyo1k7a8LjB3QOxbm7hxV() -> Bool {
        let currentWeek = fH9FnbIw8yM9fqRBC2DUZny0y3FXbx1I()
        let lastShownWeek = UserDefaults.standard.string(forKey: SYB3nnNkPdYoBTY42ppmebmtS98CoDV6)
        return currentWeek == lastShownWeek
    }
    
    private func nFIWoczddTtIJs8mn0Hfbf03eILIbeL3() {
        let currentWeek = fH9FnbIw8yM9fqRBC2DUZny0y3FXbx1I()
        UserDefaults.standard.set(currentWeek, forKey: SYB3nnNkPdYoBTY42ppmebmtS98CoDV6)
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let PNqxq0lAjFsRRnIb7XoCcURRETBAHPqh = Notification.Name("weeklyGoalChanged")
    static let gUTLJd2whxFIrGRCEMVrNZWSFPiU5gq5 = Notification.Name("workoutSaved")
}

// MARK: - Global Goal Achievement Popup
struct isqjtgeChdmyuavMEwRRyV8yoeHAhS9Z: View {
    @EnvironmentObject var goalManager: c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7
    @State private var animateContent = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            if goalManager.FXSqAeHL1HY1LOVtf42C1SP3ty5mvJcz {
                // Background overlay
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .opacity(animateBackground ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: animateBackground)
                    .onTapGesture {
                        goalManager.dIdZKmE5aRz3ApThTedBMePDOG2RyaPA()
                    }
                
                // Achievement popup
                swiOYC5mtoFUz2zI7YyclOwn9EfYp7Zn()
                    .scaleEffect(animateContent ? 1.0 : 0.3)
                    .opacity(animateContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)
            }
        }
        .onChange(of: goalManager.FXSqAeHL1HY1LOVtf42C1SP3ty5mvJcz) { isShowing in
            if isShowing {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animateBackground = true
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateContent = true
                }
                
                // Auto-dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    goalManager.dIdZKmE5aRz3ApThTedBMePDOG2RyaPA()
                }
            } else {
                animateContent = false
                animateBackground = false
            }
        }
    }
}

// MARK: - Goal Achievement Popup Content
struct swiOYC5mtoFUz2zI7YyclOwn9EfYp7Zn: View {
    @EnvironmentObject var goalManager: c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7
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
                
                Text("¡Felicidades! Has completado \(goalManager.keMSUrVMokzCOpVVheeGQD50FQ41fXak) entrenamientos esta semana")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Progress indicator
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.green)
                    
                    Text("\(goalManager.r59cI8ba1ct8kBcy0uXMMef36MOqURK5)/\(goalManager.keMSUrVMokzCOpVVheeGQD50FQ41fXak) entrenamientos")
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
                Text("🌟 Tu constancia es inspiradora 🌟")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.yellow)
                
                Text("Cada entrenamiento te acerca más a tus objetivos")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            // Dismiss button
            Button(action: {
                goalManager.dIdZKmE5aRz3ApThTedBMePDOG2RyaPA()
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
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), radius: 8, x: 0, y: 4)
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