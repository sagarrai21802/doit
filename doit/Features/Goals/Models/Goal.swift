import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var targetDate: Date
    var createdAt: Date
    
    // Placeholder for future properties
    var streak: Int = 0
    var progress: Double = 0.0
    
    init(id: UUID = UUID(), title: String, description: String, targetDate: Date, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.createdAt = createdAt
    }
}
