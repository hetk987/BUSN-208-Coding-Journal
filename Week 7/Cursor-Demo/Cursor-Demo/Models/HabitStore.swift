import Foundation
import UserNotifications

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    private let saveKey = "SavedHabits"
    
    init() {
        loadHabits()
        requestNotificationPermission()
        
        #if DEBUG
        if habits.isEmpty {
            generateTestData()
        }
        #endif
    }
    
    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
                habits = decoded
            }
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
        scheduleNotification(for: habit)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
            scheduleNotification(for: habit)
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
        cancelNotification(for: habit)
    }
    
    func completeHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit
            let today = Calendar.current.startOfDay(for: Date())
            
            if habit.allowsMultipleCompletions {
                updatedHabit.dailyCompletions[today, default: 0] += 1
            } else {
                if !habit.completionDates.contains(today) {
                    updatedHabit.completionDates.append(today)
                    updatedHabit.streak += 1
                }
            }
            
            habits[index] = updatedHabit
            saveHabits()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleNotification(for habit: Habit) {
        guard let reminderTime = habit.reminderTime else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Time to complete your habit: \(habit.name)"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelNotification(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
    }
    
    #if DEBUG
    private func generateTestData() {
        let calendar = Calendar.current
        let today = Date()
        
        // Exercise Habit
        var exerciseHabit = Habit(
            name: "Exercise",
            description: "30 minutes of physical activity",
            priority: .high,
            reminderTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today),
            allowsMultipleCompletions: false
        )
        
        // Add completion dates for the last 7 days
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                exerciseHabit.completionDates.append(calendar.startOfDay(for: date))
                exerciseHabit.streak += 1
            }
        }
        
        // Water Intake Habit
        var waterHabit = Habit(
            name: "Drink Water",
            description: "Drink 8 glasses of water",
            priority: .medium,
            reminderTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today),
            allowsMultipleCompletions: true
        )
        
        // Add multiple completions for the last 3 days
        for dayOffset in 0..<3 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                waterHabit.dailyCompletions[calendar.startOfDay(for: date)] = Int.random(in: 4...8)
            }
        }
        
        // Reading Habit
        var readingHabit = Habit(
            name: "Read",
            description: "Read for 20 minutes",
            priority: .low,
            reminderTime: calendar.date(bySettingHour: 21, minute: 0, second: 0, of: today),
            allowsMultipleCompletions: false
        )
        
        // Add completion dates for the last 5 days
        for dayOffset in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                readingHabit.completionDates.append(calendar.startOfDay(for: date))
                readingHabit.streak += 1
            }
        }
        
        // Add the test habits
        habits = [exerciseHabit, waterHabit, readingHabit]
        saveHabits()
    }
    #endif
} 