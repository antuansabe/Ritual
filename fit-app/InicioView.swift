import SwiftUI

// MARK: - Reusable Components
struct MetricCardView: View {
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

struct TrainingListItem: View {
    let entrenamiento: Entrenamiento
    
    private var workoutIcon: String {
        switch entrenamiento.tipo {
        case "Cardio": return "heart.circle.fill"
        case "Fuerza": return "dumbbell.fill"
        case "Flexibilidad": return "figure.flexibility"
        case "Deportes": return "sportscourt.fill"
        case "Yoga": return "figure.mind.and.body"
        case "Caminata": return "figure.walk"
        case "Ciclismo": return "bicycle"
        case "Natación": return "figure.pool.swim"
        case "Striking": return "figure.boxing"
        case "Jiu Jitsu": return "figure.martial.arts"
        default: return "figure.walk.circle.fill"
        }
    }
    
    private var workoutColor: Color {
        switch entrenamiento.tipo {
        case "Cardio": return .red
        case "Fuerza": return .blue
        case "Flexibilidad": return .green
        case "Deportes": return .orange
        case "Yoga": return .purple
        case "Caminata": return .teal
        case "Ciclismo": return .yellow
        case "Natación": return .blue
        case "Striking": return .pink
        case "Jiu Jitsu": return .indigo
        default: return .gray
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workoutIcon)
                .font(.title2)
                .foregroundColor(workoutColor)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entrenamiento.tipo)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                
                Text("\(entrenamiento.duracion) min • \(entrenamiento.duracion * 8) kcal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: entrenamiento.fecha))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(.blue)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct InicioView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    @State private var animateOnAppear = false
    @State private var showingRegistro = false
    @Namespace private var heroAnimation
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 48) {
                    headerSection
                    metricsSection
                    recentWorkoutsSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        showingRegistro = true
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 44)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingRegistro) {
            RegistroView(viewModel: viewModel)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hola, Antonio 👋")
                        .font(.title.bold())
                        .foregroundColor(.primary)
                        .opacity(animateOnAppear ? 1 : 0)
                        .offset(y: animateOnAppear ? 0 : 30)
                        .animation(.easeOut(duration: 0.8), value: animateOnAppear)
                    
                    Text("¿Qué entrenamiento harás hoy?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(animateOnAppear ? 1 : 0)
                        .offset(y: animateOnAppear ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: animateOnAppear)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Progreso")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    MetricCardView(
                        icon: "figure.walk.circle.fill",
                        value: "\(viewModel.totalWorkouts)",
                        label: "Entrenamientos",
                        color: .blue
                    )
                    .matchedGeometryEffect(id: "workouts", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "clock.fill",
                        value: "\(viewModel.totalMinutes)",
                        label: "Minutos",
                        color: .green
                    )
                    .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "flame.fill",
                        value: "\(viewModel.totalCalories)",
                        label: "Calorías",
                        color: .orange
                    )
                    .matchedGeometryEffect(id: "calories", in: heroAnimation)
                    
                    MetricCardView(
                        icon: "calendar.circle.fill",
                        value: "\(viewModel.currentStreak)",
                        label: "Racha",
                        color: .purple
                    )
                    .matchedGeometryEffect(id: "streak", in: heroAnimation)
                }
                .padding(.horizontal, 24)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(x: animateOnAppear ? 0 : -50)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateOnAppear)
        }
    }
    
    // MARK: - Recent Workouts Section
    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Entrenamientos recientes")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Spacer()
                
                if viewModel.entrenamientosOrdenados.count > 3 {
                    Button("Ver todos") {
                        // Navigate to all workouts
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
            
            if !viewModel.entrenamientosOrdenados.isEmpty {
                VStack(spacing: 12) {
                    ForEach(Array(viewModel.entrenamientosOrdenados.prefix(3).enumerated()), id: \.element.id) { index, entrenamiento in
                        TrainingListItem(entrenamiento: entrenamiento)
                            .opacity(animateOnAppear ? 1 : 0)
                            .offset(y: animateOnAppear ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(0.5 + Double(index) * 0.1), value: animateOnAppear)
                    }
                }
            } else {
                emptyStateView
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
                .opacity(0.6)
            
            VStack(spacing: 8) {
                Text("Comienza tu viaje")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text("Registra tu primer entrenamiento para comenzar a ver tu progreso")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button("Empezar ahora") {
                showingRegistro = true
            }
            .font(.subheadline.weight(.medium))
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.blue)
            )
        }
        .padding(.vertical, 60)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 40)
        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateOnAppear)
    }
}

#Preview {
    NavigationStack {
        InicioView(viewModel: EntrenamientoViewModel())
    }
    .preferredColorScheme(.dark)
}