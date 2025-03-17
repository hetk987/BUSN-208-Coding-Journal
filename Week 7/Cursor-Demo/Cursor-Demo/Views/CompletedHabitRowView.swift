import SwiftUI

struct CompletedHabitRowView: View {
    let habit: Habit
    let onEdit: () -> Void
    
    private var categoryEmoji: String {
        switch habit.category {
        case .health: return "💪"
        case .productivity: return "⚡️"
        case .learning: return "📚"
        case .lifestyle: return "🌟"
        case .other: return "✨"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(categoryEmoji)
                        .font(.title3)
                    Text(habit.name)
                        .font(.headline)
                }
                
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Label(habit.category.rawValue, systemImage: "tag.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(habit.priority.rawValue, systemImage: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .opacity(0.8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: habit.color).opacity(0.1))
        )
        .contentShape(Rectangle())
    }
} 
