import SwiftUI

// MARK: - Activity Types Data
struct ActivityType {
    let name: String
    let icon: String
    let color: Color
    
    static let allTypes = [
        ActivityType(name: "Cardio", icon: "heart.circle.fill", color: .red),
        ActivityType(name: "Fuerza", icon: "dumbbell.fill", color: .blue),
        ActivityType(name: "Yoga", icon: "figure.mind.and.body", color: .purple),
        ActivityType(name: "Caminata", icon: "figure.walk", color: .green),
        ActivityType(name: "Ciclismo", icon: "bicycle", color: .yellow),
        ActivityType(name: "Natación", icon: "figure.pool.swim", color: .cyan),
        ActivityType(name: "Striking", icon: "figure.boxing", color: .red),
        ActivityType(name: "Jiu Jitsu", icon: "figure.martial.arts", color: .purple)
    ]
}

// MARK: - Training Type Button Component
struct TrainingTypeButton: View {
    let type: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : color)
                    .frame(width: 32, height: 32)
                    .accessibilityHidden(true)
                
                Text(type)
                    .font(.caption.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppConstants.UI.activityButtonHeight)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusM)
                    .fill(isSelected ? color : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .accessibilityLabel(type)
        .accessibilityHint(isSelected ? "Currently selected activity type" : "Tap to select \(type) as activity type")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

// MARK: - Success Modal Component
struct SuccessModalView: View {
    let title: String
    let message: String
    let icon: String
    let isVisible: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.3), value: isVisible)
            
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(.green)
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 280, height: 180)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .transition(.scale.combined(with: .opacity))
            .animation(.easeOut(duration: 0.3), value: isVisible)
        }
        .zIndex(2)
    }
}

// MARK: - Summary Metric Card Component
struct SummaryMetricCard: View {
    let icon: String
    let value: String
    let label: String
    let tint: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
                .frame(width: 32, height: 32)
                .accessibilityHidden(true)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title.bold())
                    .foregroundColor(.primary)
                    .accessibilityLabel("\(value) \(label)")
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 8)
        .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct RegistroView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    
    @State private var tipoSeleccionado = "Cardio"
    @State private var duracion = ""
    @State private var animateOnAppear = false
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    @Namespace private var heroAnimation
    
    var isFormValid: Bool {
        switch AppConstants.validateWorkoutDuration(duracion) {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 32) {
                        workoutTypeSection
                        durationSection
                        summarySection
                    }
                    .padding(.bottom, 140)
                }
                
                bottomActionSection
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .overlay {
            if showSuccess {
                SuccessModalView(
                    title: "¡Entrenamiento Guardado!",
                    message: "¡Sigue así y alcanza tus metas!",
                    icon: "checkmark.circle.fill",
                    isVisible: showSuccess
                )
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {            
            Spacer()
            
            Text("Nuevo Entrenamiento")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: saveWorkout) {
                Image(systemName: "checkmark")
                    .font(.title3)
                    .foregroundColor(isFormValid ? .green : .secondary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isFormValid ? .green.opacity(0.2) : .gray.opacity(0.1))
                    )
            }
            .disabled(!isFormValid)
            .animation(.easeInOut(duration: 0.2), value: isFormValid)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -30)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Workout Type Section
    private var workoutTypeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Selecciona tu actividad")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(ActivityType.allTypes.enumerated()), id: \.offset) { index, activityType in
                    TrainingTypeButton(
                        type: activityType.name,
                        icon: activityType.icon,
                        color: activityType.color,
                        isSelected: tipoSeleccionado == activityType.name
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            tipoSeleccionado = activityType.name
                        }
                    }
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 30)
                    .animation(.easeOut(duration: 0.5).delay(0.2 + Double(index) * 0.05), value: animateOnAppear)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Duration Section
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Duración del entrenamiento")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    TextField("0", text: $duracion)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 100)
                    
                    Text("minutos")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                quickDurationButtons
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.5), value: animateOnAppear)
        }
    }
    
    // MARK: - Quick Duration Buttons
    private var quickDurationButtons: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duraciones comunes")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach([15, 30, 45, 60, 90, 120], id: \.self) { minutes in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            duracion = "\(minutes)"
                        }
                    }) {
                        Text("\(minutes)")
                            .font(.caption.weight(.medium))
                            .foregroundColor(duracion == "\(minutes)" ? .white : .secondary)
                            .frame(height: AppConstants.UI.minTouchTarget)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusS)
                                    .fill(duracion == "\(minutes)" ? .blue : Color(.systemGray6))
                            )
                    }
                    .animation(.easeInOut(duration: 0.2), value: duracion == "\(minutes)")
                }
            }
        }
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Resumen")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 12) {
                SummaryMetricCard(
                    icon: "clock.fill",
                    value: duracion.isEmpty ? "0" : duracion,
                    label: "Minutos",
                    tint: .blue
                )
                .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                
                SummaryMetricCard(
                    icon: "flame.fill",
                    value: duracion.isEmpty ? "0" : "\(AppConstants.calculateCalories(for: Int(duracion) ?? 0))",
                    label: "Calorías",
                    tint: .orange
                )
                .matchedGeometryEffect(id: "calories", in: heroAnimation)
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.7), value: animateOnAppear)
        }
    }
    
    // MARK: - Bottom Action Section
    private var bottomActionSection: some View {
        VStack(spacing: 16) {
            Button(action: saveWorkout) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    
                    Text(viewModel.isLoading ? "Guardando..." : "Guardar Entrenamiento")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(isFormValid ? .blue : .gray.opacity(0.3))
                )
                .scaleEffect(isFormValid ? 1.0 : 0.98)
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
            }
            .disabled(!isFormValid || viewModel.isLoading)
            
            Button("Limpiar campos") {
                tipoSeleccionado = "Cardio"
                duracion = ""
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 50)
        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateOnAppear)
    }
    
    
    // MARK: - Save Function
    private func saveWorkout() {
        let validationResult = AppConstants.validateWorkoutDuration(duracion)
        
        switch validationResult {
        case .success(let validDuration):
            Task {
                await viewModel.agregarEntrenamiento(tipo: tipoSeleccionado, duracion: validDuration)
                
                await MainActor.run {
                    if let error = viewModel.errorMessage {
                        errorMessage = error
                        showError = true
                        viewModel.clearError()
                    } else {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showSuccess = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            // Clear form after successful save
                            tipoSeleccionado = "Cardio"
                            duracion = ""
                        }
                    }
                }
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    RegistroView(viewModel: EntrenamientoViewModel())
}