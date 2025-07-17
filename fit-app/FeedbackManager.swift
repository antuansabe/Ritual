import UIKit
import AVFoundation

// MARK: - Feedback Manager for Haptics and Sounds
class FeedbackManager {
    
    // MARK: - Singleton Instance
    static let shared = FeedbackManager()
    
    // MARK: - Audio Players
    private var successPlayer: AVAudioPlayer?
    private var errorPlayer: AVAudioPlayer?
    
    // MARK: - Initialization
    private init() {
        setupAudioPlayers()
    }
    
    // MARK: - Setup Audio Players
    private func setupAudioPlayers() {
        // Setup success sound player
        if let successSoundURL = Bundle.main.url(forResource: "ding", withExtension: "caf") {
            do {
                successPlayer = try AVAudioPlayer(contentsOf: successSoundURL)
                successPlayer?.prepareToPlay()
                successPlayer?.volume = 0.3
            } catch {
                print("⚠️ Error setting up success sound: \(error.localizedDescription)")
            }
        }
        
        // Setup error sound player (using system sounds as fallback)
        // Note: For error sounds, we'll use system haptics primarily
    }
    
    // MARK: - Public Methods
    
    /// Provides success feedback with light haptic and success sound
    static func success() {
        // Light haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Play success sound
        shared.playSuccessSound()
    }
    
    /// Provides warning feedback with medium haptic
    static func warning() {
        // Medium haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    /// Provides error feedback with heavy haptic and notification feedback
    static func error() {
        // Heavy haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // Additional notification feedback for errors
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
    
    /// Provides selection feedback with light haptic
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    /// Provides notification feedback for success
    static func notificationSuccess() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    /// Provides notification feedback for warning
    static func notificationWarning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    // MARK: - Private Sound Methods
    
    private func playSuccessSound() {
        // Ensure we're on main thread for audio playback
        DispatchQueue.main.async { [weak self] in
            self?.successPlayer?.stop()
            self?.successPlayer?.currentTime = 0
            self?.successPlayer?.play()
        }
    }
    
    // MARK: - Configuration Methods
    
    /// Enable or disable haptic feedback globally
    static func setHapticsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "hapticsEnabled")
    }
    
    /// Enable or disable sound feedback globally
    static func setSoundsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "soundsEnabled")
    }
    
    /// Check if haptics are enabled
    static var hapticsEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "hapticsEnabled") != false // Default to true
    }
    
    /// Check if sounds are enabled
    static var soundsEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "soundsEnabled") != false // Default to true
    }
}

// MARK: - Feedback Manager Extensions for Specific Use Cases

extension FeedbackManager {
    
    /// Feedback for saving workout
    static func workoutSaved() {
        if hapticsEnabled && soundsEnabled {
            success()
        } else if hapticsEnabled {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    /// Feedback for saving goal
    static func goalSaved() {
        if hapticsEnabled {
            notificationSuccess()
        }
        if soundsEnabled {
            shared.playSuccessSound()
        }
    }
    
    /// Feedback for validation error
    static func validationError() {
        if hapticsEnabled {
            error()
        }
    }
    
    /// Feedback for button tap
    static func buttonTap() {
        if hapticsEnabled {
            selection()
        }
    }
    
    /// Feedback for goal completion
    static func goalCompleted() {
        if hapticsEnabled {
            // Double success feedback for goal completion
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                impactFeedback.impactOccurred()
            }
        }
        
        if soundsEnabled {
            shared.playSuccessSound()
        }
    }
}