import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var habitStore: HabitStore
    @State var habit: Habit
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Habit Details")) {
                TextField("Habit Name", text: $habit.name)
                TextField("Description", text: $habit.description)
                
                Picker("Priority", selection: $habit.priority) {
                    ForEach(Habit.Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                
                Picker("Category", selection: $habit.category) {
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
                if let reminderTime = habit.reminderTime {
                    DatePicker("Reminder Time",
                             selection: Binding(
                                get: { reminderTime },
                                set: { habit.reminderTime = $0 }
                             ),
                             displayedComponents: .hourAndMinute)
                } else {
                    Button("Add Reminder") {
                        habit.reminderTime = Date()
                    }
                }
                
                if habit.reminderTime != nil {
                    Button("Remove Reminder", role: .destructive) {
                        habit.reminderTime = nil
                    }
                }
            }
            
            Section(header: Text("Completion Settings")) {
                Toggle("Allow Multiple Completions per Day", isOn: $habit.allowsMultipleCompletions)
            }
            
            Section {
                Button("Delete Habit", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
        }
        .navigationTitle("Edit Habit")
        .navigationBarItems(
            trailing: Button("Save") {
                habitStore.updateHabit(habit)
                dismiss()
            }
        )
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                habitStore.deleteHabit(habit)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
} 