import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class HabitStore {
    private(set) var habits: [Habit] = []
    private(set) var isLoading = true
    var errorMessage: String?

    private var context: ModelContext?
    private let scheduler: any HabitNotificationScheduling

    init(scheduler: any HabitNotificationScheduling = UserNotificationScheduler()) {
        self.scheduler = scheduler
    }

    func configure(with context: ModelContext, seedDemoData: Bool = true) {
        self.context = context
        isLoading = true
        do {
            _ = try fetch()
            if seedDemoData && habits.isEmpty {
                DemoHabits.seed(into: context)
                _ = try fetch()
            }
            isLoading = false
        } catch {
            errorMessage = "Unable to load habits: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func addHabit(name: String, symbol: String, colorRaw: String, reminderEnabled: Bool, reminderHour: Int) {
        guard let context else { return }
        let habit = Habit(name: name, symbol: symbol, colorRaw: colorRaw, reminderEnabled: reminderEnabled, reminderHour: reminderHour)
        context.insert(habit)
        persist()
        if reminderEnabled {
            Task { await scheduler.scheduleReminder(id: habit.reminderID, title: habit.name, hour: habit.reminderHour) }
        }
    }

    func update(_ habit: Habit, name: String, symbol: String, colorRaw: String, reminderEnabled: Bool, reminderHour: Int) {
        habit.name = name
        habit.symbol = symbol
        habit.colorRaw = colorRaw
        habit.reminderEnabled = reminderEnabled
        habit.reminderHour = reminderHour
        persist()
        if reminderEnabled {
            Task { await scheduler.scheduleReminder(id: habit.reminderID, title: habit.name, hour: habit.reminderHour) }
        } else {
            scheduler.cancelReminder(id: habit.reminderID)
        }
    }

    func delete(_ habit: Habit) {
        scheduler.cancelReminder(id: habit.reminderID)
        context?.delete(habit)
        persist()
    }

    func toggle(_ habit: Habit, date: Date = .now) {
        let key = HabitAnalytics.dayKey(date)
        if let index = habit.completedDays.firstIndex(of: key) {
            habit.completedDays.remove(at: index)
        } else {
            habit.completedDays.append(key)
        }
        persist()
    }

    func requestNotificationPermission() async {
        _ = await scheduler.requestAuthorization()
    }

    private func fetch() throws -> Bool {
        guard let context else { return false }
        habits = try context.fetch(FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt)]))
        return !habits.isEmpty
    }

    private func persist() {
        guard let context else { return }
        do {
            try context.save()
            _ = try fetch()
        } catch {
            errorMessage = "Unable to save habit: \(error.localizedDescription)"
        }
    }
}
