import SwiftUI

// MARK: - Timer Type Model
enum TimerType: String, CaseIterable {
    case tabata = "Tabata"
    case hiit = "HIIT"
    case custom = "Personalizado"
    
    var defaultWorkDuration: Int {
        switch self {
        case .tabata: return 20
        case .hiit: return 30
        case .custom: return 45
        }
    }
    
    var defaultRestDuration: Int {
        switch self {
        case .tabata: return 10
        case .hiit: return 30
        case .custom: return 15
        }
    }
    
    var icon: String {
        switch self {
        case .tabata: return "timer"
        case .hiit: return "stopwatch"
        case .custom: return "gear"
        }
    }
    
    var color: Color {
        switch self {
        case .tabata: return .red
        case .hiit: return .orange
        case .custom: return .blue
        }
    }
}

// MARK: - Timer View
struct TimerView: View {
    @State private var selectedTimerType: TimerType = .tabata
    @State private var workDuration: Int = 20
    @State private var restDuration: Int = 10
    @State private var rounds: Int = 8
    @State private var isTimerRunning: Bool = false
    @State private var isPaused: Bool = false
    @State private var animateOnAppear = false
    
    var body: some View {
        ZStack {
            // Background
            Image("registroBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            AppConstants.Design.backgroundGradient
                .opacity(0.7)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    timerTypeSection
                    configurationSection
                    startButtonSection
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
        .onChange(of: selectedTimerType) { newType in
            // Update durations when timer type changes
            workDuration = newType.defaultWorkDuration
            restDuration = newType.defaultRestDuration
        }
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
                                colors: [AppConstants.Design.electricBlue.opacity(0.3), AppConstants.Design.softPurple.opacity(0.2)],
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
        VStack(spacing: 24) {
            HStack {
                Text("Tipo de temporizador")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 16) {
                ForEach(TimerType.allCases, id: \.self) { timerType in
                    TimerTypeButton(
                        timerType: timerType,
                        isSelected: selectedTimerType == timerType,
                        action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedTimerType = timerType
                            }
                        }
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
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Configuration Section
    private var configurationSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Configuración")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 20) {
                // Work Duration
                DurationConfigCard(
                    title: "Trabajo",
                    duration: $workDuration,
                    icon: "figure.run",
                    color: .green,
                    range: 5...300
                )
                
                // Rest Duration
                DurationConfigCard(
                    title: "Descanso",
                    duration: $restDuration,
                    icon: "pause.circle",
                    color: .blue,
                    range: 5...300
                )
                
                // Rounds (only for Tabata and HIIT)
                if selectedTimerType != .custom {
                    DurationConfigCard(
                        title: "Rondas",
                        duration: $rounds,
                        icon: "repeat",
                        color: .orange,
                        range: 1...20
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
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Start Button Section
    private var startButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: toggleTimer) {
                HStack(spacing: 16) {
                    Image(systemName: buttonIcon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(buttonText)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(buttonGradient)
                )
                .shadow(color: buttonShadowColor, radius: 12, x: 0, y: 6)
                .scaleEffect(isTimerRunning ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTimerRunning)
            }
            
            // Timer summary
            VStack(spacing: 8) {
                Text("Resumen")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 20) {
                    TimerSummaryItem(
                        icon: "clock.fill",
                        value: "\(workDuration)s",
                        label: "Trabajo"
                    )
                    
                    TimerSummaryItem(
                        icon: "pause.fill",
                        value: "\(restDuration)s",
                        label: "Descanso"
                    )
                    
                    if selectedTimerType != .custom {
                        TimerSummaryItem(
                            icon: "repeat",
                            value: "\(rounds)",
                            label: "Rondas"
                        )
                    }
                }
            }
            .padding(.top, 16)
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
        if !isTimerRunning {
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
        if !isTimerRunning || isPaused {
            return .green.opacity(0.4)
        } else {
            return .orange.opacity(0.4)
        }
    }
    
    // MARK: - Actions
    private func toggleTimer() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if !isTimerRunning {
                // Start timer
                isTimerRunning = true
                isPaused = false
            } else if isPaused {
                // Resume timer
                isPaused = false
            } else {
                // Pause timer
                isPaused = true
            }
        }
    }
}

// MARK: - Timer Type Button Component
struct TimerTypeButton: View {
    let timerType: TimerType
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? timerType.color.opacity(0.3) : timerType.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: timerType.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isSelected ? .white : timerType.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(timerType.rawValue)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                    
                    Text(timerDescription(for: timerType))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .white.opacity(0.6))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ? 
                            LinearGradient(
                                colors: [timerType.color.opacity(0.4), timerType.color.opacity(0.2)],
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
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? timerType.color.opacity(0.6) : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 2 : 1
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
    
    private func timerDescription(for type: TimerType) -> String {
        switch type {
        case .tabata:
            return "20s trabajo, 10s descanso"
        case .hiit:
            return "30s trabajo, 30s descanso"
        case .custom:
            return "Configura tus propios tiempos"
        }
    }
}

// MARK: - Duration Config Card Component
struct DurationConfigCard: View {
    let title: String
    @Binding var duration: Int
    let icon: String
    let color: Color
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(formatDuration(duration))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { decrementDuration() }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(duration > range.lowerBound ? .white : .white.opacity(0.3))
                }
                .disabled(duration <= range.lowerBound)
                
                Text("\(duration)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(minWidth: 60)
                    .multilineTextAlignment(.center)
                
                Button(action: { incrementDuration() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(duration < range.upperBound ? .white : .white.opacity(0.3))
                }
                .disabled(duration >= range.upperBound)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    private func incrementDuration() {
        if duration < range.upperBound {
            withAnimation(.easeInOut(duration: 0.2)) {
                if title == "Rondas" {
                    duration += 1
                } else {
                    duration += 5
                }
            }
        }
    }
    
    private func decrementDuration() {
        if duration > range.lowerBound {
            withAnimation(.easeInOut(duration: 0.2)) {
                if title == "Rondas" {
                    duration -= 1
                } else {
                    duration -= 5
                }
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        if title == "Rondas" {
            return seconds == 1 ? "1 ronda" : "\(seconds) rondas"
        } else {
            return seconds == 1 ? "1 segundo" : "\(seconds) segundos"
        }
    }
}

// MARK: - Timer Summary Item Component
struct TimerSummaryItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        TimerView()
    }
}