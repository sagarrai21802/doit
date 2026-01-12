import Foundation
import Combine

class GoalService: ObservableObject {
    @Published var goals: [Goal] = []
    
    init() {
        // Initial empty state or load from local storage
    }
    
    func addGoal(title: String, description: String, targetDate: Date) {
        let newGoal = Goal(title: title, description: description, targetDate: targetDate)
        goals.insert(newGoal, at: 0) // Newest first
    }
}
