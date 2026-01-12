import SwiftUI

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @State private var currentSlide = 0
    @State private var showSignIn = false
    
    let slides = [
        OnboardingSlide(image: "onboarding_focus", title: "Focus On Your Goals", description: "Set your targets and achieve them with precision without distractions."),
        OnboardingSlide(image: "onboarding_roadmap", title: "AI Powered Roadmap", description: "Get personalized research and paths from people who have already achieved it."),
        OnboardingSlide(image: "onboarding_community", title: "Anonymous Community", description: "Connect with like-minded people anonymously and grow together.")
    ]
    
    var body: some View {
        if showSignIn {
            SignInView()
        } else {
            ZStack {
                AppColors.primaryBackground.ignoresSafeArea()
                
                VStack {
                    // Skip Button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            withAnimation { showSignIn = true }
                        }
                        .foregroundColor(AppColors.secondaryText)
                        .padding()
                    }
                    
                    TabView(selection: $currentSlide) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            VStack(spacing: 40) {
                                Image(slides[index].image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 300)
                                    .padding(.horizontal)
                                    .colorInvert() // Inverting black/white image for dark mode if needed, or remove if assets are white-on-transparent
                                
                                VStack(spacing: 16) {
                                    Text(slides[index].title)
                                        .font(AppFonts.header)
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(slides[index].description)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Paging Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Circle()
                                .fill(currentSlide == index ? AppColors.accent : AppColors.secondaryBackground)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    PrimaryButton(title: currentSlide == slides.count - 1 ? "Get Started" : "Next") {
                        if currentSlide < slides.count - 1 {
                            withAnimation { currentSlide += 1 }
                        } else {
                            withAnimation { showSignIn = true }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            // Transition needs to be handled by the parent view usually, but conditional rendering works for basic flow
        }
    }
}
