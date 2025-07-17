import Foundation
import SwiftUI
import AudioToolbox
import AVFoundation
import Combine

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
    private var timer: Timer?
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
        cleanupTimer()
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