import Foundation

class Config {
    static let shared = Config()
    
    private init() {}
    
    // MARK: - Configuration Values
    
    var apiKey: String {
        return getValue(for: "API_KEY") ?? "YOUR_API_KEY_HERE"
    }
    
    var databaseURL: String {
        return getValue(for: "DATABASE_URL") ?? "YOUR_DATABASE_URL_HERE"
    }
    
    var encryptionKey: String {
        return getValue(for: "ENCRYPTION_KEY") ?? "YOUR_ENCRYPTION_KEY_HERE"
    }
    
    var cloudKitContainer: String {
        return getValue(for: "CLOUDKIT_CONTAINER") ?? "YOUR_CLOUDKIT_CONTAINER_HERE"
    }
    
    var appleSignInClientID: String {
        return getValue(for: "APPLE_SIGNIN_CLIENT_ID") ?? "YOUR_APPLE_SIGNIN_CLIENT_ID_HERE"
    }
    
    // MARK: - Private Methods
    
    private func getValue(for key: String) -> String? {
        #if DEBUG
        // In DEBUG mode, read from Config.plist
        return getValueFromPlist(key: key)
        #else
        // In RELEASE mode, read from environment variables
        return ProcessInfo.processInfo.environment[key]
        #endif
    }
    
    private func getValueFromPlist(key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return plist[key] as? String
    }
}