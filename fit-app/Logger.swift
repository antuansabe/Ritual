import Foundation
import os.log

@available(iOS 14.0, *)
struct Logger {
    private static let subsystem = "com.antonio.fit-app"
    
    // MARK: - Logger Categories
    static let auth = os.Logger(subsystem: subsystem, category: "Authentication")
    static let network = os.Logger(subsystem: subsystem, category: "Network")
    static let storage = os.Logger(subsystem: subsystem, category: "Storage")
    static let cloudkit = os.Logger(subsystem: subsystem, category: "CloudKit")
    static let encryption = os.Logger(subsystem: subsystem, category: "Encryption")
    static let validation = os.Logger(subsystem: subsystem, category: "Validation")
    static let workout = os.Logger(subsystem: subsystem, category: "Workout")
    static let profile = os.Logger(subsystem: subsystem, category: "Profile")
    static let ui = os.Logger(subsystem: subsystem, category: "UI")
    static let general = os.Logger(subsystem: subsystem, category: "General")
    
    // MARK: - Convenience Methods
    static func debug(_ message: String, category: os.Logger = .general) {
        #if DEBUG
        category.debug("\(message)")
        #endif
    }
    
    static func info(_ message: String, category: os.Logger = .general) {
        #if DEBUG
        category.info("\(message)")
        #endif
    }
    
    static func error(_ message: String, category: os.Logger = .general) {
        #if DEBUG
        category.error("\(message)")
        #endif
    }
    
    static func warning(_ message: String, category: os.Logger = .general) {
        #if DEBUG
        category.notice("\(message)")
        #endif
    }
}