import Foundation
import os.log

/// Servicio de autenticación que maneja tokens y comunicación con el backend
/// Implementa automatic token refresh y manejo de expiración de tokens
class NetworkAuthService {
    
    // MARK: - Shared Instance
    
    static let shared = NetworkAuthService()
    
    // MARK: - Properties
    
    /// URLSession con TLS pinning configurado
    private let urlSession: URLSession
    
    /// Base URL del API de autenticación
    private let baseURL = "https://api.fitapp.com"
    
    /// Secure storage para tokens
    private let secureStorage = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    /// Keys para storage de tokens
    private struct StorageKeys {
        static let accessToken = "auth_access_token"
        static let refreshToken = "auth_refresh_token"
        static let tokenExpiry = "auth_token_expiry"
    }
    
    /// Lock para prevenir múltiples refresh simultáneos
    private let refreshLock = NSLock()
    private var isRefreshing = false
    
    // MARK: - Initialization
    
    private init() {
        // Reutilizar la configuración existente de NetworkLayer con TLS pinning
        let pinnedDelegate = Kje6QSfD1R5q6eqO6FPHaNSqLIp83CZ2(
            certificateHash: "ExampleHash123456789ABCDEF0123456789ABCDEF="
        )
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        
        self.urlSession = URLSession(
            configuration: configuration,
            delegate: pinnedDelegate,
            delegateQueue: nil
        )
        
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 NetworkAuthService initialized with TLS pinning")
        #endif
    }
    
    deinit {
        urlSession.invalidateAndCancel()
    }
    
    // MARK: - Public API
    
    /// Autentica usuario con email y contraseña
    /// - Parameters:
    ///   - email: Email del usuario
    ///   - password: Contraseña del usuario
    /// - Throws: NetworkAuthError en caso de error
    func authenticate(email: String, password: String) async throws {
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Starting authentication for email: \(email)")
        #endif
        
        // Construir request
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw NetworkAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("FitApp-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        // Preparar body
        let loginRequest = LoginRequest(email: email, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            throw NetworkAuthError.encodingError(error)
        }
        
        // Realizar request
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkAuthError.invalidResponse
            }
            
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Authentication response: \(httpResponse.statusCode)")
            #endif
            
            switch httpResponse.statusCode {
            case 200:
                // Parse successful response
                let tokenPair = try JSONDecoder().decode(TokenPair.self, from: data)
                try await storeTokens(tokenPair)
                
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 ✅ Authentication successful, tokens stored")
                #endif
                
            case 400:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.badRequest(errorResponse?.message ?? "Invalid request")
                
            case 401:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.unauthorized(errorResponse?.message ?? "Invalid credentials")
                
            case 500:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.serverError(errorResponse?.message ?? "Internal server error")
                
            default:
                throw NetworkAuthError.unexpectedStatusCode(httpResponse.statusCode)
            }
            
        } catch let error as NetworkAuthError {
            throw error
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🔐 ❌ Authentication network error: \(error.localizedDescription)")
            #endif
            throw NetworkAuthError.networkError(error)
        }
    }
    
    /// Renueva los tokens usando el refreshToken
    /// - Throws: NetworkAuthError en caso de error
    func refreshTokens() async throws {
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Starting token refresh")
        #endif
        
        // Prevent multiple simultaneous refresh attempts
        refreshLock.lock()
        defer { refreshLock.unlock() }
        
        if isRefreshing {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Token refresh already in progress, waiting...")
            #endif
            // Wait for current refresh to complete
            while isRefreshing {
                try await Task.sleep(nanoseconds: 100_000_000) // 100ms
            }
            return
        }
        
        isRefreshing = true
        defer { isRefreshing = false }
        
        // Get stored refresh token
        guard let refreshToken = try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.refreshToken) else {
            throw NetworkAuthError.noRefreshToken
        }
        
        // Construir request
        guard let url = URL(string: "\(baseURL)/auth/refresh") else {
            throw NetworkAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("FitApp-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        // Preparar body
        let refreshRequest = RefreshRequest(refreshToken: refreshToken)
        do {
            request.httpBody = try JSONEncoder().encode(refreshRequest)
        } catch {
            throw NetworkAuthError.encodingError(error)
        }
        
        // Realizar request
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkAuthError.invalidResponse
            }
            
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Token refresh response: \(httpResponse.statusCode)")
            #endif
            
            switch httpResponse.statusCode {
            case 200:
                // Parse successful response
                let tokenPair = try JSONDecoder().decode(TokenPair.self, from: data)
                try await storeTokens(tokenPair)
                
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 ✅ Token refresh successful")
                #endif
                
            case 400, 401:
                // Refresh token invalid or expired, clear all tokens
                try clearTokens()
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.refreshTokenExpired(errorResponse?.message ?? "Refresh token invalid")
                
            case 500:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.serverError(errorResponse?.message ?? "Internal server error")
                
            default:
                throw NetworkAuthError.unexpectedStatusCode(httpResponse.statusCode)
            }
            
        } catch let error as NetworkAuthError {
            throw error
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🔐 ❌ Token refresh network error: \(error.localizedDescription)")
            #endif
            throw NetworkAuthError.networkError(error)
        }
    }
    
    /// Cierra sesión y revoca tokens
    /// - Throws: NetworkAuthError en caso de error
    func logout() async throws {
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Starting logout")
        #endif
        
        // Construir request
        guard let url = URL(string: "\(baseURL)/auth/logout") else {
            throw NetworkAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("FitApp-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        // Add authorization header
        if let accessToken = try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.accessToken) {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Realizar request
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkAuthError.invalidResponse
            }
            
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Logout response: \(httpResponse.statusCode)")
            #endif
            
            switch httpResponse.statusCode {
            case 204:
                // Success - clear local tokens
                try clearTokens()
                
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 ✅ Logout successful, tokens cleared")
                #endif
                
            case 401:
                // Token already invalid, just clear local tokens
                try clearTokens()
                
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 ✅ Logout with invalid token, tokens cleared")
                #endif
                
            case 500:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.serverError(errorResponse?.message ?? "Internal server error")
                
            default:
                throw NetworkAuthError.unexpectedStatusCode(httpResponse.statusCode)
            }
            
        } catch let error as NetworkAuthError {
            throw error
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🔐 ❌ Logout network error: \(error.localizedDescription)")
            #endif
            throw NetworkAuthError.networkError(error)
        }
    }
    
    /// Elimina la cuenta del usuario
    /// - Parameter userID: ID único del usuario
    /// - Throws: NetworkAuthError en caso de error
    func deleteAccount(userID: String) async throws {
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Starting account deletion for user: \(userID)")
        #endif
        
        // Construir request con automatic token refresh
        let request = try await buildAuthenticatedRequest(
            path: "/users/\(userID)",
            method: "DELETE"
        )
        
        // Realizar request con retry en caso de 401
        try await performAuthenticatedRequest(request) { httpResponse, data in
            switch httpResponse.statusCode {
            case 204:
                // Success - clear local tokens
                try self.clearTokens()
                
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 ✅ Account deletion successful")
                #endif
                
            case 404:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.userNotFound(errorResponse?.message ?? "User not found")
                
            case 500:
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkAuthError.serverError(errorResponse?.message ?? "Internal server error")
                
            default:
                throw NetworkAuthError.unexpectedStatusCode(httpResponse.statusCode)
            }
        }
    }
    
    // MARK: - Token Management
    
    /// Verifica si hay tokens válidos almacenados
    /// - Returns: true si hay tokens válidos
    func hasValidTokens() -> Bool {
        guard let _ = try? secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.accessToken),
              let _ = try? secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.refreshToken) else {
            return false
        }
        
        // Check if access token is expired
        if let expiryString = try? secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.tokenExpiry),
           let expiryTimestamp = Double(expiryString) {
            let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
            return expiryDate > Date()
        }
        
        return true
    }
    
    /// Obtiene el access token actual
    /// - Returns: Access token si existe
    func getCurrentAccessToken() -> String? {
        return try? secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.accessToken)
    }
    
    // MARK: - Private Methods
    
    /// Almacena tokens de forma segura
    /// - Parameter tokenPair: Par de tokens del servidor
    private func storeTokens(_ tokenPair: TokenPair) async throws {
        // Calculate expiry time (current time + expiresIn seconds)
        let expiryTimestamp = Date().timeIntervalSince1970 + Double(tokenPair.expiresIn)
        
        do {
            try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(tokenPair.accessToken, for: StorageKeys.accessToken)
            try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(tokenPair.refreshToken, for: StorageKeys.refreshToken)
            try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(String(expiryTimestamp), for: StorageKeys.tokenExpiry)
            
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Tokens stored securely with AES-GCM encryption")
            #endif
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🔐 ❌ Failed to store tokens: \(error.localizedDescription)")
            #endif
            throw NetworkAuthError.storageError(error)
        }
    }
    
    /// Limpia todos los tokens almacenados
    private func clearTokens() throws {
        do {
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.accessToken)
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.refreshToken)
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.tokenExpiry)
            
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 All tokens cleared from secure storage")
            #endif
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Token cleanup completed (some tokens may not have existed)")
            #endif
        }
    }
    
    /// Construye request autenticado con Bearer token
    /// - Parameters:
    ///   - path: Path relativo del endpoint
    ///   - method: Método HTTP
    /// - Returns: URLRequest configurado
    private func buildAuthenticatedRequest(path: String, method: String) async throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw NetworkAuthError.invalidURL
        }
        
        guard let accessToken = try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.accessToken) else {
            throw NetworkAuthError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("FitApp-iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    /// Realiza request autenticado con retry automático en caso de 401
    /// - Parameters:
    ///   - request: Request a realizar
    ///   - responseHandler: Handler para procesar la respuesta
    private func performAuthenticatedRequest(
        _ request: URLRequest,
        responseHandler: @escaping (HTTPURLResponse, Data) async throws -> Void
    ) async throws {
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkAuthError.invalidResponse
            }
            
            if httpResponse.statusCode == 401 {
                #if DEBUG
                Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔐 Received 401, attempting token refresh...")
                #endif
                
                // Try to refresh tokens
                try await refreshTokens()
                
                // Rebuild request with new token
                let retryRequest = try await buildAuthenticatedRequest(
                    path: request.url?.path ?? "",
                    method: request.httpMethod ?? "GET"
                )
                
                // Retry once
                let (retryData, retryResponse) = try await urlSession.data(for: retryRequest)
                
                guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                    throw NetworkAuthError.invalidResponse
                }
                
                try await responseHandler(retryHttpResponse, retryData)
            } else {
                try await responseHandler(httpResponse, data)
            }
            
        } catch let error as NetworkAuthError {
            throw error
        } catch {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.error("🔐 ❌ Authenticated request failed: \(error.localizedDescription)")
            #endif
            throw NetworkAuthError.networkError(error)
        }
    }
}

// MARK: - Models

/// Request para login
private struct LoginRequest: Codable {
    let email: String
    let password: String
}

/// Request para refresh de tokens
private struct RefreshRequest: Codable {
    let refreshToken: String
}

/// Response con par de tokens
struct TokenPair: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    let issuedAt: String?
}

/// Response de error del servidor
private struct ErrorResponse: Codable {
    let error: String
    let message: String
    let timestamp: String?
    let requestId: String?
}

// MARK: - Errors

/// Errores específicos del servicio de autenticación
enum NetworkAuthError: Error, LocalizedError {
    case invalidURL
    case encodingError(Error)
    case decodingError(Error)
    case networkError(Error)
    case invalidResponse
    case badRequest(String)
    case unauthorized(String)
    case userNotFound(String)
    case serverError(String)
    case unexpectedStatusCode(Int)
    case storageError(Error)
    case noAccessToken
    case noRefreshToken
    case refreshTokenExpired(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .encodingError(let error):
            return "Error al codificar request: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Error al decodificar response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .badRequest(let message):
            return "Request inválida: \(message)"
        case .unauthorized(let message):
            return "No autorizado: \(message)"
        case .userNotFound(let message):
            return "Usuario no encontrado: \(message)"
        case .serverError(let message):
            return "Error del servidor: \(message)"
        case .unexpectedStatusCode(let code):
            return "Código de respuesta inesperado: \(code)"
        case .storageError(let error):
            return "Error de almacenamiento: \(error.localizedDescription)"
        case .noAccessToken:
            return "No hay access token disponible"
        case .noRefreshToken:
            return "No hay refresh token disponible"
        case .refreshTokenExpired(let message):
            return "Refresh token expirado: \(message)"
        }
    }
}