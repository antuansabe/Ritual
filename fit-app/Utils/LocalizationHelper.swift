import Foundation

// MARK: - Quick Localization Extension
extension String {
    /// Quick localization method - converts string key to localized string
    /// Usage: "START_BTN".t instead of NSLocalizedString("START_BTN", comment: "")
    var t: String {
        NSLocalizedString(self, comment: "")
    }
}

// MARK: - Localization Helper
class LocalizationHelper {
    
    /// Get all available localization keys from bundle
    static func getAllLocalizationKeys() -> [String] {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            return []
        }
        return Array(dict.keys).sorted()
    }
    
    /// Verify if a key exists in localization files
    static func keyExists(_ key: String) -> Bool {
        let localizedString = NSLocalizedString(key, comment: "")
        return localizedString != key
    }
    
    /// Get current language code
    static var currentLanguage: String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }
    
    /// Check if current language is Spanish
    static var isSpanish: Bool {
        return currentLanguage == "es"
    }
}