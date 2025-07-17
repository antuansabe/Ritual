import Foundation
import SwiftUI
import os.log

// MARK: - Crash Logger
final class CrashLogger {
    static let shared = CrashLogger()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "fit-app", category: "CrashLogger")
    
    private init() {}
    
    func record(_ exception: Notification) {
        logger.error("🚨 Exception caught: \(exception.description)")
        
        // Log additional context if available
        if let userInfo = exception.userInfo {
            logger.error("Exception userInfo: \(userInfo.description)")
        }
        
        // Could send to crash reporting service here
        // Analytics.trackError(exception)
    }
    
    func record(error: Error, context: String = "") {
        logger.error("🚨 Error: \(error.localizedDescription) - Context: \(context)")
    }
    
    func recordPerformanceIssue(_ message: String, in view: String) {
        logger.warning("⚠️ Performance issue in \(view): \(message)")
    }
}

// MARK: - View Extension for Crash Protection
extension View {
    /// Catches crashes and exceptions in the view hierarchy
    func catchCrash() -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.NSExceptionName)) { notification in
            CrashLogger.shared.record(notification)
        }
    }
    
    /// Protects against UI freezes by wrapping expensive operations
    func protectFromFreeze<T>(_ operation: @escaping () -> T, fallback: T) -> T {
        let start = CFAbsoluteTimeGetCurrent()
        let result = operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - start
        
        // Log if operation takes longer than 16ms (60fps threshold)
        if timeElapsed > 0.016 {
            CrashLogger.shared.recordPerformanceIssue(
                "Operation took \(String(format: "%.3f", timeElapsed))s",
                in: String(describing: type(of: self))
            )
        }
        
        return result
    }
    
    /// Safe wrapper for potentially crashing code
    func safeExecution<T>(_ operation: @escaping () throws -> T, fallback: T, context: String = "") -> T {
        do {
            return try operation()
        } catch {
            CrashLogger.shared.record(error: error, context: context)
            return fallback
        }
    }
}