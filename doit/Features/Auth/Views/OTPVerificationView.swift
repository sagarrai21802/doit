import SwiftUI

struct OTPVerificationView: View {
    let phoneNumber: String
    @State private var otp: String = ""
    @State private var navigateToHome = false
    @State private var showError = false
    
    var body: some View {
        if navigateToHome {
            HomeView()
        } else {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter code")
                            .font(AppFonts.header)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("We've sent a 4-digit code to \(phoneNumber)")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        OnboardingInputField(
                            placeholder: "XXXX",
                            text: $otp,
                            keyboardType: .numberPad
                        )
                        .onChange(of: otp) { newValue in
                            if newValue.count > 4 {
                                otp = String(newValue.prefix(4))
                            }
                        }
                        
                        if showError {
                            Text("Invalid Code. Use 1234")
                                .font(AppFonts.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    PrimaryButton(title: "Verify") {
                        if otp == "1234" {
                            withAnimation { navigateToHome = true }
                        } else {
                            showError = true
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
    }
}
