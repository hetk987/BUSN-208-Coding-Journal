import SwiftUI

struct HabitListView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var showingAddHabit = false
    @State private var editingHabit: Habit?
    @State private var selectedHabits: Set<UUID> = []
    @State private var selectedCategory: Habit.Category?
    @State private var showingProfile = false
    
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
    
    private var completionPercentage: Int {
        guard !habitStore.habits.isEmpty else { return 0 }
        return Int((Double(completedHabits.count) / Double(habitStore.habits.count)) * 100)
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Summary
                    HStack {
                        Button(action: { showingProfile = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .trim(from: 0, to: Double(completionPercentage) / 100)
                                    .stroke(Color.purple, lineWidth: 4)
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                                
                                Text("\(completionPercentage)%")
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Progress")
                                .font(.headline)
                            Text("\(completedHabits.count) of \(habitStore.habits.count) completed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Header Stats Card
                    VStack(spacing: 20) {
                        HStack(spacing: 40) {
                            StatItem(
                                icon: "flame.fill",
                                title: "Streak",
                                value: "\(habitStore.habits.map { $0.streak }.max() ?? 0)",
                                iconColor: .orange
                            )
                            
                            StatItem(
                                icon: "eye.fill",
                                title: "For review",
                                value: "\(incompleteHabits.count) habits",
                                iconColor: .gray
                            )
                        }
                        .padding(.top)
                        
                        HStack(spacing: 0) {
                            ProgressStateView(
                                state: .done,
                                title: "Done",
                                subtitle: "\(completedHabits.count) completed"
                            )
                            
                            ProgressStateView(
                                state: .next,
                                title: "Next review",
                                subtitle: "on \(dateFormatter.string(from: Date().addingTimeInterval(86400)))"
                            )
                            
                            ProgressStateView(
                                state: .locked,
                                title: "Review",
                                subtitle: "on \(dateFormatter.string(from: Date().addingTimeInterval(86400 * 3)))"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Info Card
                    InfoCard(
                        title: "Swipe to complete",
                        message: "Swipe right on habits to mark them as complete",
                        icon: "arrow.right.circle.fill"
                    )
                    .padding(.horizontal)
                    
                    // Habits List
                    VStack(alignment: .leading, spacing: 16) {
                        if !incompleteHabits.isEmpty {
                            Text("Active Habits")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            
                            ForEach(incompleteHabits) { habit in
                                HabitRowView(
                                    habit: habit,
                                    isSelected: selectedHabits.contains(habit.id),
                                    onSelect: { toggleSelection(habit) },
                                    onEdit: { editingHabit = habit }
                                )
                                .padding(.horizontal)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(action: { completeHabit(habit) }) {
                                        Label("Complete", systemImage: "checkmark")
                                    }
                                    .tint(.green)
                                }
                            }
                        }
                        
                        if !completedHabits.isEmpty {
                            Text("Completed Today")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ForEach(completedHabits) { habit in
                                CompletedHabitRowView(
                                    habit: habit,
                                    onEdit: { editingHabit = habit }
                                )
                                .padding(.horizontal)
                                .swipeActions(edge: .trailing) {
                                    Button(action: { uncompleteHabit(habit) }) {
                                        Label("Uncomplete", systemImage: "xmark")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(dateFormatter.string(from: Date()).uppercased())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(habitStore: habitStore)
            }
            .sheet(item: $editingHabit) { habit in
                EditHabitView(habitStore: habitStore, habit: habit)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView(habitStore: habitStore)
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
    
    private func completeHabit(_ habit: Habit) {
        habitStore.toggleHabitCompletion(habit)
    }
    
    private func uncompleteHabit(_ habit: Habit) {
        habitStore.toggleHabitCompletion(habit)
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(iconColor)
                )
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
        }
    }
}

struct ProgressStateView: View {
    enum State {
        case done, next, locked
    }
    
    let state: State
    let title: String
    let subtitle: String
    
    private var iconName: String {
        switch state {
        case .done: return "checkmark"
        case .next: return "calendar"
        case .locked: return "lock.fill"
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .done: return .green
        case .next: return .pink
        case .locked: return Color(.systemGray4)
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(backgroundColor.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundColor(backgroundColor)
                )
            Text(title)
                .font(.subheadline)
                .bold()
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoCard: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
