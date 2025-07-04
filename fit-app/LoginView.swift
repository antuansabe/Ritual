import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showRegister = false
    @State private var animateOnAppear = false
    
    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            AppConstants.Design.backgroundGradient
                .opacity(0.7)
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
        VStack(spacing: 32) {
            // Elemento geométrico moderno y minimalista
            ZStack {
                // Círculo exterior con gradiente sutil
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [AppConstants.Design.lavender.opacity(0.3), AppConstants.Design.electricBlue.opacity(0.2), AppConstants.Design.softPurple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 100, height: 100)
                
                // Círculo medio
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 70, height: 70)
                
                // Ícono central moderno y sutil
                Image(systemName: "lock.shield")
                    .font(.system(size: 24, weight: .ultraLight))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppConstants.Design.moonlight.opacity(0.9), AppConstants.Design.electricBlue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(animateOnAppear ? 1 : 0)
            .scaleEffect(animateOnAppear ? 1 : 0.8)
            .rotationEffect(.degrees(animateOnAppear ? 0 : -90))
            .animation(.spring(response: 1.2, dampingFraction: 0.8), value: animateOnAppear)
            
            VStack(spacing: 16) {
                Text("Bienvenido")
                    .font(.system(size: 34, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .kerning(2)
                
                // Línea decorativa sutil
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.6), AppConstants.Design.electricBlue.opacity(0.4), AppConstants.Design.softPurple.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: animateOnAppear ? 60 : 0, height: 1.5)
                    .cornerRadius(1)
                    .animation(.easeInOut(duration: 1.0).delay(0.6), value: animateOnAppear)
                
                Text("Inicia sesión para continuar")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(0.8)
            }
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 1.0).delay(0.4), value: animateOnAppear)
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
                
                SecureField("Ingresa tu contraseña", text: $authViewModel.password)
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
                            .fill(AppConstants.Design.modernButtonGradient)
                    )
                    .shadow(color: AppConstants.Design.electricBlue.opacity(0.4), radius: 12, x: 0, y: 6)
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
                    .foregroundColor(AppConstants.Design.electricBlue)
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