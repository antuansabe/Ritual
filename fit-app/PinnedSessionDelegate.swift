import Foundation
import Security
import CommonCrypto
import os.log

/// URLSessionDelegate que implementa TLS Certificate Pinning usando SHA-256
/// Protege contra ataques man-in-the-middle verificando que el certificado del servidor
/// coincida con el hash SHA-256 esperado
class Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2: NSObject, URLSessionDelegate {
    
    // MARK: - Properties
    
    /// Hash SHA-256 del certificado de api.ritmia.com en formato base64
    /// TODO: Reemplazar con el hash real cuando el dominio esté disponible
    private let expectedCertificateHash: String
    
    /// Dominio para el cual aplicar pinning
    private let pinnedDomain: String
    
    // MARK: - Initialization
    
    /// Inicializa el delegate con el hash del certificado esperado
    /// - Parameters:
    ///   - certificateHash: Hash SHA-256 en base64 del certificado esperado
    ///   - domain: Dominio para aplicar pinning (default: api.ritmia.com)
    init(certificateHash: String, domain: String = "api.ritmia.com") {
        self.expectedCertificateHash = certificateHash
        self.pinnedDomain = domain
        super.init()
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 TLS Pinning initialized for domain: \(domain)")
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Expected certificate hash: \(certificateHash)")
        #endif
    }
    
    // MARK: - URLSessionDelegate
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        
        // Verificar si es una challenge de server trust
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Non-server trust challenge, using default handling")
            #endif
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        // Verificar si es para nuestro dominio pinneado
        guard challenge.protectionSpace.host == pinnedDomain else {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Challenge for different domain (\(challenge.protectionSpace.host)), using default handling")
            #endif
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Performing TLS pinning verification for \(self.pinnedDomain)")
        #endif
        
        // Obtener el server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.warning("🔒 ❌ No server trust available")
            #endif
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Verificar el certificado
        let pinningResult = PQ11Jsfkgxs6NtkRCk4OVvNJGMMyQGeI(serverTrust: serverTrust)
        
        switch pinningResult {
        case .success(let credential):
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 ✅ TLS pinning verification successful")
            #endif
            completionHandler(.useCredential, credential)
            
        case .failure(let error):
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.warning("🔒 ❌ TLS pinning verification failed: \(error.localizedDescription)")
            #endif
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    // MARK: - Certificate Pinning Logic
    
    /// Verifica el pinning del certificado contra el hash esperado
    /// - Parameter serverTrust: Server trust del servidor
    /// - Returns: Result con credential si es exitoso, error si falla
    private func PQ11Jsfkgxs6NtkRCk4OVvNJGMMyQGeI(serverTrust: SecTrust) -> Result<URLCredential, B5ZPKxi6GmWiqHiNq2jBolPntTov4L4n> {
        
        // Obtener el certificado del servidor (leaf certificate)
        guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            return .failure(.nTiwCpy2bECJBV3YVJDdgznVvClKPlWr)
        }
        
        // Obtener los datos del certificado
        let serverCertificateData = SecCertificateCopyData(serverCertificate)
        let data = CFDataGetBytePtr(serverCertificateData)
        let size = CFDataGetLength(serverCertificateData)
        
        guard let certificateData = data else {
            return .failure(.BOv6SpZDpj9gHr9UvvSjH2hvhdez10bz)
        }
        
        // Calcular SHA-256 del certificado
        let certificateHash = axJzE6GswEoyEnowaumEcSQrvx3moVu2(data: certificateData, length: size)
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Server certificate hash: \(certificateHash)")
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔒 Expected hash: \(self.expectedCertificateHash)")
        #endif
        
        // Comparar con el hash esperado
        guard certificateHash == expectedCertificateHash else {
            return .failure(.d6QnCoYLPQws3k743HG3wVJ2cTH0CBTT(expected: expectedCertificateHash, actual: certificateHash))
        }
        
        // Verificar que el server trust sea válido
        let evaluationResult = SecTrustEvaluateWithError(serverTrust, nil)
        
        guard evaluationResult else {
            return .failure(.up0ycvcAVO4pqog7Ciew0tMnB8WOZa2u)
        }
        
        // Crear credential para el server trust válido
        let credential = URLCredential(trust: serverTrust)
        return .success(credential)
    }
    
    /// Calcula el hash SHA-256 de los datos del certificado
    /// - Parameters:
    ///   - data: Pointer a los datos del certificado
    ///   - length: Longitud de los datos
    /// - Returns: Hash SHA-256 en formato base64
    private func axJzE6GswEoyEnowaumEcSQrvx3moVu2(data: UnsafePointer<UInt8>, length: Int) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        CC_SHA256(data, CC_LONG(length), &hash)
        
        let hashData = Data(hash)
        return hashData.base64EncodedString()
    }
}

// MARK: - TLS Pinning Errors

/// Errores específicos del TLS pinning
enum B5ZPKxi6GmWiqHiNq2jBolPntTov4L4n: Error, LocalizedError {
    case nTiwCpy2bECJBV3YVJDdgznVvClKPlWr
    case BOv6SpZDpj9gHr9UvvSjH2hvhdez10bz
    case d6QnCoYLPQws3k743HG3wVJ2cTH0CBTT(expected: String, actual: String)
    case up0ycvcAVO4pqog7Ciew0tMnB8WOZa2u
    
    var errorDescription: String? {
        switch self {
        case .nTiwCpy2bECJBV3YVJDdgznVvClKPlWr:
            return "No se pudo obtener el certificado del servidor"
        case .BOv6SpZDpj9gHr9UvvSjH2hvhdez10bz:
            return "Datos del certificado inválidos"
        case .d6QnCoYLPQws3k743HG3wVJ2cTH0CBTT(let expected, let actual):
            return "Hash del certificado no coincide. Esperado: \(expected), Actual: \(actual)"
        case .up0ycvcAVO4pqog7Ciew0tMnB8WOZa2u:
            return "Falló la evaluación de confianza del certificado"
        }
    }
}

// MARK: - Extensions para configuración

extension Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2 {
    
    /// Hash de ejemplo para api.ritmia.com (placeholder hasta obtener el real)
    static let t4ArORJbWdZA7IBCigzBQmRB5Th10lUI = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    
    /// Crea un delegate con configuración de ejemplo para desarrollo
    /// - Returns: PinnedSessionDelegate configurado con hash de ejemplo
    static func L5Y0HAbehL6p6uzZtSBtWuLqj2CJzIPH() -> Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2 {
        return Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2(certificateHash: t4ArORJbWdZA7IBCigzBQmRB5Th10lUI)
    }
    
    /// Verifica si un hash tiene el formato correcto (base64)
    /// - Parameter hash: Hash a verificar
    /// - Returns: true si el formato es válido
    static func V1TCgi8rLICW0cZ1pSkSaVvN7aQJvijN(_ hash: String) -> Bool {
        // Un hash SHA-256 en base64 debe tener 44 caracteres y terminar con =
        guard hash.count == 44 && hash.hasSuffix("=") else {
            return false
        }
        
        // Verificar que sea base64 válido
        guard Data(base64Encoded: hash) != nil else {
            return false
        }
        
        return true
    }
}

// MARK: - Testing Support

#if DEBUG
extension Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2 {
    
    /// Método para testing - permite inyectar un hash específico
    /// - Parameter hash: Hash para usar en tests
    /// - Returns: Delegate configurado para testing
    static func BHjjnUZ7TeaVVNWSO1PAWFN3orJRd5Pf(withHash hash: String) -> Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2 {
        return Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2(certificateHash: hash, domain: "test.example.com")
    }
    
    /// Simula una verificación de pinning para testing
    /// - Parameters:
    ///   - testHash: Hash a usar para la prueba
    ///   - serverHash: Hash que simula venir del servidor
    /// - Returns: true si la verificación es exitosa
    func zbBzh7Z5U3qVoNk7vsC8HjxkwtPuAEl4(expectedHash: String, serverHash: String) -> Bool {
        return expectedHash == serverHash
    }
}
#endif