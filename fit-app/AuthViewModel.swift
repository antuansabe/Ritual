import Foundation
import SwiftUI
import os.log

class M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB: ObservableObject {
    @AppStorage("isAuthenticated") var exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH: Bool = false
    @Published var mhEi80qLCAtCbGeYgPfnpw820v8aCF9I: String = ""
    @Published var QZHDJgEWRERtPl00BdMoGaz3FxVErREZ: String = ""
    @Published var UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm: String = ""
    @Published var TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy: String?
    @Published var ZcyV56DImmWj4Y96j2b459YI8SvPQpMA: Bool = false
    
    // Rate limiting for login attempts
    @Published var DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH: Bool = false
    @Published var I0yXhmBO3RN418RpUxebkiSB9wa2n5cz: Int = 0
    
    // Apple Sign In Manager
    @ObservedObject private var oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz = Lx00e402Z63gwc4vKEC97NhbZVDDCOfA.shared
    
    // User Profile Manager
    @ObservedObject private var Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9 = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    // Secure Authentication Service
    private let npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG = wnGKnVVY25VSc4eWkvgZ2MLHXV6csLz2.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    // Secure Storage for sensitive data
    private let uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    // Login Rate Limiter
    private let dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB = aad5Y8PlamnXnoch5v7UeSToytIc7jOk.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    // Timer for updating remaining block time
    private var fdPgFGyASNv4JquarjXgOJFwIbVfNCa0: Timer?
    
    init() {
        #if DEBUG
        print("🔐 Initializing AuthViewModel...")
        #endif
        
        // Check for existing authentication first
        b7ySoQ7mKe7cm8lszm2bfsZiw1II2qSk()
        
        // Check both authentication methods on init
        kL2YZbAzod7j2gRjlVMJzCqagdhtYqk8()
        
        // Always listen to Apple authentication changes (even for new users)
        jdUTtyfNNOWYSENaRiGO7Eqghl1ErRC3()
        
        // Migrate any legacy sensitive data to secure storage
        SEkiryNEP5yWga7pzQodVSPXpYwGn8rw()
        
        // Initialize rate limiter status
        lf6xR3QIf4m6q1gv50MRc0XGlZVSntHx()
        
        // Test and verify secure storage (development)
        #if DEBUG
        _ = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.OvUBVQaLf4h3wpAtwsbuysyReR8ohfyV()
        uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.MrsQoTWHY45Peb8czR6H2yrUb89wDjub()
        #endif
    }
    
    // MARK: - Legacy Data Migration
    
    /// Migrate sensitive data from UserDefaults to SecureStorage
    private func SEkiryNEP5yWga7pzQodVSPXpYwGn8rw() {
        #if DEBUG
        print("🔄 Checking for legacy sensitive data to migrate...")
        #endif
        
        var migrationOccurred = false
        
        // Migrate userName if it exists
        if let userName = UserDefaults.standard.string(forKey: "userName"), !userName.isEmpty {
            #if DEBUG
            print("🔄 Migrating userName to SecureStorage...")
            #endif
            if uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(userName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) {
                UserDefaults.standard.removeObject(forKey: "userName")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userName")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userName")
                #endif
            }
        }
        
        // Migrate userIdentifier if it exists
        if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier"), !userIdentifier.isEmpty {
            #if DEBUG
            print("🔄 Migrating userIdentifier to SecureStorage...")
            #endif
            if uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(userIdentifier, for: "user_identifier") {
                UserDefaults.standard.removeObject(forKey: "userIdentifier")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userIdentifier")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userIdentifier")
                #endif
            }
        }
        
        // Migrate userFullName if it exists
        if let userFullName = UserDefaults.standard.string(forKey: "userFullName"), !userFullName.isEmpty {
            #if DEBUG
            print("🔄 Migrating userFullName to SecureStorage...")
            #endif
            if uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(userFullName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.gZQjJBUcdNVueyu0ArJZi8U47vNe5Kqi) {
                UserDefaults.standard.removeObject(forKey: "userFullName")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userFullName")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userFullName")
                #endif
            }
        }
        
        if migrationOccurred {
            #if DEBUG
            print("✅ Legacy sensitive data migration completed")
            #endif
        } else {
            #if DEBUG
            print("ℹ️ No legacy sensitive data found to migrate")
            #endif
        }
    }
    
    func xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe() {
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 AuthViewModel: Starting secure login process")
        #endif
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        
        // Check rate limiting before attempting login
        guard dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JC4lqsnhEGZaMN2Yt9yfueV0rFJ7v1kI() else {
            let remainingTime = dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JobPgKTqKe347RFYOzA7bdaPN8qquhAU()
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = "Demasiados intentos fallidos. Intenta de nuevo en \(remainingTime) segundos."
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.warning("🚨 Login blocked for \(remainingTime) seconds")
            lf6xR3QIf4m6q1gv50MRc0XGlZVSntHx()
            return
        }
        
        // Use secure authentication service
        let result = npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG.xhzYSvBqF2708nr4JnAdHR0kZEn4Z6fe(email: mhEi80qLCAtCbGeYgPfnpw820v8aCF9I, password: QZHDJgEWRERtPl00BdMoGaz3FxVErREZ)
        
        switch result {
        case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe(let user):
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 AuthViewModel: Login successful for user: \(user.email)")
            #endif
            // Reset rate limiter on successful login
            dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.hK71mCWltpYaEzPtPBFTwy7pVFueZTlu()
            exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = true
            // Create user profile for secure login
            Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9.vjYKdXVeyxIwMaRLPlJSwWYiL1A4pB5D(email: user.email)
            
        case .xfNSzDIg0uT6xWkWc0Fj5e864xzGSslF(let error):
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 AuthViewModel: Login failed - \(error.localizedDescription)")
            #endif
            // Record failed attempt
            dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.xP7Z01JKpdVTq21msPWS9YznNUWK57Ao()
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = error.localizedDescription
            
            // Check if this failure caused a lockout
            lf6xR3QIf4m6q1gv50MRc0XGlZVSntHx()
            if dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JobPgKTqKe347RFYOzA7bdaPN8qquhAU() > 0 {
                let remainingTime = dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JobPgKTqKe347RFYOzA7bdaPN8qquhAU()
                TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = "Demasiados intentos fallidos. Bloqueado por \(remainingTime) segundos."
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.warning("🚨 Login blocked for \(remainingTime) seconds after failed attempt")
            }
        }
    }
    
    func GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR() {
        #if DEBUG
        print("🔐 AuthViewModel: Starting secure registration process")
        #endif
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        
        // Use secure authentication service for registration
        let result = npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG.GUKgzh2HAr1vFLofjElwmrtdn4gOv8bR(email: mhEi80qLCAtCbGeYgPfnpw820v8aCF9I, password: QZHDJgEWRERtPl00BdMoGaz3FxVErREZ, confirmPassword: UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm)
        
        switch result {
        case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe(let user):
            #if DEBUG
            print("🔐 AuthViewModel: Registration successful for user: \(user.email)")
            #endif
            exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = true
            // Create user profile for new registration
            Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9.vjYKdXVeyxIwMaRLPlJSwWYiL1A4pB5D(email: user.email)
            
        case .xfNSzDIg0uT6xWkWc0Fj5e864xzGSslF(let error):
            #if DEBUG
            print("🔐 AuthViewModel: Registration failed - \(error.localizedDescription)")
            #endif
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = error.localizedDescription
        }
    }
    
    func kvwXfLuRAjQk9scdZH6Na9hioqbmNcPD() {
        #if DEBUG
        print("🛚 Logging out user...")
        #endif
        
        // Check if user is signed in with Apple and sign them out
        if oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0 {
            #if DEBUG
            print("   - Signing out Apple user")
            #endif
            oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
        } else {
            // Use secure authentication service for regular logout
            _ = npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG.kvwXfLuRAjQk9scdZH6Na9hioqbmNcPD()
        }
        
        // Sign out user profile
        Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
        
        // Clear sensitive data from SecureStorage
        _ = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.gZQjJBUcdNVueyu0ArJZi8U47vNe5Kqi)
        _ = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        _ = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.an8EQdG4sbWLiCnAmX9GlribmSjMTM7A)
        _ = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.QPcT4AroqypAx0yzycrRs5zbG3JqOqXm)
        
        // Clear legacy UserDefaults for migration (but preserve welcome flag)
        UserDefaults.standard.removeObject(forKey: "userIdentifier")
        UserDefaults.standard.removeObject(forKey: "userFullName") 
        UserDefaults.standard.removeObject(forKey: "userName")
        // Note: We intentionally keep "hasSeenWelcome" so returning users don't see welcome again
        
        // Instead of going directly to login, show goodbye screen first
        ZcyV56DImmWj4Y96j2b459YI8SvPQpMA = true
        
        // Clear authentication state but keep user logged in until goodbye is dismissed
        mhEi80qLCAtCbGeYgPfnpw820v8aCF9I = ""
        QZHDJgEWRERtPl00BdMoGaz3FxVErREZ = ""
        UGRTONb8WgYcFf6vJNi6Z18uGgZAOQHm = ""
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        
        #if DEBUG
        print("✅ User data cleared, showing goodbye screen")
        #endif
    }
    
    func xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y() {
        // Alias for logout to match the prompt requirements
        kvwXfLuRAjQk9scdZH6Na9hioqbmNcPD()
    }
    
    func WclnnxV7r3qvqAkYbmZKSt0rHWBOFLp7() {
        #if DEBUG
        print("🏠 Completing logout process...")
        #endif
        exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = false
        ZcyV56DImmWj4Y96j2b459YI8SvPQpMA = false
        #if DEBUG
        print("✅ User fully logged out, returning to login")
        #endif
    }
    
    // MARK: - Welcome Flow Management
    
    func ztuC6ouObpK3d02zNnL26mSYTqqAWYcM() {
        UserDefaults.standard.removeObject(forKey: "hasSeenWelcome")
        #if DEBUG
        print("🔄 Welcome flag reset - next login will show welcome screen")
        #endif
    }
    
    // MARK: - Authentication Status Check
    
    private func b7ySoQ7mKe7cm8lszm2bfsZiw1II2qSk() {
        #if DEBUG
        print("🔍 Checking for existing authentication...")
        #endif
        
        // Check if user is already authenticated via AppStorage
        if exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH {
            #if DEBUG
            print("   - User already authenticated via AppStorage")
            #endif
            return
        }
        
        // Check for Apple Sign In auto-login
        if oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0 && !oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.userIdentifier.isEmpty {
            #if DEBUG
            print("   - Found existing Apple user credentials")
            print("   - User ID: \(oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.userIdentifier)")
            print("   - Email: \(oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.userEmail)")
            print("   - Auto-logging in Apple user...")
            #endif
            
            // Auto-login the Apple user
            DispatchQueue.main.async {
                self.exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = true
                #if DEBUG
                print("✅ Apple user auto-logged in successfully")
                #endif
            }
        } else if npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG.E12V0aQwfC8BL7OIoZCT6O1kQ9W1JECk() {
            // Check for secure authentication session
            if let currentUser = npjcTEY1LlpH9CE22XQrqJyOZZ8DVSGG.ocWrWN1mMBZWWSNXkkLBqeUUPgN0dIV3() {
                #if DEBUG
                print("   - Found existing secure user session for: \(currentUser)")
                print("   - Auto-logging in secure user...")
                #endif
                
                DispatchQueue.main.async {
                    self.exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = true
                    self.mhEi80qLCAtCbGeYgPfnpw820v8aCF9I = currentUser
                    #if DEBUG
                    print("✅ Secure user auto-logged in successfully")
                    #endif
                }
            }
        }
    }
    
    private func kL2YZbAzod7j2gRjlVMJzCqagdhtYqk8() {
        #if DEBUG
        print("🔍 Checking authentication status...")
        #endif
        
        // Check Apple Sign In status for existing users
        if oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0 && !oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.userIdentifier.isEmpty {
            #if DEBUG
            print("   - Found existing Apple user, checking status...")
            #endif
            oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.kvGFwCUlCmaJEUnAj1QJ2rdHtxiCBZeK()
        }
        
        #if DEBUG
        print("   - Current auth status: \(exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH)")
        #endif
    }
    
    private func jdUTtyfNNOWYSENaRiGO7Eqghl1ErRC3() {
        #if DEBUG
        print("🔗 Setting up Apple authentication listener...")
        #endif
        
        // Listen to Apple authentication changes (for both existing and new users)
        oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.$isAuthenticated
            .sink { [weak self] isAppleAuthenticated in
                DispatchQueue.main.async {
                    if isAppleAuthenticated {
                        #if DEBUG
                        print("✅ Apple user authenticated - updating AuthViewModel")
                        #endif
                        self?.exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = true
                    } else {
                        // Only log out if this was an Apple user previously
                        if self?.oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0 == true {
                            #if DEBUG
                            print("❌ Apple user lost authentication - logging out")
                            #endif
                            self?.o6NxGozTIIZAlllT79izSyFAv6unfiLz()
                        }
                    }
                }
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
    }
    
    private func o6NxGozTIIZAlllT79izSyFAv6unfiLz() {
        #if DEBUG
        print("🛚 Handling Apple Sign Out...")
        #endif
        
        // Only clear authentication if user was logged in via Apple
        if oQh2fiXPlhdP5awrZrU3rWsw3Hzv0wsz.U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0 {
            exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = false
            #if DEBUG
            print("✅ Apple user logged out from AuthViewModel")
            #endif
        }
    }
    
    // MARK: - Rate Limiting Methods
    
    /// Updates the login block status based on rate limiter state
    private func lf6xR3QIf4m6q1gv50MRc0XGlZVSntHx() {
        let canAttempt = dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JC4lqsnhEGZaMN2Yt9yfueV0rFJ7v1kI()
        let remainingTime = dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JobPgKTqKe347RFYOzA7bdaPN8qquhAU()
        
        DispatchQueue.main.async {
            self.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH = !canAttempt
            self.I0yXhmBO3RN418RpUxebkiSB9wa2n5cz = remainingTime
            
            if remainingTime > 0 {
                self.brKR9X3OyBTDRpqiXTsZHvVhcbb5POSN()
            } else {
                self.T0K4io4EcQIHBC8WkOTgmcNl4lT7jpO2()
            }
        }
    }
    
    /// Starts a timer to update remaining block time
    private func brKR9X3OyBTDRpqiXTsZHvVhcbb5POSN() {
        T0K4io4EcQIHBC8WkOTgmcNl4lT7jpO2() // Stop any existing timer
        
        fdPgFGyASNv4JquarjXgOJFwIbVfNCa0 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let remainingTime = self.dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.JobPgKTqKe347RFYOzA7bdaPN8qquhAU()
            DispatchQueue.main.async {
                self.I0yXhmBO3RN418RpUxebkiSB9wa2n5cz = remainingTime
                
                if remainingTime <= 0 {
                    self.DYqqj6X2pcu9d8yEdJ6zrkgUsOKu40YH = false
                    self.T0K4io4EcQIHBC8WkOTgmcNl4lT7jpO2()
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔓 Login rate limit expired - access restored")
                    #endif
                }
            }
        }
    }
    
    /// Stops the block timer
    private func T0K4io4EcQIHBC8WkOTgmcNl4lT7jpO2() {
        fdPgFGyASNv4JquarjXgOJFwIbVfNCa0?.invalidate()
        fdPgFGyASNv4JquarjXgOJFwIbVfNCa0 = nil
    }
    
    /// Gets the current rate limiter status for debugging
    func HsFIGkTCJxGaHE14kysd6Bjsp8NJyZnG() -> (attempts: Int, isLocked: Bool, remainingTime: Int) {
        return dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.jmomiU8basFUoOBKuhLhEeldqFhu2mpt()
    }
    
    /// Resets the rate limiter (for testing/admin purposes)
    func mMD5ZK2vForefk0B6QvAgkQEyfxbY6GK() {
        #if DEBUG
        dUd6f1yX875RUhAaUdnUqH9Pvqa8jFxB.rNyZjOF1rAnctHfvZf5xu19UnjwTqbYY()
        lf6xR3QIf4m6q1gv50MRc0XGlZVSntHx()
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔄 Rate limiter reset by admin")
        #endif
    }
    
    deinit {
        T0K4io4EcQIHBC8WkOTgmcNl4lT7jpO2()
    }
    
    // MARK: - Combine
    private var e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg = Set<AnyCancellable>()
}

import Combine