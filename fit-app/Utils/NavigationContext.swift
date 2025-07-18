import SwiftUI

// MARK: - Navigation Context for Back Button Management
class NavigationContext: ObservableObject {
    @Published var isFromTab: Bool = false
    @Published var canDismiss: Bool = false
    
    init() {}
    
    func setTabContext() {
        isFromTab = true
        canDismiss = false
    }
    
    func setDetailContext() {
        isFromTab = false
        canDismiss = true
    }
    
    func reset() {
        isFromTab = false
        canDismiss = false
    }
}

// MARK: - Navigation Stack Manager (renamed to avoid conflicts)
class NavigationStackManager: ObservableObject {
    @Published var navigationStack: [String] = []
    @Published var currentTab: Int = 0
    
    func pushView(_ viewName: String) {
        navigationStack.append(viewName)
    }
    
    func popView() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
        }
    }
    
    func isRootView() -> Bool {
        return navigationStack.isEmpty
    }
    
    func canGoBack() -> Bool {
        return !navigationStack.isEmpty
    }
    
    func setCurrentTab(_ tab: Int) {
        currentTab = tab
        // Clear navigation stack when switching tabs
        navigationStack.removeAll()
    }
}

// MARK: - Environment Key for Navigation Context
private struct NavigationContextKey: EnvironmentKey {
    static let defaultValue = NavigationContext()
}

extension EnvironmentValues {
    var navigationContext: NavigationContext {
        get { self[NavigationContextKey.self] }
        set { self[NavigationContextKey.self] = newValue }
    }
}

// MARK: - View Extension for Navigation Context
extension View {
    func navigationContext(_ context: NavigationContext) -> some View {
        self.environment(\.navigationContext, context)
    }
}