import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var habitStore: HabitStore
    
    @State private var name = ""
    @State private var description = ""
    @State private var priority = Habit.Priority.medium
    @State private var reminderTime = Date()
    @State private var hasReminder = false
    @State private var allowsMultipleCompletions = false
    @State private var category = Habit.Category.other
    
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
                    
                    Picker("Category", selection: $category) {
                        ForEach(Habit.Category.allCases, id: \.self) { category in
                            HStack {
                                Circle()
                                    .fill(Color(hex: category.defaultColor))
                                    .frame(width: 12, height: 12)
                                Text(category.rawValue)
                            }
                            .tag(category)
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
            }
            .navigationTitle("New Habit")
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
        let habit = Habit(
            name: name,
            description: description,
            priority: priority,
            reminderTime: hasReminder ? reminderTime : nil,
            allowsMultipleCompletions: allowsMultipleCompletions,
            category: category
        )
        
        habitStore.addHabit(habit)
        dismiss()
    }
} 