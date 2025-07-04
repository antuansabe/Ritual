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

// MARK: - Modern Workout Type Button Component
struct ModernWorkoutTypeButton: View {
    let type: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.3) : color.opacity(0.15))
                        .frame(width: 60, height: 60)
                        .shadow(color: isSelected ? color.opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(isSelected ? .white : color)
                        .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 0.5)
                }
                
                Text(type)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: isSelected ? .black.opacity(0.2) : .clear, radius: 1, x: 0, y: 0.5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                    .fill(isSelected ? 
                        LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .stroke(isSelected ? color.opacity(0.5) : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
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
                ZStack {
                    Circle()
                        .fill(AppConstants.Design.green.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: icon)
                        .font(.system(size: 48))
                        .foregroundColor(AppConstants.Design.green)
                }
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(AppConstants.Design.subheaderFont)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(AppConstants.Design.captionFont)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 280, height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppConstants.Design.cardBackground(true))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                    )
            )
            .shadow(color: AppConstants.Design.cardShadow(), radius: 10)
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
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
            ZStack {
                Circle()
                    .fill(tint.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(tint)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                    .accessibilityLabel("\(value) \(label)")
                
                Text(label)
                    .font(AppConstants.Design.footnoteFont)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                .fill(AppConstants.Design.cardBackground())
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                )
        )
        .shadow(color: AppConstants.Design.cardShadow(), radius: AppConstants.UI.shadowRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct RegistroView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @ObservedObject private var offlineManager = OfflineManager.shared
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Binding var selectedTab: Int
    
    @State private var tipoSeleccionado = "Cardio"
    @State private var duracion = ""
    @State private var animateOnAppear = false
    @State private var showSuccessOverlay = false
    @Namespace private var heroAnimation
    
    // Button press state for save button animation
    @State private var isSaveButtonPressed = false
    
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
            Image("historialBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            AppConstants.Design.backgroundGradient
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Network status banner
                NetworkStatusBanner()
                
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
            OverlaySuccessView(
                title: "¡Entrenamiento guardado!",
                subtitle: "Sigue así y alcanza tus metas",
                isVisible: $showSuccessOverlay
            )
            .opacity(showSuccessOverlay ? 1 : 0)
            .allowsHitTesting(showSuccessOverlay)
        }
        .onChange(of: workoutViewModel.showSuccess) { success in
            if success {
                showSuccessOverlay = true
            }
        }
        .alert("Error", isPresented: .constant(workoutViewModel.errorMessage != nil)) {
            Button("OK") {
                workoutViewModel.clearError()
            }
        } message: {
            Text(workoutViewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {            
            Spacer()
            
            Text("Nuevo Entrenamiento")
                .font(AppConstants.Design.headerFont)
                .foregroundColor(.white)
            
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
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(Array(ActivityType.allTypes.enumerated()), id: \.offset) { index, activityType in
                    ModernWorkoutTypeButton(
                        type: activityType.name,
                        icon: activityType.icon,
                        color: activityType.color,
                        isSelected: tipoSeleccionado == activityType.name
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    TextField("0", text: $duracion)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 120)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    
                    Text("minutos")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                        .fill(AppConstants.Design.cardBackground(true))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        )
                )
                .shadow(color: AppConstants.Design.cardShadow(), radius: 8, x: 0, y: 4)
                
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
                .font(AppConstants.Design.footnoteFont)
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach([15, 30, 45, 60, 90, 120], id: \.self) { minutes in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            duracion = "\(minutes)"
                        }
                    }) {
                        Text("\(minutes)")
                            .font(AppConstants.Design.captionFont)
                            .foregroundColor(duracion == "\(minutes)" ? .white : .white.opacity(0.8))
                            .frame(height: AppConstants.UI.minTouchTarget)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusS)
                                    .fill(duracion == "\(minutes)" ? AnyShapeStyle(AppConstants.Design.blue) : AnyShapeStyle(AppConstants.Design.cardBackground()))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusS)
                                            .stroke(duracion == "\(minutes)" ? AnyShapeStyle(AppConstants.Design.blue.opacity(0.3)) : AnyShapeStyle(AppConstants.Design.cardBorder()), lineWidth: AppConstants.UI.borderWidth)
                                    )
                            )
                            .shadow(color: duracion == "\(minutes)" ? AppConstants.Design.blue.opacity(0.3) : .clear, radius: 2)
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
                    .font(AppConstants.Design.subheaderFont)
                    .foregroundColor(.white)
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
                HStack(spacing: 12) {
                    if workoutViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(workoutViewModel.isLoading ? "Guardando..." : "Guardar Entrenamiento")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isFormValid ? 
                            LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .shadow(color: isFormValid ? Color.green.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                .scaleEffect(isSaveButtonPressed ? 0.95 : (isFormValid ? 1.0 : 0.98))
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSaveButtonPressed)
            }
            .disabled(!isFormValid || workoutViewModel.isLoading)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isSaveButtonPressed = pressing
            }, perform: {})
            
            Button("Limpiar campos") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    tipoSeleccionado = "Cardio"
                    duracion = ""
                }
            }
            .font(AppConstants.Design.captionFont)
            .foregroundColor(.white.opacity(0.6))
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
            let calories = Int32(AppConstants.calculateCalories(for: validDuration))
            
            // Use basic Core Data saving with offline capability built into CloudKit
            Task {
                await workoutViewModel.saveWorkout(
                    type: tipoSeleccionado,
                    duration: validDuration,
                    managedObjectContext: managedObjectContext
                )
                
                // Handle success state on main actor
                await MainActor.run {
                    if workoutViewModel.showSuccess {
                        // Enhanced logging for offline detection
                        print("🏃‍♂️ Entrenamiento guardado - CloudKit manejará sync automáticamente")
                        print("📊 Tipo: \(tipoSeleccionado), Duración: \(validDuration) min")
                        print("💾 Core Data + CloudKit: Funciona offline y sync cuando hay red")
                        
                        // Show success overlay
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSuccessOverlay = true
                        }
                        
                        // Reset form fields after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            tipoSeleccionado = "Cardio"
                            duracion = ""
                        }
                        
                        // Navigate back to home tab after overlay disappears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = 0
                            }
                        }
                    }
                }
            }
            
        case .failure(let error):
            workoutViewModel.errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    RegistroView(selectedTab: .constant(1))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}