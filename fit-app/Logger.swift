import Foundation
import os.log

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.antonio.fit-app"
    
    // MARK: - Logger Categories
    static let auth = Logger(subsystem: subsystem, category: "auth")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let storage = Logger(subsystem: subsystem, category: "storage")
    static let cloudkit = Logger(subsystem: subsystem, category: "cloudkit")
    static let encryption = Logger(subsystem: subsystem, category: "encryption")
    static let validation = Logger(subsystem: subsystem, category: "validation")
    static let workout = Logger(subsystem: subsystem, category: "workout")
    static let profile = Logger(subsystem: subsystem, category: "profile")
    static let ui = Logger(subsystem: subsystem, category: "ui")
    static let general = Logger(subsystem: subsystem, category: "general")
}