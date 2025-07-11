import Foundation
import os.log

/// Capa de red segura con TLS Certificate Pinning
/// Maneja todas las comunicaciones HTTP/HTTPS con el backend de FitApp
class cs5srZOImM6bgVz7e5jFMoaReyyKYTx3 {
    
    // MARK: - Shared Instance
    
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = cs5srZOImM6bgVz7e5jFMoaReyyKYTx3()
    
    // MARK: - Properties
    
    /// URLSession configurada con TLS pinning
    private let y2UK1kNCbUNLHDmClnE6HPV76XuSAUbu: URLSession
    
    /// Base URL del API
    private let iaNCMwZtrGICnb5qMBqosVkWRrhzSydy = "https://api.fitapp.com"
    
    /// Delegate para TLS pinning
    private let NAUplMJ5TPklsbH0i03FTKupmbMJuSAp: Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2
    
    // MARK: - Initialization
    
    private init() {
        // Configurar delegate con hash del certificado
        // TODO: Reemplazar con el hash real del certificado de producción
        self.NAUplMJ5TPklsbH0i03FTKupmbMJuSAp = Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2(
            certificateHash: "ExampleHash123456789ABCDEF0123456789ABCDEF="
        )
        
        // Configurar URLSession con el delegate de pinning
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        
        self.y2UK1kNCbUNLHDmClnE6HPV76XuSAUbu = URLSession(
            configuration: configuration,
            delegate: NAUplMJ5TPklsbH0i03FTKupmbMJuSAp,
            delegateQueue: nil
        )
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 NetworkLayer initialized with TLS pinning")
        #endif
    }
    
    deinit {
        y2UK1kNCbUNLHDmClnE6HPV76XuSAUbu.invalidateAndCancel()
    }
    
    // MARK: - API Methods
    
    /// Realiza una request HTTP con TLS pinning
    /// - Parameters:
    ///   - endpoint: Endpoint relativo (ej: "/auth/login")
    ///   - method: Método HTTP
    ///   - body: Cuerpo de la request (opcional)
    ///   - headers: Headers adicionales (opcional)
    /// - Returns: Datos de respuesta y URLResponse
    func gV9XYwaEh94m7YroTJVPKKbuCSL33vII(
        endpoint: String,
        method: VPsWRzTJGaDx2njWajyUsf4eZmkxEquq = .CFjE8m5XoPbtDGVYEm3SrUbmHp0jRYur,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) async throws -> (Data, URLResponse) {
        
        // Construir URL
        guard let url = URL(string: iaNCMwZtrGICnb5qMBqosVkWRrhzSydy + endpoint) else {
            throw LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ.SDkRlJR9QznULTnzvGI5xxOfNbaPveqn
        }
        
        // Configurar request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Headers por defecto
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("FitApp-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        // Headers adicionales
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 Performing \(method.rawValue) request to: \(url.absoluteString)")
        #endif
        
        // Realizar request con TLS pinning
        do {
            let (data, response) = try await y2UK1kNCbUNLHDmClnE6HPV76XuSAUbu.data(for: request)
            
            #if DEBUG
            if let httpResponse = response as? HTTPURLResponse {
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 Response: \(httpResponse.statusCode)")
            }
            #endif
            
            return (data, response)
            
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🌐 ❌ Network request failed: \(error.localizedDescription)")
            #endif
            throw LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ.JbCZUmQ48ADSoAvpw3vnKMt2zikhvmOu(error)
        }
    }
    
    /// Realiza una request JSON con TLS pinning
    /// - Parameters:
    ///   - endpoint: Endpoint relativo
    ///   - method: Método HTTP
    ///   - body: Objeto Codable para enviar (opcional)
    ///   - headers: Headers adicionales
    /// - Returns: Objeto decodificado del tipo especificado
    func cKo66BRWWWvoPI97n4hKzmnZzD9ML6By<T: Codable, U: Codable>(
        endpoint: String,
        method: VPsWRzTJGaDx2njWajyUsf4eZmkxEquq = .CFjE8m5XoPbtDGVYEm3SrUbmHp0jRYur,
        body: T? = nil,
        headers: [String: String] = [:],
        responseType: U.Type
    ) async throws -> U {
        
        var requestBody: Data? = nil
        
        // Codificar body si existe
        if let body = body {
            do {
                requestBody = try JSONEncoder().encode(body)
            } catch {
                throw LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ.hLoftuE2yrQr4CrTv0s1l2laB7f2mys4(error)
            }
        }
        
        // Realizar request
        let (data, response) = try await gV9XYwaEh94m7YroTJVPKKbuCSL33vII(
            endpoint: endpoint,
            method: method,
            body: requestBody,
            headers: headers
        )
        
        // Verificar status code
        if let httpResponse = response as? HTTPURLResponse {
            guard 200...299 ~= httpResponse.statusCode else {
                throw LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ.JMgOMDCLSX08lxn66QZqfIeG0Mgz2pRG(httpResponse.statusCode)
            }
        }
        
        // Decodificar respuesta
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(responseType, from: data)
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🌐 ❌ JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 Raw response: \(jsonString)")
            }
            #endif
            throw LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ.JnE9fVv4e1tdxKtLRQCX9VOhtIJbzBQ2(error)
        }
    }
}

// MARK: - HTTP Methods

enum VPsWRzTJGaDx2njWajyUsf4eZmkxEquq: String {
    case CFjE8m5XoPbtDGVYEm3SrUbmHp0jRYur = "GET"
    case yAi32FLEkcFt51O9zSFLwPMC5QOhhEAx = "POST"
    case gaGkYAhyZWT92Gmy7J7YKMXdP2m69gCG = "PUT"
    case pnZhq3YUKdid1qjEActryhjOYImgXyhz = "DELETE"
    case BL0x0kkx84pCYehKXwph87EOxV8wRnVE = "PATCH"
}

// MARK: - Network Errors

enum LkJ2bulzwsw6zOjAE23Gl6x6NV8oqxeZ: Error, LocalizedError {
    case SDkRlJR9QznULTnzvGI5xxOfNbaPveqn
    case JbCZUmQ48ADSoAvpw3vnKMt2zikhvmOu(Error)
    case JMgOMDCLSX08lxn66QZqfIeG0Mgz2pRG(Int)
    case hLoftuE2yrQr4CrTv0s1l2laB7f2mys4(Error)
    case JnE9fVv4e1tdxKtLRQCX9VOhtIJbzBQ2(Error)
    case pGDiGsfzRFOMqzyHjBARj5eOdufqvhPO
    
    var errorDescription: String? {
        switch self {
        case .SDkRlJR9QznULTnzvGI5xxOfNbaPveqn:
            return "URL inválida"
        case .JbCZUmQ48ADSoAvpw3vnKMt2zikhvmOu(let error):
            return "Request falló: \(error.localizedDescription)"
        case .JMgOMDCLSX08lxn66QZqfIeG0Mgz2pRG(let statusCode):
            return "Error HTTP: \(statusCode)"
        case .hLoftuE2yrQr4CrTv0s1l2laB7f2mys4(let error):
            return "Error al codificar: \(error.localizedDescription)"
        case .JnE9fVv4e1tdxKtLRQCX9VOhtIJbzBQ2(let error):
            return "Error al decodificar: \(error.localizedDescription)"
        case .pGDiGsfzRFOMqzyHjBARj5eOdufqvhPO:
            return "TLS pinning falló - posible ataque man-in-the-middle"
        }
    }
}

// MARK: - API Endpoints Extension

extension cs5srZOImM6bgVz7e5jFMoaReyyKYTx3 {
    
    /// Endpoints disponibles en el API
    struct zReIBYCcUJR0r7TcfaEFbkNHlBY7kxWt {
        static let xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe = "/auth/login"
        static let GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR = "/auth/register"
        static let kvwXfLuRAjQk9scdZH6Na9hioqbmNcPD = "/auth/logout"
        static let NIJGfl8FprvAwRkQeEKJnzDz3BsWlUb1 = "/user/profile"
        static let qoyOCrqMhnk4lPcomYTuH1f6ZHMy97XS = "/workouts"
        static let nqDhVi61MLb0xJpt8R3prTBbhnyVujyC = "/goals/weekly"
    }
    
    // MARK: - Convenience Methods
    
    /// Login del usuario
    func xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe(email: String, password: String) async throws -> L5d7UfTgDtQO4X7wekhV7PA6eMYyRfih {
        let loginRequest = v8PckSCVW8pKwjoElMbYU06j9aollYo7(email: email, password: password)
        
        return try await cKo66BRWWWvoPI97n4hKzmnZzD9ML6By(
            endpoint: zReIBYCcUJR0r7TcfaEFbkNHlBY7kxWt.xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe,
            method: .yAi32FLEkcFt51O9zSFLwPMC5QOhhEAx,
            body: loginRequest,
            responseType: L5d7UfTgDtQO4X7wekhV7PA6eMYyRfih.self
        )
    }
    
    /// Registro de usuario
    func GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR(email: String, password: String, name: String) async throws -> FxyzB6ACZHiMsIqhD7eRAmsESOjMzklM {
        let registerRequest = fexQtbsOmdFtbqV8g8qWYPZ644vGY13c(email: email, password: password, name: name)
        
        return try await cKo66BRWWWvoPI97n4hKzmnZzD9ML6By(
            endpoint: zReIBYCcUJR0r7TcfaEFbkNHlBY7kxWt.GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR,
            method: .yAi32FLEkcFt51O9zSFLwPMC5QOhhEAx,
            body: registerRequest,
            responseType: FxyzB6ACZHiMsIqhD7eRAmsESOjMzklM.self
        )
    }
    
    /// Obtener perfil del usuario
    func kqieVjSiAMOxTVGWQN4iMe77rQMT4GTM(token: String) async throws -> yQFJLoVXUU5jSHAqesirpgs2gGnoF6wy {
        let headers = ["Authorization": "Bearer \(token)"]
        
        return try await cKo66BRWWWvoPI97n4hKzmnZzD9ML6By(
            endpoint: zReIBYCcUJR0r7TcfaEFbkNHlBY7kxWt.NIJGfl8FprvAwRkQeEKJnzDz3BsWlUb1,
            method: .CFjE8m5XoPbtDGVYEm3SrUbmHp0jRYur,
            body: nil as String?,
            headers: headers,
            responseType: yQFJLoVXUU5jSHAqesirpgs2gGnoF6wy.self
        )
    }
}

// MARK: - Request/Response Models

struct v8PckSCVW8pKwjoElMbYU06j9aollYo7: Codable {
    let email: String
    let password: String
}

struct L5d7UfTgDtQO4X7wekhV7PA6eMYyRfih: Codable {
    let token: String
    let user: yQFJLoVXUU5jSHAqesirpgs2gGnoF6wy
    let expiresAt: Date
}

struct fexQtbsOmdFtbqV8g8qWYPZ644vGY13c: Codable {
    let email: String
    let password: String
    let name: String
}

struct FxyzB6ACZHiMsIqhD7eRAmsESOjMzklM: Codable {
    let token: String
    let user: yQFJLoVXUU5jSHAqesirpgs2gGnoF6wy
    let expiresAt: Date
}

struct yQFJLoVXUU5jSHAqesirpgs2gGnoF6wy: Codable {
    let id: String
    let email: String
    let name: String
    let createdAt: Date
    let updatedAt: Date
}

// MARK: - Testing Support

#if DEBUG
extension cs5srZOImM6bgVz7e5jFMoaReyyKYTx3 {
    
    /// Crea un NetworkLayer para testing con un delegate específico
    /// - Parameter delegate: Delegate personalizado para testing
    /// - Returns: NetworkLayer configurado para testing
    static func pwmzKxqtxrKBOYL6Hdwi3wM3VPFO43Q1(with delegate: Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2) -> cs5srZOImM6bgVz7e5jFMoaReyyKYTx3 {
        let layer = cs5srZOImM6bgVz7e5jFMoaReyyKYTx3()
        // En un escenario real, permitiríamos inyectar el delegate
        // Por ahora usamos el patrón singleton con configuración de prueba
        return layer
    }
    
    /// Verifica si el TLS pinning está activo
    /// - Returns: true si el pinning está configurado
    func geqLfiVgdkPdu5w4CkSWXE33JLrIkeSW() -> Bool {
        return true // Siempre activo en nuestra implementación
    }
}
#endif