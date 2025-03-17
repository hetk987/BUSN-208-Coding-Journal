import SwiftUI

struct StatsView: View {
    @ObservedObject var habitStore: HabitStore
    
    private let calendar = Calendar.current
    private let daysToShow = 365
    private let columns = 7
    private let squareSize: CGFloat = 20
    private let spacing: CGFloat = 4
    
    private var dates: [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<daysToShow).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }
    }
    
    private func completionCount(for date: Date) -> Int {
        habitStore.habits.filter { habit in
            if habit.allowsMultipleCompletions {
                return habit.dailyCompletions[date, default: 0] > 0
            } else {
                return habit.completionDates.contains(date)
            }
        }.count
    }
    
    private func colorForCompletionCount(_ count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray6)
        case 1: return Color(hex: "#9BE9A8")
        case 2: return Color(hex: "#40C463")
        case 3: return Color(hex: "#30A14E")
        default: return Color(hex: "#216E39")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Contribution Graph
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Activity")
                            .font(.title2)
                            .bold()
                        
                        HStack(alignment: .top, spacing: spacing) {
                            ForEach(0..<columns, id: \.self) { column in
                                VStack(spacing: spacing) {
                                    ForEach(Array(dates.enumerated().filter { $0.offset % columns == column }), id: \.element) { _, date in
                                        let count = completionCount(for: date)
                                        Rectangle()
                                            .fill(colorForCompletionCount(count))
                                            .frame(width: squareSize, height: squareSize)
                                            .cornerRadius(2)
                                    }
                                }
                            }
                        }
                        
                        // Legend
                        HStack(spacing: 16) {
                            Text("Less")
                            ForEach(0...4, id: \.self) { count in
                                Rectangle()
                                    .fill(colorForCompletionCount(count))
                                    .frame(width: squareSize, height: squareSize)
                                    .cornerRadius(2)
                            }
                            Text("More")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Statistics
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Statistics")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            StatCard(
                                title: "Total Habits",
                                value: "\(habitStore.habits.count)",
                                icon: "list.bullet",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Completed Today",
                                value: "\(habitStore.habits.filter { isHabitCompleted($0) }.count)",
                                icon: "checkmark.circle",
                                color: .green
                            )
                        }
                        
                        HStack {
                            StatCard(
                                title: "Streaks",
                                value: "\(habitStore.habits.map { $0.streak }.max() ?? 0)",
                                icon: "flame",
                                color: .orange
                            )
                            
                            StatCard(
                                title: "Categories",
                                value: "\(Set(habitStore.habits.map { $0.category }).count)",
                                icon: "tag",
                                color: .purple
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Statistics")
        }
    }
    
    private func isHabitCompleted(_ habit: Habit) -> Bool {
        let today = calendar.startOfDay(for: Date())
        if habit.allowsMultipleCompletions {
            return habit.dailyCompletions[today, default: 0] > 0
        } else {
            return habit.completionDates.contains(today)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
} 