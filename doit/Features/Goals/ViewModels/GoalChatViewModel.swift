import Foundation
import Combine

class GoalChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    
    let goalId: UUID
    
    init(goalId: UUID) {
        self.goalId = goalId
        // Initial welcome message
        self.messages = [
            Message(content: "Welcome! I'm here to help you achieve your goal. Let's start by breaking this down. What's the first thing you think you need to do?", isUser: false)
        ]
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMsg = Message(content: inputText, isUser: true)
        messages.append(userMsg)
        
        let sentText = inputText
        inputText = ""
        
        // Simulate AI Response (Dummy for now)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.generateAIResponse(for: sentText)
        }
    }
    
    private func generateAIResponse(for input: String) {
        let response = Message(content: "That sounds like a great plan. I can help you research resources for '\(input)'. Shall we add that to your roadmap?", isUser: false)
        messages.append(response)
    }
}
