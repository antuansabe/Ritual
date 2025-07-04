import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = false
    @State private var animateOnAppear = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image("registroBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            AppConstants.Design.backgroundGradient
                .opacity(0.7)
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
        VStack(spacing: 32) {
            // Elemento visual elegante con puntos animados
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.Design.lavender.opacity(0.8), AppConstants.Design.electricBlue.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 8, height: 8)
                        .opacity(animateOnAppear ? 1 : 0)
                        .scaleEffect(animateOnAppear ? 1 : 0.3)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(Double(index) * 0.2), value: animateOnAppear)
                }
            }
            .opacity(animateOnAppear ? 1 : 0)
            .animation(.easeInOut(duration: 0.8).delay(0.1), value: animateOnAppear)
            
            VStack(spacing: 20) {
                Text("Crear Cuenta")
                    .font(.system(size: 34, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .kerning(2)
                
                // Línea decorativa que se expande
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.5), AppConstants.Design.softPurple.opacity(0.4), AppConstants.Design.electricBlue.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: animateOnAppear ? 80 : 0, height: 1.5)
                    .cornerRadius(1)
                    .animation(.easeInOut(duration: 1.2).delay(0.5), value: animateOnAppear)
                
                Text("Regístrate para comenzar tu viaje fitness")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .tracking(0.5)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 1.0).delay(0.3), value: animateOnAppear)
        }
        .padding(.top, 40)
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
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.fieldGradient)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
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
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.fieldGradient)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
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
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                            .fill(AppConstants.Design.fieldGradient)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadiusL)
                                    .stroke(
                                        passwordsMatch ? 
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.2), AppConstants.Design.electricBlue.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color.red.opacity(0.6), Color.red.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
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
                            .foregroundColor(authViewModel.password.count >= 6 ? AppConstants.Design.electricBlue : .white.opacity(0.4))
                            .font(.system(size: 12))
                        Text("Al menos 6 caracteres")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(authViewModel.password.count >= 6 ? AppConstants.Design.electricBlue : .white.opacity(0.6))
                    }
                    
                    if !authViewModel.confirmPassword.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordsMatch ? AppConstants.Design.electricBlue : .white.opacity(0.4))
                                .font(.system(size: 12))
                            Text("Las contraseñas coinciden")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(passwordsMatch ? AppConstants.Design.electricBlue : .white.opacity(0.6))
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
                        .fill(AppConstants.Design.modernButtonGradient)
                )
                .shadow(color: AppConstants.Design.electricBlue.opacity(0.4), radius: 12, x: 0, y: 6)
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
                    .foregroundColor(AppConstants.Design.electricBlue)
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