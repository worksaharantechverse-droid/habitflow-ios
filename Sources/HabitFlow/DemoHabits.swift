import Foundation
import SwiftData

enum DemoHabits {
    static func seed(into context: ModelContext, calendar: Calendar = .current, now: Date = .now) {
        let definitions = [
            ("Morning meditation", "figure.mind.and.body", "violet", [0, 1, 2, 3, 4, 5, 7, 8, 9]),
            ("Read 20 pages", "book.fill", "mint", [0, 1, 3, 4, 6, 7, 9]),
            ("Evening walk", "figure.walk", "pink", [1, 2, 4, 5, 6, 8]),
            ("Drink 2L water", "drop.fill", "amber", [0, 2, 3, 5, 7, 8, 9])
        ]
        for (name, symbol, color, offsets) in definitions {
            let days = offsets.compactMap { offset -> String? in
                guard let date = calendar.date(byAdding: .day, value: -offset, to: now) else { return nil }
                return HabitAnalytics.dayKey(date, calendar: calendar)
            }
            context.insert(Habit(name: name, symbol: symbol, colorRaw: color, completedDays: days))
        }
    }
}
