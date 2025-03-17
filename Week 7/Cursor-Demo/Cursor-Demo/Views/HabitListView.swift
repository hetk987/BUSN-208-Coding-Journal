import SwiftUI

struct HabitListView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habitStore.habits) { habit in
                    HabitRowView(habit: habit, onComplete: {
                        habitStore.completeHabit(habit)
                    })
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        habitStore.deleteHabit(habitStore.habits[index])
                    }
                }
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(habitStore: habitStore)
            }
        }
    }
}

struct HabitRowView: View {
    let habit: Habit
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                Text("Streak: \(habit.streak) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if habit.allowsMultipleCompletions {
                Text("\(habit.dailyCompletions[Calendar.current.startOfDay(for: Date()), default: 0])")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Button(action: onComplete) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 8)
    }
} 