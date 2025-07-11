import XCTest
import Foundation
import Security
@testable import fit_app

/// Unit tests para verificar el funcionamiento del TLS Certificate Pinning
class TLSPinningTests: XCTestCase {
    
    // MARK: - Properties
    
    private var testDelegate: PinnedSessionDelegate!
    private let validTestHash = "dGVzdF9jZXJ0aWZpY2F0ZV9oYXNoX3NoYTI1Ng==" // base64 de "test_certificate_hash_sha256"
    private let invalidTestHash = "aW52YWxpZF9oYXNoX2Zvcl90ZXN0aW5nX3B1cnBvc2Vz" // base64 de "invalid_hash_for_testing_purposes"
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        testDelegate = PinnedSessionDelegate.testDelegate(withHash: validTestHash)
    }
    
    override func tearDown() {
        testDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Hash Validation Tests
    
    func testValidCertificateHashFormat() {
        // Test: Hash válido en formato base64
        XCTAssertTrue(
            PinnedSessionDelegate.isValidCertificateHash(validTestHash),
            "Hash válido debe ser reconocido como válido"
        )
    }
    
    func testInvalidCertificateHashFormat() {
        // Test: Hash inválido (muy corto)
        XCTAssertFalse(
            PinnedSessionDelegate.isValidCertificateHash("invalid"),
            "Hash muy corto debe ser rechazado"
        )
        
        // Test: Hash inválido (no base64)
        XCTAssertFalse(
            PinnedSessionDelegate.isValidCertificateHash("invalid!@#$%^&*()hash_format_test_123456789="),
            "Hash con caracteres inválidos debe ser rechazado"
        )
        
        // Test: Hash inválido (longitud incorrecta)
        XCTAssertFalse(
            PinnedSessionDelegate.isValidCertificateHash("dGVzdA=="),
            "Hash muy corto debe ser rechazado"
        )
    }
    
    // MARK: - Pinning Simulation Tests
    
    func testPinMatchingSuccess() {
        // Test: Hash correcto debe pasar la verificación
        let result = testDelegate.simulatePinningVerification(
            expectedHash: validTestHash,
            serverHash: validTestHash
        )
        
        XCTAssertTrue(result, "Hash correcto debe pasar la verificación de pinning")
    }
    
    func testPinMismatchFails() {
        // Test: Hash incorrecto debe fallar la verificación
        let result = testDelegate.simulatePinningVerification(
            expectedHash: validTestHash,
            serverHash: invalidTestHash
        )
        
        XCTAssertFalse(result, "Hash incorrecto debe fallar la verificación de pinning")
    }
    
    func testPinMismatchWithEmptyHash() {
        // Test: Hash vacío debe fallar
        let result = testDelegate.simulatePinningVerification(
            expectedHash: validTestHash,
            serverHash: ""
        )
        
        XCTAssertFalse(result, "Hash vacío debe fallar la verificación de pinning")
    }
    
    // MARK: - URL Session Challenge Tests
    
    func testNonServerTrustChallengeUsesDefaultHandling() {
        let expectation = self.expectation(description: "Challenge completion")
        
        // Crear un mock challenge que no sea server trust
        let protectionSpace = URLProtectionSpace(
            host: "api.fitapp.com",
            port: 443,
            protocol: "https",
            realm: nil,
            authenticationMethod: NSURLAuthenticationMethodHTTPBasic
        )
        
        let challenge = URLAuthenticationChallenge(
            protectionSpace: protectionSpace,
            proposedCredential: nil,
            previousFailureCount: 0,
            failureResponse: nil,
            error: nil,
            sender: MockAuthenticationChallengeSender()
        )
        
        testDelegate.urlSession(
            URLSession.shared,
            didReceive: challenge
        ) { disposition, credential in
            XCTAssertEqual(disposition, .performDefaultHandling, "Non-server trust should use default handling")
            XCTAssertNil(credential, "No credential should be provided for non-server trust")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testDifferentDomainUsesDefaultHandling() {
        let expectation = self.expectation(description: "Challenge completion")
        
        // Crear challenge para dominio diferente
        let protectionSpace = URLProtectionSpace(
            host: "different-domain.com",
            port: 443,
            protocol: "https",
            realm: nil,
            authenticationMethod: NSURLAuthenticationMethodServerTrust
        )
        
        let challenge = URLAuthenticationChallenge(
            protectionSpace: protectionSpace,
            proposedCredential: nil,
            previousFailureCount: 0,
            failureResponse: nil,
            error: nil,
            sender: MockAuthenticationChallengeSender()
        )
        
        testDelegate.urlSession(
            URLSession.shared,
            didReceive: challenge
        ) { disposition, credential in
            XCTAssertEqual(disposition, .performDefaultHandling, "Different domain should use default handling")
            XCTAssertNil(credential, "No credential should be provided for different domain")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - TLS Pinning Error Tests
    
    func testTLSPinningErrorDescriptions() {
        let noCertError = TLSPinningError.noCertificateFound
        XCTAssertNotNil(noCertError.errorDescription, "Error debe tener descripción")
        
        let invalidDataError = TLSPinningError.invalidCertificateData
        XCTAssertNotNil(invalidDataError.errorDescription, "Error debe tener descripción")
        
        let hashMismatchError = TLSPinningError.hashMismatch(expected: "hash1", actual: "hash2")
        XCTAssertNotNil(hashMismatchError.errorDescription, "Error debe tener descripción")
        XCTAssertTrue(
            hashMismatchError.errorDescription!.contains("hash1"),
            "Descripción debe incluir hash esperado"
        )
        XCTAssertTrue(
            hashMismatchError.errorDescription!.contains("hash2"),
            "Descripción debe incluir hash actual"
        )
        
        let trustError = TLSPinningError.trustEvaluationFailed
        XCTAssertNotNil(trustError.errorDescription, "Error debe tener descripción")
    }
    
    // MARK: - NetworkLayer Integration Tests
    
    func testNetworkLayerHasTLSPinningEnabled() {
        let networkLayer = NetworkLayer.shared
        
        XCTAssertTrue(
            networkLayer.isTLSPinningEnabled(),
            "NetworkLayer debe tener TLS pinning habilitado"
        )
    }
    
    func testNetworkLayerInitialization() {
        // Test que NetworkLayer se inicializa correctamente
        let networkLayer = NetworkLayer.shared
        
        // Verificar que no es nil
        XCTAssertNotNil(networkLayer, "NetworkLayer debe inicializarse correctamente")
        
        // Verificar configuración de pinning
        XCTAssertTrue(
            networkLayer.isTLSPinningEnabled(),
            "TLS pinning debe estar habilitado"
        )
    }
    
    // MARK: - Example Hash Tests
    
    func testExampleHashIsValid() {
        let exampleHash = PinnedSessionDelegate.exampleCertificateHash
        
        XCTAssertTrue(
            PinnedSessionDelegate.isValidCertificateHash(exampleHash),
            "Example hash debe tener formato válido"
        )
    }
    
    func testExampleDelegateCreation() {
        let exampleDelegate = PinnedSessionDelegate.exampleDelegate()
        
        XCTAssertNotNil(exampleDelegate, "Example delegate debe crearse correctamente")
    }
    
    // MARK: - Performance Tests
    
    func testHashValidationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = PinnedSessionDelegate.isValidCertificateHash(validTestHash)
            }
        }
    }
    
    func testPinningSimulationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = testDelegate.simulatePinningVerification(
                    expectedHash: validTestHash,
                    serverHash: validTestHash
                )
            }
        }
    }
}

// MARK: - Mock Classes for Testing

/// Mock sender para URLAuthenticationChallenge en tests
class MockAuthenticationChallengeSender: NSObject, URLAuthenticationChallengeSender {
    
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        // Mock implementation
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        // Mock implementation
    }
    
    func cancel(_ challenge: URLAuthenticationChallenge) {
        // Mock implementation
    }
    
    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        // Mock implementation
    }
    
    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        // Mock implementation
    }
}

// MARK: - Test Extensions

extension TLSPinningTests {
    
    /// Genera un hash SHA-256 de prueba válido
    static func generateTestHash(from string: String) -> String {
        let data = string.data(using: .utf8)!
        return data.base64EncodedString()
    }
    
    /// Verifica que un hash tenga el formato correcto para SHA-256
    func assertValidSHA256Hash(_ hash: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(
            PinnedSessionDelegate.isValidCertificateHash(hash),
            "Hash debe tener formato SHA-256 válido",
            file: file,
            line: line
        )
    }
}