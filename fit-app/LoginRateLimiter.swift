import Foundation
import os.log

/// Rate limiter para prevenir ataques de fuerza bruta en el login
/// Limita a 5 intentos fallidos por ventana de 60 segundos
class aad5Y8PlamnXnoch5v7UeSToytIc7jOk {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = aad5Y8PlamnXnoch5v7UeSToytIc7jOk()
    
    private let Z4h7cIuFKAxZDXiIOeBUKI8fOy8ohCDA = 5
    private let BPTovGS58uyZSJ4HYBCH2HswN9tAc7pH = 60
    private let UywkEKzuYYOQZQgfMRyXHbPcgyyoXEOi = 60
    
    private let kJKahA1h6Tn1dZADRdvIQS2pHqjWYN5G = "login_failure_timestamps"
    private let Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo = "login_lockout_start_time"
    
    private init() {}
    
    /// Registra un intento de login fallido
    func xP7Z01JKpdVTq21msPWS9YznNUWK57Ao() {
        let currentTime = DispatchTime.now().uptimeNanoseconds
        var timestamps = afHAp2VAeb7bDBd9mQl96HlXboTfpFPb()
        
        // Añadir nuevo timestamp
        timestamps.append(currentTime)
        
        // Limpiar timestamps antiguos (fuera de la ventana de tiempo)
        let cutoffTime = currentTime - UInt64(BPTovGS58uyZSJ4HYBCH2HswN9tAc7pH * 1_000_000_000)
        timestamps = timestamps.filter { $0 > cutoffTime }
        
        // Guardar timestamps actualizados
        PS7e6CVjLA56tNIxFvLrZ8T35QNeh6Hd(timestamps)
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Login failure recorded. Total attempts in window: \(timestamps.count)")
        #endif
        
        // Si se excede el límite, iniciar lockout
        if timestamps.count >= Z4h7cIuFKAxZDXiIOeBUKI8fOy8ohCDA {
            MAKkznOxhuE1HSk1Tf3RLEBeuVLAZbXZ()
        }
    }
    
    /// Verifica si se puede intentar un login
    /// - Returns: true si se puede intentar, false si está bloqueado
    func JC4lqsnhEGZaMN2Yt9yfueV0rFJ7v1kI() -> Bool {
        // Verificar si hay un lockout activo
        if cR7LO3nqNfDYG59lOV2zPEYes2gqV8x3() {
            return false
        }
        
        // Verificar número de intentos en la ventana de tiempo
        let timestamps = afHAp2VAeb7bDBd9mQl96HlXboTfpFPb()
        let currentTime = DispatchTime.now().uptimeNanoseconds
        let cutoffTime = currentTime - UInt64(BPTovGS58uyZSJ4HYBCH2HswN9tAc7pH * 1_000_000_000)
        
        // Contar intentos válidos en la ventana
        let recentAttempts = timestamps.filter { $0 > cutoffTime }
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Login attempts in current window: \(recentAttempts.count)/\(self.Z4h7cIuFKAxZDXiIOeBUKI8fOy8ohCDA)")
        #endif
        
        return recentAttempts.count < Z4h7cIuFKAxZDXiIOeBUKI8fOy8ohCDA
    }
    
    /// Obtiene el tiempo restante de bloqueo en segundos
    /// - Returns: Segundos restantes de bloqueo, 0 si no está bloqueado
    func JobPgKTqKe347RFYOzA7bdaPN8qquhAU() -> Int {
        guard let lockoutStartTime = aokiVYPA6GDWR4W2eJ16eGtQpDcbwy08() else {
            return 0
        }
        
        let currentTime = DispatchTime.now().uptimeNanoseconds
        let lockoutEndTime = lockoutStartTime + UInt64(UywkEKzuYYOQZQgfMRyXHbPcgyyoXEOi * 1_000_000_000)
        
        if currentTime >= lockoutEndTime {
            // El lockout ha expirado
            pn7mLZpRvWJnXDIplA3xJFrJtxyd9b1n()
            return 0
        }
        
        let remainingNanoseconds = lockoutEndTime - currentTime
        let remainingSeconds = Int(remainingNanoseconds / 1_000_000_000)
        
        return max(0, remainingSeconds)
    }
    
    /// Limpia el historial de intentos fallidos (usar después de login exitoso)
    func hK71mCWltpYaEzPtPBFTwy7pVFueZTlu() {
        UserDefaults.standard.removeObject(forKey: kJKahA1h6Tn1dZADRdvIQS2pHqjWYN5G)
        pn7mLZpRvWJnXDIplA3xJFrJtxyd9b1n()
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Login rate limiter reset - successful login")
        #endif
    }
    
    /// Obtiene información del estado actual para debugging
    func jmomiU8basFUoOBKuhLhEeldqFhu2mpt() -> (attempts: Int, isLocked: Bool, remainingTime: Int) {
        let timestamps = afHAp2VAeb7bDBd9mQl96HlXboTfpFPb()
        let currentTime = DispatchTime.now().uptimeNanoseconds
        let cutoffTime = currentTime - UInt64(BPTovGS58uyZSJ4HYBCH2HswN9tAc7pH * 1_000_000_000)
        let recentAttempts = timestamps.filter { $0 > cutoffTime }.count
        
        return (
            attempts: recentAttempts,
            isLocked: !JC4lqsnhEGZaMN2Yt9yfueV0rFJ7v1kI(),
            remainingTime: JobPgKTqKe347RFYOzA7bdaPN8qquhAU()
        )
    }
    
    // MARK: - Private Methods
    
    private func afHAp2VAeb7bDBd9mQl96HlXboTfpFPb() -> [UInt64] {
        return UserDefaults.standard.array(forKey: kJKahA1h6Tn1dZADRdvIQS2pHqjWYN5G) as? [UInt64] ?? []
    }
    
    private func PS7e6CVjLA56tNIxFvLrZ8T35QNeh6Hd(_ timestamps: [UInt64]) {
        UserDefaults.standard.set(timestamps, forKey: kJKahA1h6Tn1dZADRdvIQS2pHqjWYN5G)
    }
    
    private func MAKkznOxhuE1HSk1Tf3RLEBeuVLAZbXZ() {
        let currentTime = DispatchTime.now().uptimeNanoseconds
        UserDefaults.standard.set(currentTime, forKey: Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo)
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.warning("🚨 Login rate limit exceeded - account locked for \(self.UywkEKzuYYOQZQgfMRyXHbPcgyyoXEOi) seconds")
        #endif
    }
    
    private func aokiVYPA6GDWR4W2eJ16eGtQpDcbwy08() -> UInt64? {
        let time = UserDefaults.standard.object(forKey: Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo) as? UInt64
        return time == 0 ? nil : time
    }
    
    private func cR7LO3nqNfDYG59lOV2zPEYes2gqV8x3() -> Bool {
        guard let lockoutStartTime = aokiVYPA6GDWR4W2eJ16eGtQpDcbwy08() else {
            return false
        }
        
        let currentTime = DispatchTime.now().uptimeNanoseconds
        let lockoutEndTime = lockoutStartTime + UInt64(UywkEKzuYYOQZQgfMRyXHbPcgyyoXEOi * 1_000_000_000)
        
        if currentTime >= lockoutEndTime {
            // El lockout ha expirado
            pn7mLZpRvWJnXDIplA3xJFrJtxyd9b1n()
            return false
        }
        
        return true
    }
    
    private func pn7mLZpRvWJnXDIplA3xJFrJtxyd9b1n() {
        UserDefaults.standard.removeObject(forKey: Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo)
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Login lockout cleared")
        #endif
    }
}

// MARK: - Extensions para testing y debugging

extension aad5Y8PlamnXnoch5v7UeSToytIc7jOk {
    
    /// Método para testing - simula múltiples intentos fallidos
    func zEaitaJ97duIg4FuOdiMsXXzJoO42N1q(count: Int) {
        #if DEBUG
        for _ in 0..<count {
            xP7Z01JKpdVTq21msPWS9YznNUWK57Ao()
            // Pequeña pausa para evitar timestamps idénticos
            Thread.sleep(forTimeInterval: 0.001)
        }
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🧪 Simulated \(count) login failures for testing")
        #endif
    }
    
    /// Método para testing - fuerza un lockout inmediato
    func GBje4aCGbJYJOgFoKkPHysG0rk7X2wcj() {
        #if DEBUG
        let currentTime = DispatchTime.now().uptimeNanoseconds
        UserDefaults.standard.set(currentTime, forKey: Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo)
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🧪 Forced login lockout for testing")
        #endif
    }
    
    /// Método para testing - limpia todo el estado
    func rNyZjOF1rAnctHfvZf5xu19UnjwTqbYY() {
        #if DEBUG
        UserDefaults.standard.removeObject(forKey: kJKahA1h6Tn1dZADRdvIQS2pHqjWYN5G)
        UserDefaults.standard.removeObject(forKey: Er6kQmexA3SSnzH9ltz8SBLsQpg8VuMo)
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🧪 Cleared all rate limiter data for testing")
        #endif
    }
}