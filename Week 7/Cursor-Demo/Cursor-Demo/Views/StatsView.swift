import SwiftUI

struct StatsView: View {
    @ObservedObject var habitStore: HabitStore
    let habit: Habit
    
    private let calendar = Calendar.current
    private let daysToShow = 365
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Completion History")
                    .font(.title)
                    .padding(.horizontal)
                
                ContributionGraphView(habit: habit, daysToShow: daysToShow)
                    .frame(height: 200)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Legend")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        LegendItem(color: .green, text: "Completed")
                        LegendItem(color: .gray.opacity(0.3), text: "Not Completed")
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(habit.name) Stats")
    }
}

struct ContributionGraphView: View {
    let habit: Habit
    let daysToShow: Int
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<daysToShow, id: \.self) { dayOffset in
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date())!
                let startOfDay = calendar.startOfDay(for: date)
                
                let isCompleted = habit.allowsMultipleCompletions ?
                    habit.dailyCompletions[startOfDay, default: 0] > 0 :
                    habit.completionDates.contains(startOfDay)
                
                Rectangle()
                    .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(2)
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 12, height: 12)
                .cornerRadius(2)
            Text(text)
                .font(.caption)
        }
    }
} 