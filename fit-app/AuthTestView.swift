import SwiftUI

struct AuthTestView: View {
    @State private var showLogin = false
    @State private var showRegister = false
    
    var body: some View {
        ZStack {
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("Test de Autenticación")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    Button("Mostrar Login") {
                        showLogin = true
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.primaryButtonGradient)
                    )
                    
                    Button("Mostrar Register") {
                        showRegister = true
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(LinearGradient(
                                colors: [Color.green, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
                .environmentObject(AuthViewModel())
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .environmentObject(AuthViewModel())
        }
    }
}

#Preview {
    AuthTestView()
}