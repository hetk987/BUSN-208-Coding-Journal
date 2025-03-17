import Foundation
import UserNotifications

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    private let saveKey = "savedHabits"
    
    init() {
        loadHabits()
        requestNotificationPermission()
    }
    
    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decodedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decodedHabits
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
    
    func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit
            let today = Calendar.current.startOfDay(for: Date())
            
            if updatedHabit.completionDates.contains(today) {
                updatedHabit.completionDates.remove(today)
            } else {
                updatedHabit.completionDates.insert(today)
            }
            
            habits[index] = updatedHabit
            saveHabits()
        }
    }
    
    func isHabitCompleted(_ habit: Habit) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return habit.completionDates.contains(today)
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
} 