import Foundation
import UserNotifications

protocol HabitNotificationScheduling {
    func requestAuthorization() async -> Bool
    func scheduleReminder(id: String, title: String, hour: Int) async
    func cancelReminder(id: String)
}

final class UserNotificationScheduler: HabitNotificationScheduling {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorization() async -> Bool {
        try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return await currentSettings()
    }

    func scheduleReminder(id: String, title: String, hour: Int) async {
        guard await currentSettings() else { return }
        center.removePendingNotificationRequests(withIdentifiers: [id])
        let content = UNMutableNotificationContent()
        content.title = "HabitFlow"
        content.body = "Time for \(title). Keep your streak going!"
        content.sound = .default
        var components = DateComponents()
        components.hour = hour
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try? await center.add(request)
    }

    func cancelReminder(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func currentSettings() async -> Bool {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }
}

struct NoopNotificationScheduler: HabitNotificationScheduling {
    func requestAuthorization() async -> Bool { true }
    func scheduleReminder(id: String, title: String, hour: Int) async {}
    func cancelReminder(id: String) {}
}
