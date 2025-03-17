import SwiftUI

struct StatsView: View {
    @ObservedObject var habitStore: HabitStore
    let habit: Habit
    
    private let calendar = Calendar.current
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Completion History")
                    .font(.title)
                    .padding(.horizontal)
                
                CalendarView(habit: habit, selectedDate: $selectedDate)
                    .frame(height: 300)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Legend")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        LegendItem(color: .green, text: "Completed")
                        LegendItem(color: .red, text: "Missed")
                        LegendItem(color: .gray.opacity(0.3), text: "Future")
                    }
                }
                .padding(.horizontal)
                
                if let completionCount = habit.dailyCompletions[calendar.startOfDay(for: selectedDate)] {
                    Text("Completions on \(selectedDate.formatted(date: .long, time: .omitted)): \(completionCount)")
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("\(habit.name) Stats")
    }
}

struct CalendarView: View {
    let habit: Habit
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthTitle: String {
        selectedDate.formatted(.dateTime.month().year())
    }
    
    private var daysInMonth: [Date] {
        let interval = DateInterval(start: startOfMonth(), end: endOfMonth())
        return calendar.generateDates(inside: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    private var firstWeekday: Int {
        calendar.component(.weekday, from: startOfMonth()) - 1
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Text(monthTitle)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            
            HStack {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                }
                
                ForEach(daysInMonth, id: \.self) { date in
                    DayCell(date: date, habit: habit, isSelected: calendar.isDate(date, inSameDayAs: selectedDate))
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
        }
    }
    
    private func startOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        return calendar.date(from: components)!
    }
    
    private func endOfMonth() -> Date {
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: startOfMonth())!
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct DayCell: View {
    let date: Date
    let habit: Habit
    let isSelected: Bool
    
    private let calendar = Calendar.current
    
    private var isCompleted: Bool {
        let startOfDay = calendar.startOfDay(for: date)
        if habit.allowsMultipleCompletions {
            return habit.dailyCompletions[startOfDay, default: 0] > 0
        } else {
            return habit.completionDates.contains(startOfDay)
        }
    }
    
    private var isMissed: Bool {
        let startOfDay = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        return date < today && !isCompleted
    }
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
    
    private var backgroundColor: Color {
        if isCompleted {
            return .green
        } else if isMissed {
            return .red
        } else if date > Date() {
            return .gray.opacity(0.3)
        }
        return .clear
    }
    
    private var foregroundColor: Color {
        if isCompleted || isMissed {
            return .white
        }
        return .primary
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
        }
    }
}

extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start,
                      matching: components,
                      matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
} 