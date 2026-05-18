import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    func scheduleGtGReminders(stepName: String, sessionsPerDay: Int, windowStart: Int, windowEnd: Int) {
        cancelGtGReminders()

        guard sessionsPerDay > 0, windowEnd > windowStart else { return }

        let intervalHours = max(1, (windowEnd - windowStart) / sessionsPerDay)
        let center = UNUserNotificationCenter.current()

        for i in 0..<sessionsPerDay {
            let hour = windowStart + (i * intervalHours)
            guard hour < windowEnd else { break }

            let content = UNMutableNotificationContent()
            content.title = "Time to train!"
            content.body = "Do your \(stepName) set"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "gtg_\(i)", content: content, trigger: trigger)
            center.add(request)
        }
    }

    func cancelGtGReminders() {
        let ids = (0..<20).map { "gtg_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
