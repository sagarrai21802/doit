import SwiftUI

struct SignInView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var phoneNumber: String = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showHome = false
    
    var body: some View {
        if showHome || userManager.isLoggedIn {
            HomeView()
        } else {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter your mobile number")
                            .font(AppFonts.header)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("We will create your account or log you in.")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        OnboardingInputField(
                            placeholder: "Mobile Number",
                            text: $phoneNumber,
                            keyboardType: .phonePad
                        )
                        
                        if showError {
                            Text(errorMessage)
                                .font(AppFonts.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    PrimaryButton(title: "Continue", isLoading: isLoading) {
                        registerUser()
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func registerUser() {
        guard phoneNumber.count >= 10 else {
            showError = true
            errorMessage = "Please enter a valid phone number"
            return
        }
        
        isLoading = true
        showError = false
        
        NetworkService.shared.registerUser(phoneNumber: phoneNumber) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let user):
                    print("✅ User registered: \(user.id)")
                    userManager.login(user: user)
                    showHome = true
                    
                case .failure(let error):
                    print("❌ Registration failed: \(error)")
                    showError = true
                    errorMessage = "Connection failed. Is the server running?"
                }
            }
        }
    }
}
