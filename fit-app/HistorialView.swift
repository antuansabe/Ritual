import SwiftUI

struct HistorialView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var animateOnAppear = false
    
    // Datos procesados para el heatmap
    private var workoutsByDate: [String: Int] {
        var grouped: [String: Int] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for workout in viewModel.entrenamientos {
            let dateString = formatter.string(from: workout.fecha)
            grouped[dateString, default: 0] += workout.duracion
        }
        
        return grouped
    }
    
    // Estadísticas del año
    private var yearStats: (totalWorkouts: Int, totalMinutes: Int, currentStreak: Int) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let yearWorkouts = viewModel.entrenamientos.filter { 
            Calendar.current.component(.year, from: $0.fecha) == currentYear 
        }
        
        return (
            totalWorkouts: yearWorkouts.count,
            totalMinutes: yearWorkouts.reduce(0) { $0 + $1.duracion },
            currentStreak: viewModel.currentStreak
        )
    }
    
    var body: some View {
        ZStack {
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppConstants.UI.spacingXXL) {
                    headerSection
                    heatmapSection
                    legendSection
                    statsSection
                }
                .padding(.horizontal, AppConstants.UI.spacingL)
                .padding(.top, AppConstants.UI.spacingXL)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: AppConstants.Animation.entrance)) {
                animateOnAppear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            Spacer()
            
            VStack(spacing: AppConstants.UI.spacingS) {
                Text("Tu año en entrenamientos 💪")
                    .font(AppConstants.Design.headerFont)
                    .foregroundColor(.white)
                
                Text("\(Calendar.current.component(.year, from: Date()))")
                    .font(AppConstants.Design.bodyFont)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            // Espacio para balancear el botón izquierdo
            Color.clear
                .frame(width: 40, height: 40)
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -20)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Heatmap Section
    private var heatmapSection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            // Días de la semana (labels)
            weekdayLabels
            
            // Grid principal del heatmap
            contributionGrid
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Weekday Labels
    private var weekdayLabels: some View {
        HStack(spacing: 2) {
            // Espacio para los meses
            Color.clear
                .frame(width: 24)
            
            ForEach(["L", "M", "X", "J", "V", "S", "D"], id: \.self) { day in
                Text(day)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 12, height: 12)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Contribution Grid
    private var contributionGrid: some View {
        let currentYear = Calendar.current.component(.year, from: Date())
        let startOfYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
        let calendar = Calendar.current
        
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.fixed(12), spacing: 2), count: 7), spacing: 2) {
                ForEach(0..<53, id: \.self) { week in
                    ForEach(0..<7, id: \.self) { day in
                        let dayOffset = week * 7 + day
                        let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfYear)!
                        
                        if calendar.component(.year, from: currentDate) == currentYear {
                            ContributionSquare(
                                date: currentDate,
                                minutes: workoutsByDate[dateString(from: currentDate)] ?? 0
                            )
                        } else {
                            Color.clear
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
            .padding(.horizontal, AppConstants.UI.spacingL)
        }
    }
    
    // MARK: - Legend Section
    private var legendSection: some View {
        VStack(spacing: AppConstants.UI.spacingM) {
            HStack {
                Text("Menos")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 3) {
                    ForEach([0, 15, 30, 60], id: \.self) { minutes in
                        Rectangle()
                            .fill(colorForMinutes(minutes))
                            .frame(width: 12, height: 12)
                            .cornerRadius(2)
                    }
                }
                
                Text("Más")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: AppConstants.UI.spacingL) {
            Text("Estadísticas del año")
                .font(AppConstants.Design.headerFont)
                .foregroundColor(.white)
            
            HStack(spacing: AppConstants.UI.spacingL) {
                StatCard(
                    icon: "figure.walk.circle.fill",
                    value: "\(yearStats.totalWorkouts)",
                    label: "Entrenamientos",
                    color: .blue,
                    accentColor: .blue.opacity(0.2)
                )
                
                StatCard(
                    icon: "clock.fill",
                    value: "\(yearStats.totalMinutes)",
                    label: "Minutos",
                    color: .green,
                    accentColor: .green.opacity(0.2)
                )
                
                StatCard(
                    icon: "flame.fill",
                    value: "\(yearStats.currentStreak)",
                    label: "Racha actual",
                    color: .orange,
                    accentColor: .orange.opacity(0.2)
                )
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Helper Functions
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func colorForMinutes(_ minutes: Int) -> Color {
        switch minutes {
        case 0:
            return .gray.opacity(0.2)
        case 1...20:
            return .green.opacity(0.3)
        case 21...40:
            return .green.opacity(0.6)
        default:
            return .green
        }
    }
}

// MARK: - Contribution Square Component
struct ContributionSquare: View {
    let date: Date
    let minutes: Int
    @State private var isHovered = false
    
    var body: some View {
        Rectangle()
            .fill(colorForMinutes(minutes))
            .frame(width: 12, height: 12)
            .cornerRadius(2)
            .scaleEffect(isHovered ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isHovered)
            .onTapGesture {
                // Pequeña animación de feedback
                withAnimation(.easeInOut(duration: 0.1)) {
                    isHovered.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isHovered = false
                }
            }
    }
    
    private func colorForMinutes(_ minutes: Int) -> Color {
        switch minutes {
        case 0:
            return .gray.opacity(0.2)
        case 1...20:
            return .green.opacity(0.3)
        case 21...40:
            return .green.opacity(0.6)
        default:
            return .green
        }
    }
}


#Preview {
    NavigationStack {
        HistorialView(viewModel: EntrenamientoViewModel())
    }
}