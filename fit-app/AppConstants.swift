import Foundation
import SwiftUI

// MARK: - Motivational Message Model
struct MotivationalMessage {
    let text: String
    let emoji: String
    let context: MessageContext
    
    enum MessageContext {
        case profile
        case historyEmpty
        case workoutStart
        case longBreak
        case streak
        case general
    }
}

// MARK: - Motivational Message Manager
class MotivationalMessageManager: ObservableObject {
    
    // MARK: - Message Collections
    private let profileMessages = [
        MotivationalMessage(text: "Hoy puedes darte un regalo de movimiento", emoji: "🧘‍♂️", context: .profile),
        MotivationalMessage(text: "Tu bienestar merece estos momentos", emoji: "💚", context: .profile),
        MotivationalMessage(text: "Cada día es una nueva oportunidad", emoji: "🌅", context: .profile),
        MotivationalMessage(text: "Tu cuerpo te agradece este cuidado", emoji: "✨", context: .profile),
        MotivationalMessage(text: "Pequeños pasos, grandes cambios", emoji: "👣", context: .profile)
    ]
    
    private let historyEmptyMessages = [
        MotivationalMessage(text: "Tu primer entrenamiento te está esperando", emoji: "🌱", context: .historyEmpty),
        MotivationalMessage(text: "Cada gran viaje comienza con un paso", emoji: "🚀", context: .historyEmpty),
        MotivationalMessage(text: "Hoy puede ser el día perfecto para empezar", emoji: "🌟", context: .historyEmpty),
        MotivationalMessage(text: "Tu historia fitness está por comenzar", emoji: "📖", context: .historyEmpty)
    ]
    
    private let workoutStartMessages = [
        MotivationalMessage(text: "¿Qué tipo de energía quieres crear hoy?", emoji: "⚡", context: .workoutStart),
        MotivationalMessage(text: "Tu cuerpo está listo para este momento", emoji: "💪", context: .workoutStart),
        MotivationalMessage(text: "Conecta con tu fuerza interior", emoji: "🔥", context: .workoutStart),
        MotivationalMessage(text: "Este momento es tuyo", emoji: "🎯", context: .workoutStart)
    ]
    
    private let longBreakMessages = [
        MotivationalMessage(text: "Todo bien, puedes volver a empezar", emoji: "🌱", context: .longBreak),
        MotivationalMessage(text: "El descanso también es parte del proceso", emoji: "🌿", context: .longBreak),
        MotivationalMessage(text: "Si descansaste, hoy puedes regresar con calma", emoji: "🕊️", context: .longBreak),
        MotivationalMessage(text: "Cada regreso es una nueva oportunidad", emoji: "🌈", context: .longBreak)
    ]
    
    private let streakMessages = [
        MotivationalMessage(text: "¡Tu constancia inspira!", emoji: "🔥", context: .streak),
        MotivationalMessage(text: "Mira lo lejos que has llegado", emoji: "⭐", context: .streak),
        MotivationalMessage(text: "Tu disciplina está dando frutos", emoji: "🌸", context: .streak),
        MotivationalMessage(text: "Eres más fuerte de lo que crees", emoji: "💎", context: .streak)
    ]
    
    // MARK: - Public Methods
    func getMessage(for context: MotivationalMessage.MessageContext, daysSinceLastWorkout: Int = 0, currentStreak: Int = 0) -> MotivationalMessage {
        
        // Lógica adaptativa basada en patrones de entrenamiento
        if daysSinceLastWorkout > 3 {
            return longBreakMessages.randomElement() ?? getDefaultMessage(for: context)
        }
        
        if currentStreak >= 3 {
            return streakMessages.randomElement() ?? getDefaultMessage(for: context)
        }
        
        return getDefaultMessage(for: context)
    }
    
    private func getDefaultMessage(for context: MotivationalMessage.MessageContext) -> MotivationalMessage {
        switch context {
        case .profile:
            return profileMessages.randomElement() ?? MotivationalMessage(text: "Hoy es tu día", emoji: "✨", context: .profile)
        case .historyEmpty:
            return historyEmptyMessages.randomElement() ?? MotivationalMessage(text: "Tu primer paso te espera", emoji: "🌱", context: .historyEmpty)
        case .workoutStart:
            return workoutStartMessages.randomElement() ?? MotivationalMessage(text: "¡A por ello!", emoji: "💪", context: .workoutStart)
        case .longBreak:
            return longBreakMessages.randomElement() ?? MotivationalMessage(text: "Vuelve cuando estés listo", emoji: "🌿", context: .longBreak)
        case .streak:
            return streakMessages.randomElement() ?? MotivationalMessage(text: "¡Increíble progreso!", emoji: "🔥", context: .streak)
        case .general:
            return MotivationalMessage(text: "Cada momento cuenta", emoji: "⭐", context: .general)
        }
    }
    
    // MARK: - Workout Analysis Methods
    func calculateDaysSinceLastWorkout(workouts: [WorkoutEntity]) -> Int {
        guard let lastWorkout = workouts.first else { return Int.max }
        
        let calendar = Calendar.current
        let today = Date()
        let lastWorkoutDate = lastWorkout.date ?? today
        
        return calendar.dateComponents([.day], from: lastWorkoutDate, to: today).day ?? 0
    }
    
    func calculateCurrentStreak(workouts: [WorkoutEntity]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var checkDate = today
        
        for _ in 0..<30 { // Check last 30 days maximum
            let workoutsOnDate = workouts.compactMap { workout -> WorkoutEntity? in
                guard let workoutDate = workout.date else { return nil }
                return calendar.isDate(workoutDate, inSameDayAs: checkDate) ? workout : nil
            }
            
            if workoutsOnDate.isEmpty {
                break
            } else {
                streak += 1
            }
            
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
}

// MARK: - Motivational Card View
struct MotivationalCardView: View {
    let message: MotivationalMessage
    let style: CardStyle
    @State private var animateOnAppear = false
    
    enum CardStyle {
        case prominent      // Para pantallas principales como Perfil
        case subtle         // Para pantallas con más contenido
        case minimal        // Para espacios reducidos
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Emoji container
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppConstants.Design.lavender.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: emojiSize, height: emojiSize)
                
                Text(message.emoji)
                    .font(.system(size: emojiFontSize))
            }
            
            // Message content
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(textFont)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                if style == .prominent {
                    Text("💫 Inspiración del día")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        .italic()
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(cardPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(cardBorder, lineWidth: 1)
                )
        )
        .shadow(color: cardShadow, radius: shadowRadius, x: 0, y: shadowOffset)
        .scaleEffect(animateOnAppear ? 1 : 0.95)
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateOnAppear)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Style Computed Properties
    private var emojiSize: CGFloat {
        switch style {
        case .prominent: return 50
        case .subtle: return 40
        case .minimal: return 32
        }
    }
    
    private var emojiFontSize: CGFloat {
        switch style {
        case .prominent: return 24
        case .subtle: return 20
        case .minimal: return 16
        }
    }
    
    private var textFont: Font {
        switch style {
        case .prominent: return .system(size: 16, weight: .medium, design: .rounded)
        case .subtle: return .system(size: 15, weight: .regular, design: .rounded)
        case .minimal: return .system(size: 14, weight: .regular, design: .rounded)
        }
    }
    
    private var cardPadding: EdgeInsets {
        switch style {
        case .prominent: return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        case .subtle: return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        case .minimal: return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .prominent: return AppConstants.UI.cornerRadiusL
        case .subtle: return AppConstants.UI.cornerRadiusM
        case .minimal: return AppConstants.UI.cornerRadiusS
        }
    }
    
    private var cardBackground: LinearGradient {
        switch style {
        case .prominent:
            return LinearGradient(
                colors: [
                    AppConstants.Design.lavender.opacity(0.15),
                    AppConstants.Design.electricBlue.opacity(0.08),
                    AppConstants.Design.softPurple.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .subtle:
            return LinearGradient(
                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            return LinearGradient(
                colors: [Color.white.opacity(0.06), Color.white.opacity(0.03)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardBorder: LinearGradient {
        switch style {
        case .prominent:
            return LinearGradient(
                colors: [AppConstants.Design.lavender.opacity(0.3), AppConstants.Design.electricBlue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .subtle, .minimal:
            return LinearGradient(
                colors: [Color.white.opacity(0.15), Color.white.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardShadow: Color {
        switch style {
        case .prominent: return AppConstants.Design.lavender.opacity(0.2)
        case .subtle: return .black.opacity(0.1)
        case .minimal: return .black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .prominent: return 8
        case .subtle: return 4
        case .minimal: return 2
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .prominent: return 4
        case .subtle: return 2
        case .minimal: return 1
        }
    }
}

// MARK: - App Configuration
struct AppConstants {
    
    // MARK: - Workout Configuration
    struct Workout {
        static let minDuration = 1
        static let maxDuration = 480 // 8 hours
        static let caloriesPerMinute = 8
        static let maxWorkoutsPerDay = 10
    }
    
    // MARK: - UI Constants
    struct UI {
        // Spacing System
        static let spacingXS: CGFloat = 4
        static let spacingS: CGFloat = 8
        static let spacingM: CGFloat = 12
        static let spacingL: CGFloat = 16
        static let spacingXL: CGFloat = 24
        static let spacingXXL: CGFloat = 32
        
        // Corner Radius
        static let cornerRadiusS: CGFloat = 8
        static let cornerRadiusM: CGFloat = 12
        static let cornerRadiusL: CGFloat = 16
        static let cornerRadiusXL: CGFloat = 20
        
        // Touch Targets
        static let minTouchTarget: CGFloat = 44
        static let fabSize: CGFloat = 56
        
        // Card Sizes
        static let metricCardWidth: CGFloat = 120
        static let metricCardHeight: CGFloat = 100
        static let activityButtonHeight: CGFloat = 80
        
        // Shadow
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Double = 0.1
        
        // Border
        static let borderWidth: CGFloat = 1
        static let borderOpacity: Double = 0.1
    }
    
    // MARK: - Design System
    struct Design {
        // Main Colors
        static let primaryGradient = LinearGradient(
            colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let backgroundGradient = LinearGradient(
            colors: [Color.black, Color(.systemGray6).opacity(0.1)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let cardGradient = LinearGradient(
            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Accent Colors
        static let blue = Color.blue
        static let purple = Color.purple
        static let green = Color.green
        static let orange = Color.orange
        static let red = Color.red
        static let yellow = Color.yellow
        
        // Modern Auth Colors
        static let lavender = Color(red: 0.8, green: 0.8, blue: 1.0)
        static let electricBlue = Color(red: 0.0, green: 0.7, blue: 1.0)
        static let softPurple = Color(red: 0.6, green: 0.5, blue: 0.8)
        static let moonlight = Color(red: 0.95, green: 0.95, blue: 1.0)
        
        // Typography
        static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headerFont = Font.system(size: 22, weight: .bold, design: .rounded)
        static let subheaderFont = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let bodyFont = Font.system(size: 16, weight: .medium, design: .default)
        static let captionFont = Font.system(size: 14, weight: .medium, design: .default)
        static let footnoteFont = Font.system(size: 12, weight: .medium, design: .default)
        
        // Card Styles
        static func cardBackground(_ isHighlighted: Bool = false) -> some ShapeStyle {
            Color.white.opacity(isHighlighted ? 0.1 : 0.05)
        }
        
        static func cardBorder(_ color: Color = .white) -> some ShapeStyle {
            color.opacity(0.1)
        }
        
        static func cardShadow() -> Color {
            Color.black.opacity(0.1)
        }
        
        // Button Styles
        static let primaryButtonGradient = LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let secondaryButtonBackground = Color.white.opacity(0.1)
        
        // Auth Gradients
        static let authHeroGradient = LinearGradient(
            colors: [Color.white.opacity(0.1), Color.blue.opacity(0.05), Color.purple.opacity(0.03)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let fieldGradient = LinearGradient(
            colors: [Color.white.opacity(0.08), Color.blue.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let modernButtonGradient = LinearGradient(
            colors: [electricBlue.opacity(0.8), softPurple.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick: Double = 0.2
        static let standard: Double = 0.3
        static let slow: Double = 0.6
        static let entrance: Double = 0.8
    }
    
    // MARK: - Default User
    struct User {
        static let defaultName = "Usuario"
        static let greeting = "Hola"
        static let welcomeEmoji = "👋"
    }
    
    // MARK: - Daily Motivational Phrases
    struct DailyMotivation {
        static let phrases = [
            "Hoy puedes darte un regalo de movimiento 🧘‍♂️",
            "Tu bienestar merece estos momentos 💚",
            "Cada día es una nueva oportunidad 🌅",
            "Tu cuerpo te agradece este cuidado ✨",
            "Pequeños pasos, grandes cambios 👣",
            "Eres más fuerte de lo que imaginas 💪",
            "Hoy es perfecto para brillar ⭐",
            "Tu energía positiva transforma todo 🌟",
            "Cada movimiento cuenta hacia tu bienestar 🌱",
            "Dedícate tiempo, te lo mereces 🤗",
            "Hoy puedes crear algo hermoso para ti 🌸",
            "Tu constancia silenciosa es poderosa 🌿",
            "Respira, sonríe y comienza 😊",
            "Tu mejor versión te está esperando 🦋",
            "Hoy es un lienzo en blanco lleno de posibilidades 🎨"
        ]
        
        static func randomPhrase() -> String {
            return phrases.randomElement() ?? "Hoy es tu día para brillar ✨"
        }
        
        static func getUserName() -> String {
            // Try SecureStorage first, then fallback to UserDefaults for migration
            if let secureUserName = SecureStorage.shared.retrieveEncrypted(for: SecureStorage.StorageKeys.userDisplayName) {
                return secureUserName
            }
            return UserDefaults.standard.string(forKey: "userName") ?? AppConstants.User.defaultName
        }
    }
}

// MARK: - App Errors
enum AppError: LocalizedError {
    case invalidDuration
    case durationTooShort
    case durationTooLong
    case saveFailed
    case loadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidDuration:
            return "Duración inválida. Ingresa un número válido."
        case .durationTooShort:
            return "La duración mínima es \(AppConstants.Workout.minDuration) minuto."
        case .durationTooLong:
            return "La duración máxima es \(AppConstants.Workout.maxDuration) minutos."
        case .saveFailed:
            return "Error al guardar el entrenamiento. Inténtalo de nuevo."
        case .loadFailed:
            return "Error al cargar los datos."
        }
    }
}

// MARK: - Validation Helpers
extension AppConstants {
    static func validateWorkoutDuration(_ duration: String) -> Result<Int, AppError> {
        let trimmed = duration.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let durationInt = Int(trimmed) else {
            return .failure(.invalidDuration)
        }
        
        guard durationInt >= Workout.minDuration else {
            return .failure(.durationTooShort)
        }
        
        guard durationInt <= Workout.maxDuration else {
            return .failure(.durationTooLong)
        }
        
        return .success(durationInt)
    }
    
    static func calculateCalories(for duration: Int) -> Int {
        return duration * Workout.caloriesPerMinute
    }
}

// MARK: - Motivational Phrase View Component
struct MotivationalPhraseView: View {
    @State private var animateOnAppear = false
    private let userName: String
    private let motivationalPhrase: String
    
    init() {
        self.userName = AppConstants.DailyMotivation.getUserName()
        self.motivationalPhrase = AppConstants.DailyMotivation.randomPhrase()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Welcome greeting with user name
            Text("Bienvenido de nuevo, \(userName) 👋")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6), value: animateOnAppear)
            
            // Motivational phrase
            Text(motivationalPhrase)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateOnAppear)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
    }
}

// MARK: - Training Detail Popup View Component
struct TrainingDetailPopupView: View {
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
    
    private func getWorkoutIcon(for type: String) -> String {
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
    
    private func getWorkoutColor(for type: String) -> Color {
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
                    dismissPopup()
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
                        
                        Button(action: dismissPopup) {
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
                            WorkoutDetailCard(workout: workout)
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
                Button(action: dismissPopup) {
                    Text("Entendido")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppConstants.Design.primaryButtonGradient)
                        )
                        .shadow(color: AppConstants.Design.blue.opacity(0.3), radius: 8, x: 0, y: 4)
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
    
    private func dismissPopup() {
        withAnimation(.easeInOut(duration: 0.2)) {
            animateOnAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}

// MARK: - Workout Detail Card Component
struct WorkoutDetailCard: View {
    let workout: WorkoutEntity
    
    private func getWorkoutIcon(for type: String) -> String {
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
    
    private func getWorkoutColor(for type: String) -> Color {
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
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Workout icon
            ZStack {
                Circle()
                    .fill(getWorkoutColor(for: workout.type ?? "").opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(getWorkoutColor(for: workout.type ?? "").opacity(0.3), lineWidth: 2)
                    )
                
                Image(systemName: getWorkoutIcon(for: workout.type ?? ""))
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(getWorkoutColor(for: workout.type ?? ""))
            }
            
            // Workout details
            VStack(alignment: .leading, spacing: 8) {
                Text(workout.type ?? "Entrenamiento")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("\(workout.duration) minutos")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                        Text("\(workout.calories) calorías")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "clock.badge.checkmark.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                        Text(timeFormatter.string(from: workout.date ?? Date()))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(getWorkoutColor(for: workout.type ?? "").opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}