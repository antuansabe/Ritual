import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showRegister = false
    @State private var animateOnAppear = false
    
    var body: some View {
        ZStack {
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    formSection
                    buttonSection
                    footerSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
        .alert("Error", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("OK") {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(authViewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppConstants.Design.blue)
                .opacity(animateOnAppear ? 1 : 0)
                .scaleEffect(animateOnAppear ? 1 : 0.5)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateOnAppear)
            
            VStack(spacing: 8) {
                Text("Bienvenido")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Inicia sesión para continuar")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                TextField("Ingresa tu email", text: $authViewModel.email)
                    .font(.system(size: 16))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.cardBackground())
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                            )
                    )
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Contraseña")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                SecureField("Ingresa tu contraseña", text: $authViewModel.password)
                    .font(.system(size: 16))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.cardBackground())
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(AppConstants.Design.cardBorder(), lineWidth: AppConstants.UI.borderWidth)
                            )
                    )
                    .foregroundColor(.white)
                    .textContentType(.password)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        VStack(spacing: 16) {
            // Login Button
            Button(action: {
                authViewModel.login()
            }) {
                Text("Iniciar sesión")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.primaryButtonGradient)
                    )
                    .shadow(color: AppConstants.Design.blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        Button(action: {
            showRegister = true
        }) {
            HStack(spacing: 4) {
                Text("¿No tienes cuenta?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Regístrate")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Design.blue)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: animateOnAppear)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}