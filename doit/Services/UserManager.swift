import Foundation
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: UserResponse?
    @Published var isLoggedIn: Bool = false
    
    private let userIdKey = "saved_user_id"
    private let phoneNumberKey = "saved_phone_number"
    
    private init() {
        // Check if user was previously logged in
        loadSavedUser()
    }
    
    func login(user: UserResponse) {
        self.currentUser = user
        self.isLoggedIn = true
        
        // Save to UserDefaults
        UserDefaults.standard.set(user.id, forKey: userIdKey)
        UserDefaults.standard.set(user.phone_number, forKey: phoneNumberKey)
    }
    
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
        
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: phoneNumberKey)
    }
    
    private func loadSavedUser() {
        if let userId = UserDefaults.standard.string(forKey: userIdKey),
           let phoneNumber = UserDefaults.standard.string(forKey: phoneNumberKey) {
            self.currentUser = UserResponse(id: userId, phone_number: phoneNumber, created_at: "")
            self.isLoggedIn = true
        }
    }
}
