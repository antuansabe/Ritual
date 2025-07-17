import Foundation
import Combine

final class NavigationStateManager: ObservableObject {
    @Published var rootTab: Int = 0          // 0-Inicio, 1-Registrar, ...
    @Published var showWelcome = false       // se activa 1 sola vez
    
    // MARK: - Methods
    
    /// Check if current view is root view for back button context
    func isRootView() -> Bool {
        return rootTab == 0
    }
    
    /// Navigate to specific tab
    func navigateToTab(_ tab: Int) {
        rootTab = tab
    }
    
    /// Trigger welcome flow
    func triggerWelcome() {
        showWelcome = true
    }
    
    /// Complete welcome flow
    func completeWelcome() {
        showWelcome = false
    }
}