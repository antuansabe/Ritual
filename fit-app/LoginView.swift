import SwiftUI

struct wdJa7hhtRa6I67ei2Mi07KjELvqym68b: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @State private var showRegister = false
    @State private var animateOnAppear = false
    
    // Validation states
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var showValidationAlert = false
    
    private let validator = VknfqtmwStiiWr4ox76LjSmWY9bPAg8Z.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .sheet(isPresented: $showRegister) {
            B4qvsC5G8P17ox009Aj1FnUDwHQ5CAhI()
        }
        .alert("Error", isPresented: .constant(authViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy != nil)) {
            Button("OK") {
                authViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
            }
        } message: {
            Text(authViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy ?? "")
        }
        .alert("Datos inválidos", isPresented: $showValidationAlert) {
            Button("OK") {
                showValidationAlert = false
            }
        } message: {
            Text("Por favor corrige los errores en el formulario antes de continuar.")
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
                            colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.3), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.1)],
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
                
                // Ícono central fitness y motivacional
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.pfmjowVfLLdwmIFvy86thx6YHe6khrWx.opacity(0.9), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.7)],
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
                            colors: [Color.white.opacity(0.6), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.3)],
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
                
                TextField("Ingresa tu email", text: $authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I)
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.x8kMOs8TbaTU9EZVNGGkCbO7acJpUphq)
                            .overlay(
                                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                    .stroke(
                                        emailError != nil ? 
                                        AnyShapeStyle(Color.red.opacity(0.6)) :
                                        AnyShapeStyle(LinearGradient(
                                            colors: [Color.white.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )),
                                        lineWidth: emailError != nil ? 2 : 1
                                    )
                            )
                    )
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I) { _ in
                        PmcnDieiMpTJdUDVL1bgJXXbX20tU8RQ()
                    }
                
                // Email error message
                if let emailError = emailError {
                    Text(emailError)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.leading, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Contraseña")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                SecureField("Ingresa tu contraseña", text: $authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ)
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.x8kMOs8TbaTU9EZVNGGkCbO7acJpUphq)
                            .overlay(
                                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                    .stroke(
                                        passwordError != nil ? 
                                        AnyShapeStyle(Color.red.opacity(0.6)) :
                                        AnyShapeStyle(LinearGradient(
                                            colors: [Color.white.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )),
                                        lineWidth: passwordError != nil ? 2 : 1
                                    )
                            )
                    )
                    .foregroundColor(.white)
                    .textContentType(.password)
                    .onChange(of: authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ) { _ in
                        Jr8IrZxnLXIww95wVuts9j6hkJooTSlI()
                    }
                
                // Password error message
                if let passwordError = passwordError {
                    Text(passwordError)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.leading, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateOnAppear)
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        VStack(spacing: 16) {
            // Login Button with Rate Limiting
            Button(action: {
                Qq7wTS0MGfKn6IkznCQ5hEYbBDUgHQDm()
            }) {
                HStack {
                    if authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Text(authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH ? 
                         "Bloqueado (\(authViewModel.I0yXhmBO3RN418RpUxebkiSB9wa2n5cz)s)" : 
                         "Iniciar sesión")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .fill(authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH ? 
                              LinearGradient(
                                colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                              ) :
                              pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.Jaqu2AaPnNe3jLsCKOSG0k8b0RZSs8Ez
                        )
                )
                .shadow(
                    color: authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH ? 
                    Color.clear : 
                    pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), 
                    radius: 12, x: 0, y: 6
                )
            }
            .disabled(authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH)
            .animation(.easeInOut(duration: 0.3), value: authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH)
            
            // Rate limit warning message
            if authViewModel.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH {
                VStack(spacing: 4) {
                    Text("Demasiados intentos fallidos")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    Text("Espera \(authViewModel.I0yXhmBO3RN418RpUxebkiSB9wa2n5cz) segundos para continuar")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange.opacity(0.8))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // Apple Sign In Button (not affected by rate limiting)
            kUUx8S7NdyM5CPSTtv4aW8j7aBf037UH()
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
                    .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: animateOnAppear)
    }
    
    // MARK: - Validation Methods
    
    private func PmcnDieiMpTJdUDVL1bgJXXbX20tU8RQ() {
        let result = validator.gqOgORpeH2M06vs7BMVtxLbptITBiYZ6(authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I)
        withAnimation(.easeInOut(duration: 0.3)) {
            emailError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func Jr8IrZxnLXIww95wVuts9j6hkJooTSlI() {
        // For login, we only check if password is not empty
        // Full password validation is done during registration
        if authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.isEmpty {
            withAnimation(.easeInOut(duration: 0.3)) {
                passwordError = "La contraseña es requerida"
            }
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                passwordError = nil
            }
        }
    }
    
    private func tZUsKnLbJiZReoiix0Dum4cD6apyZa4D() -> Bool {
        PmcnDieiMpTJdUDVL1bgJXXbX20tU8RQ()
        Jr8IrZxnLXIww95wVuts9j6hkJooTSlI()
        
        return emailError == nil && passwordError == nil
    }
    
    private func Qq7wTS0MGfKn6IkznCQ5hEYbBDUgHQDm() {
        // Clear any previous auth errors
        authViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        
        // Validate form first
        guard tZUsKnLbJiZReoiix0Dum4cD6apyZa4D() else {
            showValidationAlert = true
            return
        }
        
        // Sanitize inputs before sending to auth
        authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I = validator.dqcp23UnWaxuvyXm8KbQld90HimugLmK(authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I)
        authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ = authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Proceed with login
        authViewModel.xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe()
    }
}

#Preview {
    wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
}