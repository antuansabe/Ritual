import SwiftUI

struct B4qvsC5G8P17ox009Aj1FnUDwHQ5CAhI: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @State private var showLogin = false
    @State private var animateOnAppear = false
    @Environment(\.dismiss) private var dismiss
    
    // Validation states
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var showValidationAlert = false
    
    private let validator = VknfqtmwStiiWr4ox76LjSmWY9bPAg8Z.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var body: some View {
        ZStack {
            Image("registroBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
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
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
            wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
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
            // Elemento visual emotivo con ícono de bienvenida
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
                
                // Ícono central emotivo y acogedor
                Image(systemName: "figure.wave")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.iRzcaY5rHnko7qweKLrpTDkw0U4VdRtR.opacity(0.9), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(animateOnAppear ? 1 : 0)
            .scaleEffect(animateOnAppear ? 1 : 0.8)
            .animation(.spring(response: 1.0, dampingFraction: 0.8), value: animateOnAppear)
            
            VStack(spacing: 20) {
                Text("Crear Cuenta")
                    .font(.system(size: 34, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .kerning(2)
                
                // Línea decorativa que se expande
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.5), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.4), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3)],
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
                
                SecureField("Crea una contraseña", text: $authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ)
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
                    .textContentType(.newPassword)
                    .onChange(of: authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ) { _ in
                        Jr8IrZxnLXIww95wVuts9j6hkJooTSlI()
                        JlJwFWh29f5bAVqXhj1CHqULtaRcyZ8r() // Re-validate confirm password when password changes
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
            
            // Confirm Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirmar Contraseña")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                SecureField("Confirma tu contraseña", text: $authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm)
                    .font(.system(size: 16, weight: .light))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.x8kMOs8TbaTU9EZVNGGkCbO7acJpUphq)
                            .overlay(
                                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                    .stroke(
                                        confirmPasswordError != nil ? 
                                        AnyShapeStyle(Color.red.opacity(0.6)) :
                                        AnyShapeStyle(LinearGradient(
                                            colors: [Color.white.opacity(0.2), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )),
                                        lineWidth: confirmPasswordError != nil ? 2 : 1
                                    )
                            )
                    )
                    .foregroundColor(.white)
                    .textContentType(.newPassword)
                    .onChange(of: authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm) { _ in
                        JlJwFWh29f5bAVqXhj1CHqULtaRcyZ8r()
                    }
                
                // Confirm password error message
                if let confirmPasswordError = confirmPasswordError {
                    Text(confirmPasswordError)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.leading, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            // Password Requirements
            if !authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.count >= 6 ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.count >= 6 ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT : .white.opacity(0.4))
                            .font(.system(size: 12))
                        Text("Al menos 6 caracteres")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ.count >= 6 ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT : .white.opacity(0.6))
                    }
                    
                    if !authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordsMatch ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT : .white.opacity(0.4))
                                .font(.system(size: 12))
                            Text("Las contraseñas coinciden")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(passwordsMatch ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT : .white.opacity(0.6))
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
    
    // MARK: - Validation Methods
    
    private func PmcnDieiMpTJdUDVL1bgJXXbX20tU8RQ() {
        let result = validator.gqOgORpeH2M06vs7BMVtxLbptITBiYZ6(authViewModel.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I)
        withAnimation(.easeInOut(duration: 0.3)) {
            emailError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func Jr8IrZxnLXIww95wVuts9j6hkJooTSlI() {
        let result = validator.h5XGz4DUlwTKJKtlQOvbuUuAbkL6wlu1(authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ)
        withAnimation(.easeInOut(duration: 0.3)) {
            passwordError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func JlJwFWh29f5bAVqXhj1CHqULtaRcyZ8r() {
        if authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm.isEmpty {
            withAnimation(.easeInOut(duration: 0.3)) {
                confirmPasswordError = nil
            }
        } else if authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ != authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm {
            withAnimation(.easeInOut(duration: 0.3)) {
                confirmPasswordError = "Las contraseñas no coinciden"
            }
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                confirmPasswordError = nil
            }
        }
    }
    
    private func tZUsKnLbJiZReoiix0Dum4cD6apyZa4D() -> Bool {
        PmcnDieiMpTJdUDVL1bgJXXbX20tU8RQ()
        Jr8IrZxnLXIww95wVuts9j6hkJooTSlI()
        JlJwFWh29f5bAVqXhj1CHqULtaRcyZ8r()
        
        return emailError == nil && passwordError == nil && confirmPasswordError == nil
    }
    
    private func PDenkQmGWZdVlEzhL6d658zERfRCfQ4w() {
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
        authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm = authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Proceed with registration
        authViewModel.GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR()
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        Button(action: {
            PDenkQmGWZdVlEzhL6d658zERfRCfQ4w()
        }) {
            Text("Registrarse")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.Jaqu2AaPnNe3jLsCKOSG0k8b0RZSs8Ez)
                )
                .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), radius: 12, x: 0, y: 6)
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
                    .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT)
            }
        }
        .opacity(animateOnAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: animateOnAppear)
    }
    
    // MARK: - Computed Properties
    private var passwordsMatch: Bool {
        !authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm.isEmpty && authViewModel.QZHDJgEWRERtPl00BdMoGaz3FxVErREZ == authViewModel.UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm
    }
}

#Preview {
    B4qvsC5G8P17ox009Aj1FnUDwHQ5CAhI()
        .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
}