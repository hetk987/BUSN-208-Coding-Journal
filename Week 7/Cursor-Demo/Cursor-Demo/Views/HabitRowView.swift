import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let isSelected: Bool
    let onSelect: () -> Void
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
            Button(action: onSelect) {
                Circle()
                    .fill(isSelected ? Color(hex: habit.color) : Color(.systemGray5))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: isSelected ? "checkmark" : "")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(habit.name)
                        .font(.headline)
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
