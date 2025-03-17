import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var habitStore: HabitStore
    let habit: Habit
    
    @State private var name: String
    @State private var description: String
    @State private var priority: Habit.Priority
    @State private var reminderTime: Date
    @State private var hasReminder: Bool
    @State private var allowsMultipleCompletions: Bool
    
    init(habitStore: HabitStore, habit: Habit) {
        self.habitStore = habitStore
        self.habit = habit
        _name = State(initialValue: habit.name)
        _description = State(initialValue: habit.description)
        _priority = State(initialValue: habit.priority)
        _reminderTime = State(initialValue: habit.reminderTime ?? Date())
        _hasReminder = State(initialValue: habit.reminderTime != nil)
        _allowsMultipleCompletions = State(initialValue: habit.allowsMultipleCompletions)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name", text: $name)
                    TextField("Description", text: $description)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Habit.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
                
                Section(header: Text("Reminder")) {
                    Toggle("Enable Reminder", isOn: $hasReminder)
                    
                    if hasReminder {
                        DatePicker("Reminder Time",
                                 selection: $reminderTime,
                                 displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Completion Settings")) {
                    Toggle("Allow Multiple Completions per Day", isOn: $allowsMultipleCompletions)
                }
                
                Section(header: Text("Statistics")) {
                    HStack {
                        Text("Current Streak")
                        Spacer()
                        Text("\(habit.streak) days")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Total Completions")
                        Spacer()
                        Text("\(habit.completionDates.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveHabit()
                }
                .disabled(name.isEmpty)
            )
        }
    }
    
    private func saveHabit() {
        var updatedHabit = habit
        updatedHabit.name = name
        updatedHabit.description = description
        updatedHabit.priority = priority
        updatedHabit.reminderTime = hasReminder ? reminderTime : nil
        updatedHabit.allowsMultipleCompletions = allowsMultipleCompletions
        
        habitStore.updateHabit(updatedHabit)
        dismiss()
    }
} 