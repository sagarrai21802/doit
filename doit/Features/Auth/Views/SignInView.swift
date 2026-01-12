import SwiftUI

struct SignInView: View {
    @State private var phoneNumber: String = ""
    @State private var showOTP = false
    
    var body: some View {
        if showOTP {
            OTPVerificationView(phoneNumber: phoneNumber)
        } else {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter your mobile number")
                            .font(AppFonts.header)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("We will send you a confirmation code to log in.")
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
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    PrimaryButton(title: "Continue") {
                        if !phoneNumber.isEmpty {
                            withAnimation { showOTP = true }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
    }
}
