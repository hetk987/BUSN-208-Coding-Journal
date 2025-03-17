import SwiftUI

struct HabitListView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var showingAddHabit = false
    @State private var editingHabit: Habit?
    @State private var selectedHabits: Set<UUID> = []
    @State private var selectedCategory: Habit.Category?
    
    private var completedHabits: [Habit] {
        let today = Calendar.current.startOfDay(for: Date())
        return filteredHabits.filter { habit in
            if habit.allowsMultipleCompletions {
                return habit.dailyCompletions[today, default: 0] > 0
            } else {
                return habit.completionDates.contains(today)
            }
        }
    }
    
    private var incompleteHabits: [Habit] {
        filteredHabits.filter { habit in
            !completedHabits.contains { $0.id == habit.id }
        }
    }
    
    private var filteredHabits: [Habit] {
        if let category = selectedCategory {
            return habitStore.habits.filter { $0.category == category }
        }
        return habitStore.habits
    }
    
    private var categories: [Habit.Category] {
        Array(Set(habitStore.habits.map { $0.category })).sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                color: Color(hex: category.defaultColor),
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                List {
                    if !incompleteHabits.isEmpty {
                        Section(header: Text("Active Habits")) {
                            ForEach(incompleteHabits) { habit in
                                HabitRowView(
                                    habit: habit,
                                    isSelected: selectedHabits.contains(habit.id),
                                    onSelect: { toggleSelection(habit) },
                                    onComplete: { habitStore.completeHabit(habit) }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingHabit = habit
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
                                CompletedHabitRowView(
                                    habit: habit,
                                    isSelected: selectedHabits.contains(habit.id),
                                    onSelect: { toggleSelection(habit) }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingHabit = habit
                                }
                            }
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
            .sheet(item: $editingHabit) { habit in
                EditHabitView(habitStore: habitStore, habit: habit)
            }
        }
    }
    
    private func toggleSelection(_ habit: Habit) {
        if selectedHabits.contains(habit.id) {
            selectedHabits.remove(habit.id)
        } else {
            selectedHabits.insert(habit.id)
        }
    }
}

struct CategoryButton: View {
    let title: String
    var color: Color = .blue
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color : color.opacity(0.2))
                .foregroundColor(isSelected ? .white : color)
                .cornerRadius(20)
        }
    }
}

struct HabitRowView: View {
    let habit: Habit
    let isSelected: Bool
    let onSelect: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onSelect) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color(hex: habit.color))
            }
            
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
                    .foregroundColor(Color(hex: habit.color))
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
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onSelect) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color(hex: habit.color))
            }
            
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
