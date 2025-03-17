import Foundation
import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var priority: Priority
    var streak: Int
    var completionDates: Set<Date>
    var reminderTime: Date?
    var allowsMultipleCompletions: Bool
    var dailyCompletions: [Date: Int]
    var category: Category
    var color: String // Store color as hex string
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    enum Category: String, Codable, CaseIterable {
        case health = "Health"
        case productivity = "Productivity"
        case learning = "Learning"
        case lifestyle = "Lifestyle"
        case other = "Other"
        
        var defaultColor: String {
            switch self {
            case .health: return "#FF6B6B"
            case .productivity: return "#4ECDC4"
            case .learning: return "#45B7D1"
            case .lifestyle: return "#96CEB4"
            case .other: return "#FFEEAD"
            }
        }
    }
    
    init(id: UUID = UUID(), name: String, description: String = "", priority: Priority = .medium, streak: Int = 0, completionDates: Set<Date> = [], reminderTime: Date? = nil, allowsMultipleCompletions: Bool = false, category: Category = .other, color: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.priority = priority
        self.streak = streak
        self.completionDates = completionDates
        self.reminderTime = reminderTime
        self.allowsMultipleCompletions = allowsMultipleCompletions
        self.dailyCompletions = [:]
        self.category = category
        self.color = color ?? category.defaultColor
    }
} 