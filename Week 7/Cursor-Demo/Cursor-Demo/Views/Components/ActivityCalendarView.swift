import SwiftUI

struct ActivityCalendarView: View {
    let habit: Habit
    let numberOfDays: Int = 30 // Show last 30 days
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start week on Monday
        return calendar
    }
    
    private var dates: [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<numberOfDays).compactMap { days in
            calendar.date(byAdding: .day, value: -days, to: today)
        }.reversed()
    }
    
    private func activityLevel(for date: Date) -> Int {
        if habit.allowsMultipleCompletions {
            return habit.dailyCompletions[date, default: 0]
        } else {
            return habit.completionDates.contains(date) ? 1 : 0
        }
    }
    
    private func cellColor(for level: Int) -> Color {
        switch level {
        case 0:
            return Color(.systemGray6)
        case 1:
            return Color.purple.opacity(0.3)
        case 2:
            return Color.purple.opacity(0.5)
        case 3...:
            return Color.purple.opacity(0.8)
        default:
            return Color(.systemGray6)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Activity")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(dates, id: \.timeIntervalSince1970) { date in
                    let level = activityLevel(for: date)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(cellColor(for: level))
                        .frame(height: 20)
                        .overlay(
                            Group {
                                if calendar.isDateInToday(date) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .strokeBorder(Color.purple, lineWidth: 1)
                                }
                            }
                        )
                }
            }
            
            HStack {
                Text("Less")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ForEach(0..<4) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(cellColor(for: level))
                        .frame(width: 12, height: 12)
                }
                
                Text("More")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
} 