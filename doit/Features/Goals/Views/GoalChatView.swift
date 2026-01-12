import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryBackground) // Black text
                    .padding()
                    .background(AppColors.primaryText) // White bubble
                    .cornerRadius(16)
                    .padding(.horizontal)
            } else {
                Text(message.content)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText) // White text
                    .padding()
                    .background(AppColors.cardBackground) // Dark Gray bubble
                    .cornerRadius(16)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}

struct GoalChatView: View {
    let goal: Goal
    @StateObject private var viewModel: GoalChatViewModel
    
    init(goal: Goal) {
        self.goal = goal
        _viewModel = StateObject(wrappedValue: GoalChatViewModel(goalId: goal.id))
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (optional if Nav bar is enough, but custom is nice)
                
                // Chat Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Spacer for top content
                            Color.clear.frame(height: 12)
                            
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                HStack(spacing: 12) {
                    TextField("Message...", text: $viewModel.inputText)
                        .font(AppFonts.body)
                        .padding(12)
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(20)
                        .foregroundColor(AppColors.primaryText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.border, lineWidth: 1)
                        )
                    
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(viewModel.inputText.isEmpty ? AppColors.secondaryText : AppColors.accent)
                    }
                    .disabled(viewModel.inputText.isEmpty)
                }
                .padding()
                .background(AppColors.primaryBackground)
            }
        }
        .navigationBarTitle(goal.title, displayMode: .inline)
        .colorScheme(.dark) // Enforce dark keyboard
    }
}
