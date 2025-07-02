import SwiftUI

struct PerfilView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    avatarSection
                    metricsSection
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        Text("Tu Perfil")
            .font(.largeTitle.bold())
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 120))
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 140)
                )
            
            Text("Antonio Dromundo")
                .font(.title2.bold())
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estadísticas")
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                ProfileMetricCard(
                    icon: "figure.walk.circle.fill",
                    value: "0",
                    title: "Entrenamientos",
                    color: .blue
                )
                
                ProfileMetricCard(
                    icon: "clock.fill",
                    value: "0",
                    title: "Minutos",
                    color: .green
                )
                
                ProfileMetricCard(
                    icon: "flame.fill",
                    value: "0",
                    title: "Calorías",
                    color: .orange
                )
            }
        }
    }
}

// MARK: - Profile Metric Card Component
struct ProfileMetricCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title.bold())
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        PerfilView()
    }
    .preferredColorScheme(.dark)
}