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
        HStack(spacing: 16) {
            Circle()
                .fill(Color.green)
                .frame(width: 24, height: 24)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(habit.name)
                        .font(.headline)
                        .strikethrough()
                        .foregroundColor(.secondary)
                    Text(categoryEmoji)
                        .font(.subheadline)
                }
                
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Label("\(habit.streak) day streak", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 1)
    }
} 
