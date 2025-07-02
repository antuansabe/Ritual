import SwiftUI

// MARK: - Activity Types Data
struct ActivityType {
    let name: String
    let icon: String
    let color: Color
    
    static let allTypes = [
        ActivityType(name: "Cardio", icon: "heart.circle.fill", color: .red),
        ActivityType(name: "Fuerza", icon: "dumbbell.fill", color: .blue),
        ActivityType(name: "Flexibilidad", icon: "figure.flexibility", color: .green),
        ActivityType(name: "Deportes", icon: "sportscourt.fill", color: .orange),
        ActivityType(name: "Yoga", icon: "figure.mind.and.body", color: .purple),
        ActivityType(name: "Caminata", icon: "figure.walk", color: .teal),
        ActivityType(name: "Ciclismo", icon: "bicycle", color: .yellow),
        ActivityType(name: "Natación", icon: "figure.pool.swim", color: .blue),
        ActivityType(name: "Striking", icon: "figure.boxing", color: .pink),
        ActivityType(name: "Jiu Jitsu", icon: "figure.martial.arts", color: .indigo)
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
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : color)
                    .frame(width: 40, height: 40)
                
                Text(type)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color : Color(.systemGray6).opacity(0.3))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Summary Metric Card Component
struct SummaryMetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title.bold())
                    .foregroundColor(.primary)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 120, height: 120)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct RegistroView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tipoSeleccionado = "Cardio"
    @State private var duracion = ""
    @State private var animateOnAppear = false
    @State private var showSuccess = false
    @Namespace private var heroAnimation
    
    var isFormValid: Bool {
        !duracion.isEmpty && Int(duracion) != nil && Int(duracion)! > 0
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 40) {
                        workoutTypeSection
                        durationSection
                        summarySection
                    }
                    .padding(.horizontal, 24)
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
        .overlay(successOverlay)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
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
        VStack(alignment: .leading, spacing: 24) {
            Text("Selecciona tu actividad")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: animateOnAppear)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
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
        }
    }
    
    // MARK: - Duration Section
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Duración del entrenamiento")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
            
            VStack(spacing: 20) {
                HStack(spacing: 8) {
                    TextField("0", text: $duracion)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 120)
                    
                    Text("minutos")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 24)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                
                quickDurationButtons
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.5), value: animateOnAppear)
        }
    }
    
    // MARK: - Quick Duration Buttons
    private var quickDurationButtons: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duraciones comunes")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach([15, 30, 45, 60], id: \.self) { minutes in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            duracion = "\(minutes)"
                        }
                    }) {
                        Text("\(minutes)")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(duracion == "\(minutes)" ? .white : .secondary)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(duracion == "\(minutes)" ? .blue : .gray.opacity(0.2))
                            )
                    }
                    .animation(.easeInOut(duration: 0.2), value: duracion == "\(minutes)")
                }
            }
        }
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Resumen")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
            
            HStack(spacing: 16) {
                SummaryMetricCard(
                    icon: "clock.fill",
                    value: duracion.isEmpty ? "0" : duracion,
                    label: "Minutos",
                    color: .blue
                )
                .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                
                SummaryMetricCard(
                    icon: "flame.fill",
                    value: duracion.isEmpty ? "0" : "\((Int(duracion) ?? 0) * 8)",
                    label: "Calorías",
                    color: .orange
                )
                .matchedGeometryEffect(id: "calories", in: heroAnimation)
            }
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
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    
                    Text("Guardar Entrenamiento")
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
            .disabled(!isFormValid)
            
            Button("Cancelar", action: { dismiss() })
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
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
    
    // MARK: - Success Overlay
    private var successOverlay: some View {
        Group {
            if showSuccess {
                ZStack {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        VStack(spacing: 8) {
                            Text("¡Entrenamiento Guardado!")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                            
                            Text("¡Sigue así y alcanza tus metas!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(40)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                    .scaleEffect(showSuccess ? 1 : 0.8)
                    .opacity(showSuccess ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccess)
                }
            }
        }
    }
    
    // MARK: - Save Function
    private func saveWorkout() {
        guard isFormValid, let duracionInt = Int(duracion) else { return }
        
        viewModel.agregarEntrenamiento(tipo: tipoSeleccionado, duracion: duracionInt)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showSuccess = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            dismiss()
        }
    }
}

#Preview {
    RegistroView(viewModel: EntrenamientoViewModel())
        .preferredColorScheme(.dark)
}