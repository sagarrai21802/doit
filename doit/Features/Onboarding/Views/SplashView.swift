import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        if isActive {
            OnboardingView()
        } else {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                VStack {
                    Text("DoIt")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(opacity > 0 ? 1.0 : 0.8)
                    
                    Text("Achieve More")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.top, 8)
                }
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    self.opacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
