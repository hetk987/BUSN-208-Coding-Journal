import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var priority: Priority
    var streak: Int
    var completionDates: [Date]
    var reminderTime: Date?
    var allowsMultipleCompletions: Bool
    var dailyCompletions: [Date: Int]
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    init(id: UUID = UUID(), name: String, description: String = "", priority: Priority = .medium, streak: Int = 0, completionDates: [Date] = [], reminderTime: Date? = nil, allowsMultipleCompletions: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.priority = priority
        self.streak = streak
        self.completionDates = completionDates
        self.reminderTime = reminderTime
        self.allowsMultipleCompletions = allowsMultipleCompletions
        self.dailyCompletions = [:]
    }
} 