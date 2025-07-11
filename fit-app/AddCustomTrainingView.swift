import SwiftUI

// MARK: - Custom Training Model
struct Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
    let category: String
    let dateCreated: Date
    
    init(name: String, iconName: String, category: String = "Personalizado") {
        self.name = name
        self.iconName = iconName
        self.category = category
        self.dateCreated = Date()
    }
}

// MARK: - Custom Training Manager
class MquKYa6zIelLCz6Z4AhDl5XrdYZqIIR1: ObservableObject {
    @Published var zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW: [Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD] = []
    private let HjnTcQQd1UpvO7YKonsSenkkDkxebyDv = "customTrainings"
    private let HKIYyG5h1qWkKJgBGidoQtxq6wgL0DQx = 4
    
    init() {
        ki4ZXPi1Z2byEqa78QRCbEZU2s1bIsYN()
    }
    
    func tatAVl0SfmOnpZgUZu9SsCCdbzyQBfqs(_ training: Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD) -> Bool {
        guard zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.count < HKIYyG5h1qWkKJgBGidoQtxq6wgL0DQx else { return false }
        zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.append(training)
        J1R4QiEXiI9hT7p5bHqUG09dRFLAPj3M()
        return true
    }
    
    func Q6TViouC2E7V78xd81Ta8gTk6xvC5rB8(_ training: Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD) {
        zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.removeAll { $0.id == training.id }
        J1R4QiEXiI9hT7p5bHqUG09dRFLAPj3M()
    }
    
    func PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() -> Bool {
        return zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.count < HKIYyG5h1qWkKJgBGidoQtxq6wgL0DQx
    }
    
    func Zod5aZfh5sFHKxjgRq8HNiYMJy0IC2yH() -> Int {
        return HKIYyG5h1qWkKJgBGidoQtxq6wgL0DQx - zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.count
    }
    
    private func ki4ZXPi1Z2byEqa78QRCbEZU2s1bIsYN() {
        if let data = UserDefaults.standard.data(forKey: HjnTcQQd1UpvO7YKonsSenkkDkxebyDv),
           let trainings = try? JSONDecoder().decode([Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD].self, from: data) {
            zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW = trainings
        }
    }
    
    private func J1R4QiEXiI9hT7p5bHqUG09dRFLAPj3M() {
        if let data = try? JSONEncoder().encode(zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW) {
            UserDefaults.standard.set(data, forKey: HjnTcQQd1UpvO7YKonsSenkkDkxebyDv)
        }
    }
}

// MARK: - Add Custom Training View
struct JwEMHAOLFU3QoFmE4JdeO2opAnNjRZ5X: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var customTrainingManager: MquKYa6zIelLCz6Z4AhDl5XrdYZqIIR1
    @State private var trainingName: String = ""
    @State private var selectedIcon: String = "figure.run"
    @State private var animateOnAppear = false
    @State private var nameError: String? = nil
    
    private let validator = VknfqtmwStiiWr4ox76LjSmWY9bPAg8Z.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Available SF Symbols for training activities
    private let availableIcons = [
        "figure.run", "figure.walk", "bicycle", "figure.pool.swim",
        "dumbbell.fill", "figure.yoga",
        "figure.dance", "figure.boxing", "figure.climbing",
        "figure.tennis", "figure.basketball", "figure.soccer",
        "figure.volleyball", "figure.badminton", "figure.skating",
        "figure.snowboarding", "figure.surfing", "figure.sailing",
        "dumbbell", "heart.circle.fill", "flame.fill", "bolt.fill"
    ]
    
    var body: some View {
        ZStack {
            // Background
            Image("registroBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
                .opacity(0.7)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    nameInputSection
                    iconSelectionSection
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
            if showSuccess {
                TGRfER7VLrGaK4NE9LQ4uRaPaeJjDY0v()
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
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
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("Crear Entrenamiento")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Personaliza tu actividad favorita")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                
                // Remaining slots indicator
                if !customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() {
                    Text("Máximo de entrenamientos alcanzado (4/4)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.orange.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.orange.opacity(0.4), lineWidth: 1)
                                )
                        )
                } else {
                    let remaining = customTrainingManager.Zod5aZfh5sFHKxjgRq8HNiYMJy0IC2yH()
                    Text("Puedes crear \(remaining) entrenamiento\(remaining == 1 ? "" : "s") más")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.green.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.green.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -30)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Name Input Section
    private var nameInputSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Nombre del entrenamiento")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 16) {
                TextField("Ej: Escalada, Crossfit, Pilates", text: $trainingName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        nameError != nil ? Color.red.opacity(0.8) : pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), 
                                        lineWidth: nameError != nil ? 3 : 2
                                    )
                            )
                    )
                    .onChange(of: trainingName) { _ in
                        ZVJEf5dJ8Kj5mw77v0bEfB96bWRUDQQ2()
                    }
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                // Training name error message
                if let nameError = nameError {
                    HStack {
                        Text(nameError)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red.opacity(0.9))
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                HStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Dale un nombre único y descriptivo")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
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
    
    // MARK: - Icon Selection Section
    private var iconSelectionSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Selecciona un ícono")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 20) {
                // Preview of selected icon
                VStack(spacing: 12) {
                    Text("Vista previa")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), radius: 12, x: 0, y: 6)
                        
                        Image(systemName: selectedIcon)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(trainingName.isEmpty ? "Tu entrenamiento" : trainingName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
                
                // Icon grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(availableIcons, id: \.self) { iconName in
                        b9qXfg0ZVc9dNTSmRxuPhyGDjFiNg85h(
                            iconName: iconName,
                            isSelected: selectedIcon == iconName,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedIcon = iconName
                                }
                            }
                        )
                    }
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
    
    // MARK: - Save Button Section
    private var saveButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: nC2RwCpTNuS4cFHBteSRn9oBLg1rXC9o) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Crear Entrenamiento")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            dc5HT7nwriNcXlnyUwYH6d1CBkoY2CqE() && customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() ?
                                pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.BRZumEEKLDNhpWlIssXSSHs7tRJDkiWk :
                                LinearGradient(colors: [.gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .shadow(color: dc5HT7nwriNcXlnyUwYH6d1CBkoY2CqE() && customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr.opacity(0.4) : .clear,
                       radius: 10, x: 0, y: 5)
            }
            .disabled(!dc5HT7nwriNcXlnyUwYH6d1CBkoY2CqE() || !customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu())
            
            Text("El entrenamiento aparecerá en tu lista de actividades")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Helper Functions
    
    private func ZVJEf5dJ8Kj5mw77v0bEfB96bWRUDQQ2() {
        let result = validator.yQTfzeSq7UapiEXhlhx81yO5cHtgXaYD(trainingName)
        withAnimation(.easeInOut(duration: 0.3)) {
            nameError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func dc5HT7nwriNcXlnyUwYH6d1CBkoY2CqE() -> Bool {
        let result = validator.yQTfzeSq7UapiEXhlhx81yO5cHtgXaYD(trainingName)
        return result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP
    }
    
    private func nC2RwCpTNuS4cFHBteSRn9oBLg1rXC9o() {
        // Validate first
        let validationResult = validator.yQTfzeSq7UapiEXhlhx81yO5cHtgXaYD(trainingName)
        guard validationResult.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP else {
            nameError = validationResult.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
            errorMessage = validationResult.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy ?? "Nombre de entrenamiento inválido"
            showError = true
            return
        }
        
        // Sanitize the input
        let sanitizedName = validator.S1FcBW204dzhY83hyyJGO8udFCyY9l66(trainingName)
        
        // Clear any errors
        nameError = nil
        
        guard customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() else {
            errorMessage = "Ya tienes el máximo de entrenamientos personalizados (4)"
            showError = true
            return
        }
        
        // Check for duplicate names
        if customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.contains(where: { $0.name.lowercased() == sanitizedName.lowercased() }) {
            errorMessage = "Ya existe un entrenamiento con ese nombre"
            showError = true
            return
        }
        
        let newTraining = Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD(name: sanitizedName, iconName: selectedIcon)
        
        if customTrainingManager.tatAVl0SfmOnpZgUZu9SsCCdbzyQBfqs(newTraining) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showSuccess = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        } else {
            errorMessage = "No se pudo crear el entrenamiento"
            showError = true
        }
    }
}

// MARK: - Icon Selection Button Component
struct b9qXfg0ZVc9dNTSmRxuPhyGDjFiNg85h: View {
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
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
                    .frame(width: 60, height: 60)
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
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
                
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 0.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel("Ícono \(iconName)")
        .accessibilityHint("Toca para seleccionar este ícono")
        .accessibilityValue(isSelected ? "Seleccionado" : "No seleccionado")
    }
}

// MARK: - Success Overlay View
struct TGRfER7VLrGaK4NE9LQ4uRaPaeJjDY0v: View {
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
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                VStack(spacing: 12) {
                    Text("¡Entrenamiento Creado!")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Ya puedes usarlo al registrar")
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

#Preview {
    NavigationStack {
        JwEMHAOLFU3QoFmE4JdeO2opAnNjRZ5X()
            .environmentObject(MquKYa6zIelLCz6Z4AhDl5XrdYZqIIR1())
    }
}