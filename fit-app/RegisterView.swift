import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = false
    @State private var animateOnAppear = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 32) {
                        titleSection
                        formSection
                        buttonSection
                        footerSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
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
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(AppConstants.Design.blue)
                .opacity(animateOnAppear ? 1 : 0)
                .scaleEffect(animateOnAppear ? 1 : 0.5)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateOnAppear)
            
            VStack(spacing: 8) {
                Text("Crear Cuenta")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Regístrate para comenzar tu viaje fitness")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateOnAppear)
        }
        .padding(.top, 20)
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
                
                SecureField("Crea una contraseña", text: $authViewModel.password)
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
                    .textContentType(.newPassword)
            }
            
            // Confirm Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirmar Contraseña")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                SecureField("Confirma tu contraseña", text: $authViewModel.confirmPassword)
                    .font(.system(size: 16))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.cardBackground())
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(passwordsMatch ? AnyShapeStyle(AppConstants.Design.cardBorder()) : AnyShapeStyle(Color.red.opacity(0.6)), lineWidth: AppConstants.UI.borderWidth)
                            )
                    )
                    .foregroundColor(.white)
                    .textContentType(.newPassword)
            }
            
            // Password Requirements
            if !authViewModel.password.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: authViewModel.password.count >= 6 ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(authViewModel.password.count >= 6 ? .green : .white.opacity(0.5))
                        Text("Al menos 6 caracteres")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(authViewModel.password.count >= 6 ? .green : .white.opacity(0.7))
                    }
                    
                    if !authViewModel.confirmPassword.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordsMatch ? .green : .white.opacity(0.5))
                            Text("Las contraseñas coinciden")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(passwordsMatch ? .green : .white.opacity(0.7))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        Button(action: {
            authViewModel.register()
        }) {
            Text("Registrarse")
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
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateOnAppear)
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        Button(action: {
            showLogin = true
        }) {
            HStack(spacing: 4) {
                Text("¿Ya tienes cuenta?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Inicia sesión")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Design.blue)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: animateOnAppear)
    }
    
    // MARK: - Computed Properties
    private var passwordsMatch: Bool {
        !authViewModel.confirmPassword.isEmpty && authViewModel.password == authViewModel.confirmPassword
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}