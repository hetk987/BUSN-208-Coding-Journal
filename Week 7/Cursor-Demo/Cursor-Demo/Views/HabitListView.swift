import SwiftUI

struct HabitListView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    @State private var showingEditHabit = false
    
    private var completedHabits: [Habit] {
        let today = Calendar.current.startOfDay(for: Date())
        return habitStore.habits.filter { habit in
            if habit.allowsMultipleCompletions {
                return habit.dailyCompletions[today, default: 0] > 0
            } else {
                return habit.completionDates.contains(today)
            }
        }
    }
    
    private var incompleteHabits: [Habit] {
        habitStore.habits.filter { !completedHabits.contains($0) }
    }
    
    var body: some View {
        NavigationView {
            List {
                if !incompleteHabits.isEmpty {
                    Section(header: Text("Active Habits")) {
                        ForEach(incompleteHabits) { habit in
                            HabitRowView(habit: habit, onComplete: {
                                habitStore.completeHabit(habit)
                            })
                            .contextMenu {
                                Button(action: {
                                    selectedHabit = habit
                                    showingEditHabit = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: {
                                    habitStore.deleteHabit(habit)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                habitStore.deleteHabit(incompleteHabits[index])
                            }
                        }
                    }
                }
                
                if !completedHabits.isEmpty {
                    Section(header: Text("Completed Today")) {
                        ForEach(completedHabits) { habit in
                            CompletedHabitRowView(habit: habit)
                        }
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
            .sheet(isPresented: $showingEditHabit) {
                if let habit = selectedHabit {
                    EditHabitView(habitStore: habitStore, habit: habit)
                }
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

struct CompletedHabitRowView: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                if habit.allowsMultipleCompletions {
                    Text("Completed \(habit.dailyCompletions[Calendar.current.startOfDay(for: Date()), default: 0]) times today")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
} 