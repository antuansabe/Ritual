import SwiftUI
import UIKit

// MARK: - Activity Types Data
struct ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR {
    let koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: String
    let QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: String
    let QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: Color
    
    static let ZK6kyfYr0vLj1yUR7dvzoTjmnmUfNWDI = [
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Cardio", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "heart.circle.fill", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .red),
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Fuerza", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "dumbbell.fill", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .blue),
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Yoga", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "figure.mind.and.body", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .purple),
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Caminata", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "figure.walk", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .green),
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Ciclismo", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "bicycle", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .yellow),
        ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR(koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ: "Jiu Jitsu", QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj: "figure.martial.arts", QFkRJkbJW973pOHJ12UZBEOecQPqJHCA: .purple)
    ]
}

// MARK: - Modern Workout Type Button Component
struct JR3pPqfV2aEfFQnN0c1Y1xnJG1Ly3Fvp: View {
    let type: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.3) : color.opacity(0.15))
                        .frame(width: 60, height: 60)
                        .shadow(color: isSelected ? color.opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(isSelected ? .white : color)
                        .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 0.5)
                }
                
                Text(type)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: isSelected ? .black.opacity(0.2) : .clear, radius: 1, x: 0, y: 0.5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                    .fill(isSelected ? 
                        LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .stroke(isSelected ? color.opacity(0.5) : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel(type)
        .accessibilityHint(isSelected ? "Currently selected activity type" : "Tap to select \(type) as activity type")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

// MARK: - Success Modal Component
struct l8KHgfumuyynsJtb04WRA9xcOAZks34R: View {
    let title: String
    let message: String
    let icon: String
    let isVisible: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.3), value: isVisible)
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.g6ulfCjB9tr2kTlC98jkNt7lvCVu3BSH.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: icon)
                        .font(.system(size: 48))
                        .foregroundColor(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.g6ulfCjB9tr2kTlC98jkNt7lvCVu3BSH)
                }
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 280, height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg(true))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb(), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                    )
            )
            .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: 10)
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
        }
        .zIndex(2)
    }
}

// MARK: - Summary Metric Card Component
struct vbM47y2u0RtVJW266wDAsRiLu9QHzogC: View {
    let icon: String
    let value: String
    let label: String
    let tint: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(tint)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                    .accessibilityLabel("\(value) \(label)")
                
                Text(label)
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg())
                .overlay(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .stroke(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb(), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                )
        )
        .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.bTCtL4JJ6s6CZeDy20yfXlv4bGc83wHJ)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct IMjYxABvVAMQSC7XsNhcGrSt11ziYDi2: View {
    @StateObject private var workoutViewModel = Jc55BDpU9b1oI7imy0dSuxhnsfADioo4()
    @StateObject private var customTrainingManager = MquKYa6zIelLCz6Z4AhDl5XrdYZqIIR1()
    @ObservedObject private var offlineManager = f44CM3JdBo3CztstNOncNr1s4UV8ejD1.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @ObservedObject private var networkMonitor = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Binding var selectedTab: Int
    
    @State private var tipoSeleccionado = "Cardio"
    @State private var duration = 0
    @State private var animateOnAppear = false
    @State private var showSuccessOverlay = false
    @State private var showAddCustomTraining = false
    @State private var showDeleteConfirmation = false
    @State private var trainingToDelete: Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD?
    @Namespace private var heroAnimation
    
    // Button press state for save button animation
    @State private var isSaveButtonPressed = false
    
    // Validation states
    @State private var durationError: String? = nil
    @State private var typeError: String? = nil
    @State private var showValidationAlert = false
    @State private var validationAlertMessage = "Por favor corrige los errores en el formulario"
    
    private let validator = VknfqtmwStiiWr4ox76LjSmWY9bPAg8Z.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var isFormValid: Bool {
        return duration > 0 && !tipoSeleccionado.isEmpty
    }
    
    var body: some View {
        ReusableBackgroundView {
            VStack(spacing: 0) {
                // Network status banner
                SFjoEA9WgrgcG2VXMOEPdBh25bSeyWSg()
                
                headerSection
                
                ScrollView {
                    VStack(spacing: 32) {
                        workoutTypeSection
                        durationSection
                        summarySection
                    }
                    .padding(.bottom, 140)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                bottomActionSection
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateOnAppear = true
            }
        }
        .overlay {
            wWSZ1770xFoHrYLOXIX3QK1M31SV1wMj(
                title: "¡Entrenamiento guardado!",
                subtitle: "Sigue así y alcanza tus metas",
                isVisible: $showSuccessOverlay
            )
            .opacity(showSuccessOverlay ? 1 : 0)
            .allowsHitTesting(showSuccessOverlay)
        }
        .onChange(of: workoutViewModel.XBKRsaOVB7IubKbKig2RNYsBUWknczOR) { success in
            if success {
                // Haptic feedback for workout saved
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                showSuccessOverlay = true
            }
        }
        .customAlert(
            title: "Error",
            message: workoutViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy ?? "",
            primaryButton: AlertButton(
                title: "OK",
                icon: "checkmark",
                style: .default,
                action: {
                    workoutViewModel.EYA1lT4kx4ae526Okh9jsZgBxFHUOAsZ()
                }
            ),
            isPresented: .constant(workoutViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy != nil)
        )
        .onChange(of: workoutViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy) { error in
            if error != nil {
                // Haptic feedback for validation error
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
            }
        }
        .customAlert(
            title: "Datos inválidos",
            message: validationAlertMessage,
            primaryButton: AlertButton(
                title: "OK",
                icon: "checkmark",
                style: .default,
                action: {
                    showValidationAlert = false
                    
                }
            ),
            isPresented: $showValidationAlert
        )
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("Nuevo Entrenamiento")
                .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.VbiaN8et3V1H9i33HGvaIjSMOPgfM5UL)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : -30)
        .animation(.easeOut(duration: 0.6), value: animateOnAppear)
    }
    
    // MARK: - Workout Type Section
    private var workoutTypeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Selecciona tu actividad")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Default activity types
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(Array(ihgdZCZ77qBKjAhR9r9jixKHxA35ZHNR.ZK6kyfYr0vLj1yUR7dvzoTjmnmUfNWDI.enumerated()), id: \.offset) { index, activityType in
                    JR3pPqfV2aEfFQnN0c1Y1xnJG1Ly3Fvp(
                        type: activityType.koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ,
                        icon: activityType.QC46OQsKu6Ywy6KZ9QNySnnKV3mho0Mj,
                        color: activityType.QFkRJkbJW973pOHJ12UZBEOecQPqJHCA,
                        isSelected: tipoSeleccionado == activityType.koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            tipoSeleccionado = activityType.koIOMXzYPHchPAyY3M0OCT1ReFFoOqpJ
                        }
                    }
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 30)
                    .animation(.easeOut(duration: 0.5).delay(0.2 + Double(index) * 0.05), value: animateOnAppear)
                }
            }
            .padding(.horizontal, 16)
            
            // Custom trainings section
            if !customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.isEmpty || customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() {
                customTrainingsSection
            }
        }
        .sheet(isPresented: $showAddCustomTraining) {
            JwEMHAOLFU3QoFmE4JdeO2opAnNjRZ5X()
                .environmentObject(customTrainingManager)
        }
        .customAlert(
            title: "Eliminar Entrenamiento",
            message: trainingToDelete != nil ? "¿Estás seguro de que quieres eliminar '\(trainingToDelete!.name)'?" : "",
            primaryButton: AlertButton(
                title: "Eliminar",
                icon: "trash",
                style: .destructive,
                action: {
                    if let training = trainingToDelete {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            customTrainingManager.Q6TViouC2E7V78xd81Ta8gTk6xvC5rB8(training)
                            if tipoSeleccionado == training.name {
                                tipoSeleccionado = "Cardio"
                            }
                        }
                    }
                    trainingToDelete = nil
                }
            ),
            secondaryButton: AlertButton(
                title: "Cancelar",
                style: .cancel,
                action: {
                    trainingToDelete = nil
                }
            ),
            isPresented: $showDeleteConfirmation
        )
    }
    
    // MARK: - Custom Trainings Section
    private var customTrainingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Entrenamientos personalizados")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateOnAppear)
            
            if !customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(Array(customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.enumerated()), id: \.element.id) { index, customTraining in
                        Sonwv8s8aTlNcWiT9TaTKoejOVC2LzkM(
                            training: customTraining,
                            isSelected: tipoSeleccionado == customTraining.name,
                            onSelect: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    tipoSeleccionado = customTraining.name
                                }
                            },
                            onDelete: {
                                trainingToDelete = customTraining
                                showDeleteConfirmation = true
                            }
                        )
                        .opacity(animateOnAppear ? 1 : 0)
                        .offset(y: animateOnAppear ? 0 : 30)
                        .animation(.easeOut(duration: 0.5).delay(0.9 + Double(index) * 0.05), value: animateOnAppear)
                    }
                    
                    // Add button if there's space and less than max
                    if customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() && customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.count % 2 == 1 {
                        yxWomeIShRzDF0eBuFCOnXbfMmpqe4Iu {
                            showAddCustomTraining = true
                        }
                        .opacity(animateOnAppear ? 1 : 0)
                        .offset(y: animateOnAppear ? 0 : 30)
                        .animation(.easeOut(duration: 0.5).delay(0.9 + Double(customTrainingManager.zaGunqeOYc8JPxMgK4gQmqOGUd2fafjW.count) * 0.05), value: animateOnAppear)
                    }
                }
                .padding(.horizontal, 16)
            } else if customTrainingManager.PzZbtqu8h8znMzXeOie5uZA8XwVRtWxu() {
                // Show add button when no custom trainings exist
                HStack {
                    yxWomeIShRzDF0eBuFCOnXbfMmpqe4Iu {
                        showAddCustomTraining = true
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .opacity(animateOnAppear ? 1 : 0)
                .offset(y: animateOnAppear ? 0 : 30)
                .animation(.easeOut(duration: 0.5).delay(0.9), value: animateOnAppear)
            }
        }
    }
    
    // MARK: - Duration Section
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Duración del entrenamiento")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    TextField("0", value: $duration, format: .number)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 120)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                    
                    Text("minutos")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0.5)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                        .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg(true))
                        .overlay(
                            RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                                .stroke(
                                    duration == 0 ? 
                                    Color.red.opacity(0.6) : 
                                    Color.blue.opacity(0.3), 
                                    lineWidth: duration == 0 ? 3 : 2
                                )
                        )
                )
                .shadow(color: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.s06S6l2jYXUPYG94fTRPPLQQdZkx2hYz(), radius: 8, x: 0, y: 4)
                
                // Duration error message
                if duration == 0 {
                    Text("Selecciona duración")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                quickDurationButtons
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateOnAppear)
        }
    }
    
    // MARK: - Quick Duration Buttons
    private var quickDurationButtons: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duraciones comunes")
                .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach([15, 30, 45, 60, 90, 120], id: \.self) { minutes in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            duration = minutes
                        }
                    }) {
                        Text("\(minutes)")
                            .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
                            .foregroundColor(duration == minutes ? .white : .white.opacity(0.8))
                            .frame(height: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.ZPiJx0tqo8n2DtmG0CeHsdjOg2YoQqZx)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.drEz2aTU4wuyafcRik6r81dFj2b4GDPU)
                                    .fill(duration == minutes ? AnyShapeStyle(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr) : AnyShapeStyle(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.XTqZhA1aMezwggsTNkLgubp1vTdAYrgg()))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.drEz2aTU4wuyafcRik6r81dFj2b4GDPU)
                                            .stroke(duration == minutes ? AnyShapeStyle(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr.opacity(0.3)) : AnyShapeStyle(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.hEHvnuhquOEbu91QYcb2ngjX1eTkwuVb()), lineWidth: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.kEdPhJbe9pFfxc6GmcCjsIcLRnkyRurM)
                                    )
                            )
                            .shadow(color: duration == minutes ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr.opacity(0.3) : .clear, radius: 2)
                    }
                    .animation(.easeInOut(duration: 0.2), value: duration == minutes)
                }
            }
        }
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Resumen")
                    .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.qginztZrG8YowoNdoaXjEAcxXYyyjnlT)
                    .foregroundColor(.white)
                    .opacity(animateOnAppear ? 1 : 0)
                    .offset(y: animateOnAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: animateOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 12) {
                vbM47y2u0RtVJW266wDAsRiLu9QHzogC(
                    icon: "clock.fill",
                    value: duration == 0 ? "0" : "\(duration)",
                    label: "Minutos",
                    tint: .blue
                )
                .matchedGeometryEffect(id: "minutes", in: heroAnimation)
                
                vbM47y2u0RtVJW266wDAsRiLu9QHzogC(
                    icon: "flame.fill",
                    value: duration == 0 ? "0" : "\(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.macBuYFDgFuotG3Vx9Tc3pppQyU8fFgE(for: duration))",
                    label: "Calorías",
                    tint: .orange
                )
                .matchedGeometryEffect(id: "calories", in: heroAnimation)
            }
            .padding(.horizontal, 16)
            .opacity(animateOnAppear ? 1 : 0)
            .offset(y: animateOnAppear ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateOnAppear)
        }
    }
    
    // MARK: - Bottom Action Section
    private var bottomActionSection: some View {
        VStack(spacing: 16) {
            Button(action: Q6FQiudhsBje7gcQQ0nF3ogoeJ65kYIX) {
                HStack(spacing: 12) {
                    if workoutViewModel.YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(workoutViewModel.YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo ? "Guardando..." : "Guardar Entrenamiento")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isFormValid ? 
                            LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .shadow(color: isFormValid ? Color.green.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                .scaleEffect(isSaveButtonPressed ? 0.95 : (isFormValid ? 1.0 : 0.98))
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSaveButtonPressed)
            }
            .disabled(duration == 0 || workoutViewModel.YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo)
            .opacity(duration == 0 ? 0.5 : 1)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isSaveButtonPressed = pressing
            }, perform: {})
            
            Button("Limpiar campos") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    tipoSeleccionado = "Cardio"
                    duration = 0
                }
            }
            .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.lsQGPy4QxpSwRnN9acKxlHS7hUYKqnmg)
            .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
        .opacity(animateOnAppear ? 1 : 0)
        .offset(y: animateOnAppear ? 0 : 50)
        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateOnAppear)
    }
    
    
    // MARK: - Validation Methods
    
    private func Axpl8qOdzY7xWLvRNIqhc5cHQPWMFoCp() {
        let result = validator.mK1HuXd0dllufICl3QQamyvCvsx1UOhe(String(duration))
        withAnimation(.easeInOut(duration: 0.3)) {
            durationError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func QSbYcsvCa6jy9a06wtSCDfk3bSEt0lFP() {
        let result = validator.yQTfzeSq7UapiEXhlhx81yO5cHtgXaYD(tipoSeleccionado)
        withAnimation(.easeInOut(duration: 0.3)) {
            typeError = result.rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP ? nil : result.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy
        }
    }
    
    private func tZUsKnLbJiZReoiix0Dum4cD6apyZa4D() -> Bool {
        Axpl8qOdzY7xWLvRNIqhc5cHQPWMFoCp()
        QSbYcsvCa6jy9a06wtSCDfk3bSEt0lFP()
        
        return durationError == nil && typeError == nil
    }
    
    private func Kpi8sXbTgHCdZNmlB5vxM8cn96JM3G0o() -> Bool {
        // Use the same validation pattern as the form
        let durationValid = validator.mK1HuXd0dllufICl3QQamyvCvsx1UOhe(String(duration)).rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP
        let typeValid = validator.yQTfzeSq7UapiEXhlhx81yO5cHtgXaYD(tipoSeleccionado).rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP
        
        // Additional validation for calculated calories
        if duration > 0 {
            let calories = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.macBuYFDgFuotG3Vx9Tc3pppQyU8fFgE(for: duration)
            let caloriesValid = validator.UeuZ4TttshvAphn0ACvLfm5t5LOE5kqT(calories).rzOOgG3zeQ5Mq29ToN3FEmWm4bvESZhP
            return durationValid && typeValid && caloriesValid
        }
        
        return false
    }
    
    // MARK: - Save Function
    private func Q6FQiudhsBje7gcQQ0nF3ogoeJ65kYIX() {
        // Validate form fields first
        guard tZUsKnLbJiZReoiix0Dum4cD6apyZa4D() else {
            validationAlertMessage = "Por favor corrige los errores en el formulario antes de continuar."
            showValidationAlert = true
            return
        }
        
        // Validate complete workout data including calories
        guard Kpi8sXbTgHCdZNmlB5vxM8cn96JM3G0o() else {
            validationAlertMessage = "Los datos del entrenamiento no son válidos. Revisa la duración y el tipo de ejercicio."
            showValidationAlert = true
            return
        }
        
        // Sanitize inputs before saving
        let sanitizedDuration = String(duration)
        let sanitizedType = validator.S1FcBW204dzhY83hyyJGO8udFCyY9l66(tipoSeleccionado)
        
        let validationResult = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.r394gO8EYYjBidmh5QxY475XdYckv2xp(sanitizedDuration)
        
        switch validationResult {
        case .success(let validDuration):
            let _ = Int32(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.macBuYFDgFuotG3Vx9Tc3pppQyU8fFgE(for: validDuration))
            
            // Use basic Core Data saving with offline capability built into CloudKit
            Task {
                await workoutViewModel.Q6FQiudhsBje7gcQQ0nF3ogoeJ65kYIX(
                    type: sanitizedType,
                    duration: validDuration,
                    managedObjectContext: managedObjectContext
                )
                
                // Handle success state on main actor
                await MainActor.run {
                    if workoutViewModel.XBKRsaOVB7IubKbKig2RNYsBUWknczOR {
                        // Enhanced logging for offline detection
                        print("🏃‍♂️ Entrenamiento guardado - CloudKit manejará sync automáticamente")
                        print("📊 Tipo: \(tipoSeleccionado), Duración: \(validDuration) min")
                        print("💾 Core Data + CloudKit: Funciona offline y sync cuando hay red")
                        
                        // Show success overlay
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSuccessOverlay = true
                        }
                        
                        // Reset form fields after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            tipoSeleccionado = "Cardio"
                            duration = 0
                        }
                        
                        // Navigate back to home tab after overlay disappears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = 0
                            }
                        }
                    }
                }
            }
            
        case .failure(let error):
            workoutViewModel.TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = error.localizedDescription
        }
    }
}

// MARK: - Custom Workout Type Button Component
struct Sonwv8s8aTlNcWiT9TaTKoejOVC2LzkM: View {
    let training: Rwq5UG4rvo7IhqKrt5SQ38RnUcfGPsYD
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    @State private var showDeleteButton = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 12) {
                ZStack {
                    // Main icon circle
                    Circle()
                        .fill(
                            isSelected ? 
                                LinearGradient(
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: isSelected ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                    
                    Image(systemName: training.iconName)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                        .shadow(color: isSelected ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 0.5)
                    
                    // Delete button overlay
                    if showDeleteButton {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: onDelete) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.red)
                                        .background(
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 16, height: 16)
                                        )
                                }
                                .offset(x: 8, y: -8)
                            }
                            Spacer()
                        }
                    }
                }
                
                Text(training.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: isSelected ? .black.opacity(0.2) : .clear, radius: 1, x: 0, y: 0.5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                    .fill(
                        isSelected ? 
                            LinearGradient(
                                colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .stroke(
                                isSelected ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(
                color: isSelected ? pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: .infinity, pressing: { pressing in
            if pressing {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showDeleteButton = true
                }
            }
        }, perform: {})
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel(training.name)
        .accessibilityHint(isSelected ? "Currently selected custom activity" : "Tap to select \(training.name) as activity type")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showDeleteButton = false
            }
        }
    }
}

// MARK: - Add Training Button Component
struct yxWomeIShRzDF0eBuFCOnXbfMmpqe4Iu: View {
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.15), Color.white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.4), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 2, dash: [5, 3])
                                )
                        )
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text("Agregar")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .stroke(
                                LinearGradient(
                                    colors: [pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT.opacity(0.3), pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.DRvlvbJhxV7mCrFqbBkEol95863hAZF0.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel("Add custom training")
        .accessibilityHint("Tap to create a new custom training activity")
    }
}

// MARK: - Custom Alert Components

struct AlertButton {
    let title: String
    let icon: String
    let style: AlertButtonStyle
    let action: () -> Void
    
    init(title: String, icon: String = "", style: AlertButtonStyle = .default, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
}

enum AlertButtonStyle {
    case `default`
    case destructive
    case cancel
    
    var color: Color {
        switch self {
        case .default:
            return pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.su8Vctd4yB3rRBP8m4kTB7dmfsjGl0hT
        case .destructive:
            return .red
        case .cancel:
            return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .default:
            return "questionmark.circle"
        case .destructive:
            return "exclamationmark.triangle"
        case .cancel:
            return "xmark.circle"
        }
    }
}

struct CustomAlertView: View {
    let title: String
    let message: String
    let primaryButton: AlertButton
    let secondaryButton: AlertButton?
    @Binding var isVisible: Bool
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var iconScale: CGFloat = 0
    @State private var buttonsOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    hideAlert()
                }
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        primaryButton.style.color.opacity(0.2),
                                        primaryButton.style.color.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .stroke(primaryButton.style.color, lineWidth: 3)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: primaryButton.style.icon)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(primaryButton.style.color)
                            .scaleEffect(iconScale)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
                
                VStack(spacing: 16) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                VStack(spacing: 12) {
                    if let secondary = secondaryButton {
                        HStack(spacing: 12) {
                            alertButton(secondary, isPrimary: false)
                            alertButton(primaryButton, isPrimary: true)
                        }
                        .padding(.horizontal, 24)
                    } else {
                        alertButton(primaryButton, isPrimary: true)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 24)
                .opacity(buttonsOpacity)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(scale)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .opacity(opacity)
        .onChange(of: isVisible) { visible in
            if visible {
                showAlert()
            } else {
                hideAlert()
            }
        }
        .onAppear {
            if isVisible {
                showAlert()
            }
        }
    }
    
    private func alertButton(_ button: AlertButton, isPrimary: Bool) -> some View {
        Button(action: {
            hideAlert()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                button.action()
            }
        }) {
            HStack(spacing: 8) {
                if !button.icon.isEmpty {
                    Image(systemName: button.icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(button.title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isPrimary ? .white : button.style.color)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        isPrimary 
                        ? LinearGradient(
                            colors: [
                                button.style.color,
                                button.style.color.opacity(0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                isPrimary ? Color.clear : button.style.color.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private func showAlert() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            opacity = 1
            scale = 1
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.1)) {
            iconScale = 1
        }
        
        withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
            buttonsOpacity = 1
        }
    }
    
    private func hideAlert() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0
            scale = 0.8
            buttonsOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if isVisible {
                isVisible = false
            }
            scale = 0.5
            iconScale = 0
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func customAlert(
        title: String,
        message: String,
        primaryButton: AlertButton,
        secondaryButton: AlertButton? = nil,
        isPresented: Binding<Bool>
    ) -> some View {
        self.overlay(
            Group {
                if isPresented.wrappedValue {
                    CustomAlertView(
                        title: title,
                        message: message,
                        primaryButton: primaryButton,
                        secondaryButton: secondaryButton,
                        isVisible: isPresented
                    )
                }
            }
        )
    }
}

#Preview {
    IMjYxABvVAMQSC7XsNhcGrSt11ziYDi2(selectedTab: .constant(1))
        .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}
