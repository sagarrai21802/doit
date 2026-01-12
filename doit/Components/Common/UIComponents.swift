import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryBackground))
                        .padding(.trailing, 8)
                }
                
                Text(title)
                    .font(AppFonts.button)
                    .foregroundColor(AppColors.primaryBackground)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.primaryText)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}

struct OnboardingInputField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
            .padding()
            .frame(height: 56)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.border, lineWidth: 1)
            )
            .keyboardType(keyboardType)
            .accentColor(AppColors.accent)
    }
}
