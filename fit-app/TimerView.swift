import SwiftUI
import AudioToolbox
import AVFoundation
import Foundation
import Combine

// MARK: - TimerViewModel
@MainActor
final class TimerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTimerType: wj1PITNF50YDIsWEj4a7OZgroyUqjcTI = .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8
    @Published var workDuration: Int = 20
    @Published var restDuration: Int = 10
    @Published var rounds: Int = 8
    @Published var isTimerRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var animateOnAppear = false
    
    // Timer Logic State
    @Published var minutes: Int = 0
    @Published var seconds: Int = 20
    @Published var currentState: QCxXT2kSPIbWvflUyClOkikKBvurCtBx = .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC
    @Published var currentRound: Int = 1
    @Published var showCompletionAlert = false
    
    // Validation states
    @Published var showValidationAlert = false
    @Published var validationMessage = ""
    
    // Private state
    nonisolated(unsafe) private var timer: Timer?
    private var workAudioPlayer: AVAudioPlayer?
    private var restAudioPlayer: AVAudioPlayer?
    private var timerStarted = false // Prevent multiple timer starts
    
    // MARK: - Computed Properties
    var timeDisplayString: String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var isConfigurationValid: Bool {
        let workValid = workDuration > 0
        let restValid = restDuration > 0
        let roundsValid = selectedTimerType == .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 || rounds > 0
        return workValid && restValid && roundsValid
    }
    
    var canStartTimer: Bool {
        return isConfigurationValid && !isTimerRunning
    }
    
    var progressPercentage: Double {
        let totalSeconds = getCurrentPhaseDuration()
        let remainingSeconds = minutes * 60 + seconds
        let elapsedSeconds = totalSeconds - remainingSeconds
        return totalSeconds > 0 ? Double(elapsedSeconds) / Double(totalSeconds) : 0
    }
    
    var nextPhaseText: String {
        switch currentState {
        case .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1:
            if selectedTimerType == .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 {
                return "Fin del entrenamiento"
            } else {
                return currentRound >= rounds ? "Fin del entrenamiento" : "Descanso (\(restDuration)s)"
            }
        case .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x:
            return currentRound >= rounds ? "Fin del entrenamiento" : "Trabajo (\(workDuration)s)"
        default:
            return ""
        }
    }
    
    // MARK: - Initialization
    init() {
        setupAudioPlayers()
        updateTimerFromType()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Public Methods
    func onAppear() {
        guard !animateOnAppear else { return } // Prevent double animation
        
        withAnimation(.easeOut(duration: 0.8)) {
            animateOnAppear = true
        }
        
        if !timerStarted {
            setupAudioPlayers()
        }
    }
    
    func onDisappear() {
        cleanupTimer()
    }
    
    func updateFromTimerType() {
        guard !isTimerRunning else { return }
        
        workDuration = selectedTimerType.gT3QPVtHL1YVcRO1v0Kevo1tMC2N1kja
        restDuration = selectedTimerType.pigV3hi0my7eS2KVEeKoMKTTUxGCMo5s
        updateTimerFromType()
    }
    
    func toggleTimer() {
        // Validate configuration before starting
        if !isTimerRunning && !validateConfiguration() {
            return
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if !isTimerRunning {
                // Start timer
                startTimer()
            } else if isPaused {
                // Resume timer
                resumeTimer()
            } else {
                // Pause timer
                pauseTimer()
            }
        }
    }
    
    func cancelTimer() {
        // Add haptic feedback for cancel action
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            resetTimer()
        }
    }
    
    func completeTimer() {
        withAnimation(.easeInOut(duration: 0.5)) {
            resetTimer()
        }
    }
    
    // MARK: - Private Methods
    private func getCurrentPhaseDuration() -> Int {
        switch currentState {
        case .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1: return workDuration
        case .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x: return restDuration
        default: return workDuration
        }
    }
    
    private func startTimer() {
        guard !timerStarted else { return } // Prevent multiple starts
        
        timerStarted = true
        isTimerRunning = true
        isPaused = false
        
        if currentState == .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC {
            currentState = .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1
            setTimerDuration(workDuration)
            playWorkSound()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                self.tick()
            }
        }
    }
    
    private func resumeTimer() {
        isPaused = false
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                Task { @MainActor in
                    self.tick()
                }
            }
        }
    }
    
    private func pauseTimer() {
        isPaused = true
        cleanupTimer()
    }
    
    private func resetTimer() {
        cleanupTimer()
        timerStarted = false
        isTimerRunning = false
        isPaused = false
        currentState = .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC
        currentRound = 1
        updateTimerFromType()
    }
    
    private func cleanupTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimerFromType() {
        minutes = workDuration / 60
        seconds = workDuration % 60
        currentState = .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC
        currentRound = 1
    }
    
    private func setTimerDuration(_ duration: Int) {
        minutes = duration / 60
        seconds = duration % 60
    }
    
    private func tick() {
        guard isTimerRunning && !isPaused else { return }
        
        if seconds > 0 {
            seconds -= 1
        } else if minutes > 0 {
            minutes -= 1
            seconds = 59
        } else {
            handlePhaseTransition()
        }
    }
    
    private func handlePhaseTransition() {
        switch currentState {
        case .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1:
            if selectedTimerType == .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 {
                completeWorkout()
            } else {
                // Switch to rest phase
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                playRestSound()
                currentState = .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x
                setTimerDuration(restDuration)
            }
            
        case .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x:
            if currentRound >= rounds {
                completeWorkout()
            } else {
                // Move to next round
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                playWorkSound()
                currentRound += 1
                currentState = .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1
                setTimerDuration(workDuration)
            }
            
        default:
            break
        }
    }
    
    private func completeWorkout() {
        cleanupTimer()
        currentState = .zxy98ghKsmaUyShNoZ5jOB5kHpma0LT5
        withAnimation(.easeInOut(duration: 0.3)) {
            isTimerRunning = false
            isPaused = false
        }
        
        // Show completion alert after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showCompletionAlert = true
        }
    }
    
    private func setupAudioPlayers() {
        // Setup work phase sound
        if let workSoundURL = Bundle.main.url(forResource: "work-chime", withExtension: "wav") {
            do {
                workAudioPlayer = try AVAudioPlayer(contentsOf: workSoundURL)
                workAudioPlayer?.prepareToPlay()
                workAudioPlayer?.volume = 0.6
            } catch {
                print("[INFO] Work chime sound not found, will use system fallback")
            }
        }
        
        // Setup rest phase sound
        if let restSoundURL = Bundle.main.url(forResource: "rest-chime", withExtension: "wav") {
            do {
                restAudioPlayer = try AVAudioPlayer(contentsOf: restSoundURL)
                restAudioPlayer?.prepareToPlay()
                restAudioPlayer?.volume = 0.5
            } catch {
                print("[INFO] Rest chime sound not found, will use system fallback")
            }
        }
        
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("[ERR] Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    private func playWorkSound() {
        if let player = workAudioPlayer {
            player.stop()
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(1016) // Tink sound
        }
    }
    
    private func playRestSound() {
        if let player = restAudioPlayer {
            player.stop()
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(1013) // Glass sound
        }
    }
    
    private func validateConfiguration() -> Bool {
        var issues: [String] = []
        
        if workDuration <= 0 {
            issues.append("• El tiempo de trabajo debe ser mayor a 0 segundos")
        }
        
        if restDuration <= 0 {
            issues.append("• El tiempo de descanso debe ser mayor a 0 segundos")
        }
        
        if selectedTimerType != .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 && rounds <= 0 {
            issues.append("• El número de rondas debe ser mayor a 0")
        }
        
        if !issues.isEmpty {
            validationMessage = "Por favor corrige los siguientes problemas:\n\n" + issues.joined(separator: "\n")
            showValidationAlert = true
            return false
        }
        
        return true
    }
}

// MARK: - Timer Type Model
enum wj1PITNF50YDIsWEj4a7OZgroyUqjcTI: String, CaseIterable {
    case VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8 = "Tabata"
    case ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72 = "HIIT"
    case P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 = "Personalizado"
    
    var gT3QPVtHL1YVcRO1v0Kevo1tMC2N1kja: Int {
        switch self {
        case .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8: return 20
        case .ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72: return 30
        case .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9: return 45
        }
    }
    
    var pigV3hi0my7eS2KVEeKoMKTTUxGCMo5s: Int {
        switch self {
        case .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8: return 10
        case .ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72: return 30
        case .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9: return 15
        }
    }
    
    var QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: String {
        switch self {
        case .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8: return "timer"
        case .ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72: return "stopwatch"
        case .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9: return "gear"
        }
    }
    
    var QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color {
        switch self {
        case .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8: return .red
        case .ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72: return .orange
        case .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9: return .blue
        }
    }
}

// MARK: - Timer State Enum
enum QCxXT2kSPIbWvflUyClOkikKBvurCtBx {
    case VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC
    case fJb3AnvLQe202gy6jmQwrRF0z8W3JER1
    case M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x
    case zxy98ghKsmaUyShNoZ5jOB5kHpma0LT5
    
    var FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf: String {
        switch self {
        case .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC: return "Listo para empezar"
        case .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1: return "¡TRABAJA!"
        case .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x: return "Descansa"
        case .zxy98ghKsmaUyShNoZ5jOB5kHpma0LT5: return "¡Completado!"
        }
    }
    
    var QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color {
        switch self {
        case .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC: return .blue
        case .fJb3AnvLQe202gy6jmQwrRF0z8W3JER1: return .green
        case .M8IbOnV08mw1yxQZ7YDxAyTmuMWXFX8x: return .orange
        case .zxy98ghKsmaUyShNoZ5jOB5kHpma0LT5: return .purple
        }
    }
}

// MARK: - Timer View
struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        ReusableBackgroundView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    if viewModel.isTimerRunning || viewModel.currentState != .VKgfRX5qiiFtp342tT5Vi4hEqtshA2RC {
                        timerDisplaySection
                    } else {
                        timerTypeSection
                        configurationSection
                    }
                    
                    startButtonSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.selectedTimerType) { newType in
            viewModel.updateFromTimerType()
        }
        .alert("¡Tiempo Completo!", isPresented: $viewModel.showCompletionAlert) {
            Button("OK") {
                viewModel.completeTimer()
            }
        } message: {
            Text("Has completado tu sesión de entrenamiento")
        }
        .alert("Configuración Inválida", isPresented: $viewModel.showValidationAlert) {
            Button("OK") {
                viewModel.showValidationAlert = false
            }
        } message: {
            Text(viewModel.validationMessage)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
    
    // MARK: - Computed Properties
    private var selectedTimerType: wj1PITNF50YDIsWEj4a7OZgroyUqjcTI {
        viewModel.selectedTimerType
    }
    
    private var workDuration: Int {
        viewModel.workDuration
    }
    
    private var restDuration: Int {
        viewModel.restDuration
    }
    
    private var rounds: Int {
        viewModel.rounds
    }
    
    private var isTimerRunning: Bool {
        viewModel.isTimerRunning
    }
    
    private var isPaused: Bool {
        viewModel.isPaused
    }
    
    private var minutes: Int {
        viewModel.minutes
    }
    
    private var seconds: Int {
        viewModel.seconds
    }
    
    private var currentState: QCxXT2kSPIbWvflUyClOkikKBvurCtBx {
        viewModel.currentState
    }
    
    private var currentRound: Int {
        viewModel.currentRound
    }
    
    private var animateOnAppear: Bool {
        viewModel.animateOnAppear
    }
    
    private var progressPercentage: Double {
        viewModel.progressPercentage
    }
    
    private var timeDisplayString: String {
        viewModel.timeDisplayString
    }
    
    private var nextPhaseText: String {
        viewModel.nextPhaseText
    }
    
    private var canStartTimer: Bool {
        viewModel.canStartTimer
    }
    
    // MARK: - Timer Display Section
    private var timerDisplaySection: some View {
        VStack(spacing: 32) {
            // Current State and Round Info
            VStack(spacing: 12) {
                if viewModel.selectedTimerType != .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 && viewModel.rounds > 1 {
                    Text("Ronda \(viewModel.currentRound) de \(viewModel.rounds)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(viewModel.currentState.FTHUTNSpsE8UA18FuBCnsyiUIC2Gujzf)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA)
                    .shadow(color: viewModel.currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            
            // Main Timer Display
            VStack(spacing: 20) {
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 6)
                        .frame(width: 200, height: 200)
                    
                    // Progress ring
                    Circle()
                        .trim(from: 0, to: progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA, currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.3), value: progressPercentage)
                    
                    // Time display
                    VStack(spacing: 6) {
                        Text(timeDisplayString)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        Text("mm:ss")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                // Next phase indicator
                if isTimerRunning && !isPaused {
                    VStack(spacing: 8) {
                        Text("Siguiente:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(nextPhaseText)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.4), lineWidth: 2)
                )
        )
        .shadow(color: currentState.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.2), radius: 10, x: 0, y: 4)
        .opacity(animateOnAppear ? 1 : 0)
        .scaleEffect(animateOnAppear ? 1 : 0.9)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateOnAppear)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentState)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
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
                    
                    Image(systemName: "timer")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("Temporizador")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Entrena con intervalos de tiempo")
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
    
    // MARK: - Timer Type Section
    private var timerTypeSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Tipo de temporizador")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(wj1PITNF50YDIsWEj4a7OZgroyUqjcTI.allCases, id: \.self) { timerType in
                    f0DbJBjrfl3d7nEf6UST5ZGjHjQ5Y2Am(
                        timerType: timerType,
                        isSelected: selectedTimerType == timerType,
                        action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.selectedTimerType = timerType
                            }
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Configuration Section
    private var configurationSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Configuración")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Work Duration
                cqL4x6Penm19Hqf0x0SS2z22P2GQIB8a(
                    title: "Trabajo",
                    duration: $viewModel.workDuration,
                    icon: "figure.run",
                    color: .green,
                    range: 5...300
                )
                
                // Rest Duration
                cqL4x6Penm19Hqf0x0SS2z22P2GQIB8a(
                    title: "Descanso",
                    duration: $viewModel.restDuration,
                    icon: "pause.circle",
                    color: .blue,
                    range: 5...300
                )
                
                // Rounds (only for Tabata and HIIT)
                if selectedTimerType != .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 {
                    cqL4x6Penm19Hqf0x0SS2z22P2GQIB8a(
                        title: "Rondas",
                        duration: $viewModel.rounds,
                        icon: "repeat",
                        color: .orange,
                        range: 1...20
                    )
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Start Button Section
    private var startButtonSection: some View {
        VStack(spacing: 20) {
            if isTimerRunning {
                // When timer is running, show pause/resume and cancel buttons
                HStack(spacing: 16) {
                    // Pause/Resume button
                    Button(action: { viewModel.toggleTimer() }) {
                        HStack(spacing: 8) {
                            Image(systemName: buttonIcon)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(buttonText)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(buttonGradient)
                        )
                        .shadow(color: buttonShadowColor, radius: 6, x: 0, y: 3)
                    }
                    
                    // Cancel button
                    Button(action: { viewModel.cancelTimer() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Cancelar")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(
                                    LinearGradient(
                                        colors: [.red.opacity(0.8), .red.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 3)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isTimerRunning)
            } else {
                // When timer is not running, show start button
                Button(action: { viewModel.toggleTimer() }) {
                    HStack(spacing: 12) {
                        Image(systemName: buttonIcon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(buttonText)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(buttonGradient)
                    )
                    .shadow(color: buttonShadowColor, radius: 8, x: 0, y: 4)
                    .opacity(canStartTimer ? 1.0 : 0.6)
                    .animation(.easeInOut(duration: 0.2), value: canStartTimer)
                }
                .disabled(!canStartTimer)
            }
            
            // Timer summary - more compact layout
            VStack(spacing: 12) {
                Text("Resumen")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 16) {
                    Ar2rt9Q88PYVOw7e2UhhKEciUJEpXGg4(
                        icon: "clock.fill",
                        value: "\(workDuration)s",
                        label: "Trabajo"
                    )
                    
                    Ar2rt9Q88PYVOw7e2UhhKEciUJEpXGg4(
                        icon: "pause.fill",
                        value: "\(restDuration)s",
                        label: "Descanso"
                    )
                    
                    if selectedTimerType != .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9 {
                        Ar2rt9Q88PYVOw7e2UhhKEciUJEpXGg4(
                            icon: "repeat",
                            value: "\(rounds)",
                            label: "Rondas"
                        )
                    }
                }
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Button Properties
    private var buttonIcon: String {
        if !isTimerRunning {
            return "play.fill"
        } else if isPaused {
            return "play.fill"
        } else {
            return "pause.fill"
        }
    }
    
    private var buttonText: String {
        if !isTimerRunning {
            return "Iniciar Temporizador"
        } else if isPaused {
            return "Reanudar"
        } else {
            return "Pausar"
        }
    }
    
    private var buttonGradient: LinearGradient {
        if !canStartTimer && !isTimerRunning {
            return LinearGradient(
                colors: [.gray, .gray.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if !isTimerRunning {
            return LinearGradient(
                colors: [.green, .blue],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if isPaused {
            return LinearGradient(
                colors: [.green, .blue],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [.orange, .red],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private var buttonShadowColor: Color {
        if !canStartTimer && !isTimerRunning {
            return .gray.opacity(0.2)
        } else if !isTimerRunning || isPaused {
            return .green.opacity(0.4)
        } else {
            return .orange.opacity(0.4)
        }
    }
    
    
}

// MARK: - Compact Timer Type Button Component
struct f0DbJBjrfl3d7nEf6UST5ZGjHjQ5Y2Am: View {
    let timerType: wj1PITNF50YDIsWEj4a7OZgroyUqjcTI
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.3) : timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: timerType.QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .white : timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(timerType.rawValue)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                        .lineLimit(1)
                    
                    Text(lWYN5MqGaSGHpReLdNm55XfCSRUKL3NE(for: timerType))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .white.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ? 
                            LinearGradient(
                                colors: [timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.4), timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? timerType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private func lWYN5MqGaSGHpReLdNm55XfCSRUKL3NE(for type: wj1PITNF50YDIsWEj4a7OZgroyUqjcTI) -> String {
        switch type {
        case .VfceYO5YMYBgFqLP4wZ9RM5QpLNKdjH8:
            return "20s trabajo, 10s descanso"
        case .ynrpfZ0cPrSfOMMXYlva6OqaxORS2n72:
            return "30s trabajo, 30s descanso"
        case .P9RJFaUmzFAvzUTrHJFuXfVduNcfxez9:
            return "Configura tus propios tiempos"
        }
    }
}

// MARK: - Optimized Duration Config Card Component
struct cqL4x6Penm19Hqf0x0SS2z22P2GQIB8a: View {
    let title: String
    @Binding var duration: Int
    let icon: String
    let color: Color
    let range: ClosedRange<Int>
    
    @State private var minusButtonPressed = false
    @State private var plusButtonPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Header with icon and title
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(HaCQgkXuZK3BrMdYpHm2jmUW7qHn33AB(duration))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Compact controls section
            HStack(spacing: 12) {
                // Minus button - smaller and more compact
                Button(action: { whoMiJLT9Ee2cjI0oM8DMhMjTXg3akKI() }) {
                    ZStack {
                        Circle()
                            .fill(duration > range.lowerBound ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(duration > range.lowerBound ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(duration > range.lowerBound ? .white : .white.opacity(0.3))
                    }
                }
                .disabled(duration <= range.lowerBound)
                .accessibilityLabel("Disminuir \(title.lowercased())")
                .accessibilityHint("Toca para reducir el valor")
                .scaleEffect(minusButtonPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: minusButtonPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    minusButtonPressed = pressing
                }, perform: {})
                
                Spacer()
                
                // Value display - centered and prominent
                ZStack {
                    Capsule()
                        .fill(color.opacity(0.2))
                        .frame(width: 80, height: 36)
                        .overlay(
                            Capsule()
                                .stroke(color.opacity(0.5), lineWidth: 1.5)
                        )
                    
                    Text("\(duration)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: duration)
                }
                
                Spacer()
                
                // Plus button - smaller and more compact
                Button(action: { du2B91k4HqA38OtJygbTkZfZKXoCCnh3() }) {
                    ZStack {
                        Circle()
                            .fill(duration < range.upperBound ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(duration < range.upperBound ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(duration < range.upperBound ? .white : .white.opacity(0.3))
                    }
                }
                .disabled(duration >= range.upperBound)
                .accessibilityLabel("Aumentar \(title.lowercased())")
                .accessibilityHint("Toca para incrementar el valor")
                .scaleEffect(plusButtonPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: plusButtonPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    plusButtonPressed = pressing
                }, perform: {})
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func du2B91k4HqA38OtJygbTkZfZKXoCCnh3() {
        guard duration < range.upperBound else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if title == "Rondas" {
                duration += 1
            } else {
                duration += 5
            }
        }
    }
    
    private func whoMiJLT9Ee2cjI0oM8DMhMjTXg3akKI() {
        guard duration > range.lowerBound else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if title == "Rondas" {
                duration -= 1
            } else {
                duration -= 5
            }
        }
    }
    
    private func HaCQgkXuZK3BrMdYpHm2jmUW7qHn33AB(_ seconds: Int) -> String {
        if title == "Rondas" {
            return seconds == 1 ? "1 ronda" : "\(seconds) rondas"
        } else {
            return seconds == 1 ? "1 segundo" : "\(seconds) segundos"
        }
    }
}

// MARK: - Compact Summary Item Component
struct Ar2rt9Q88PYVOw7e2UhhKEciUJEpXGg4: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TimerView()
        }
        .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
    }
}

#Preview {
    NavigationStack {
        TimerView()
    }
    .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}