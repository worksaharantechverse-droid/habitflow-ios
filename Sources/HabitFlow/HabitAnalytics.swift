import Foundation

enum HabitAnalytics {
    static func dayKey(_ date: Date, calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }

    static func isCompleted(_ habit: Habit, on date: Date, calendar: Calendar = .current) -> Bool {
        habit.completedDays.contains(dayKey(date, calendar: calendar))
    }

    static func streak(_ habit: Habit, asOf date: Date = .now, calendar: Calendar = .current) -> Int {
        var cursor = calendar.startOfDay(for: date)
        if !isCompleted(habit, on: cursor, calendar: calendar) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) else { return 0 }
            cursor = yesterday
        }
        var count = 0
        while isCompleted(habit, on: cursor, calendar: calendar) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return count
    }

    static func weeklyCompletion(_ habits: [Habit], asOf date: Date = .now, calendar: Calendar = .current) -> [Int] {
        let weekday = calendar.component(.weekday, from: date)
        let start = calendar.date(byAdding: .day, value: -(weekday - 1), to: calendar.startOfDay(for: date)) ?? date
        guard let range = calendar.range(of: .day, in: .weekOfYear, for: start) else { return [] }
        return range.map { offset in
            guard let day = calendar.date(byAdding: .day, value: offset - 1, to: start) else { return 0 }
            return habits.filter { isCompleted($0, on: day, calendar: calendar) }.count
        }
    }

    static func completionRate(_ habits: [Habit], in month: Date, calendar: Calendar = .current) -> Double {
        guard !habits.isEmpty, let range = calendar.range(of: .day, in: .month, for: month) else { return 0 }
        let possible = habits.count * range.count
        let completed = habits.reduce(0) { total, habit in
            total + range.reduce(0) { inner, day in
                var components = calendar.dateComponents([.year, .month], from: month)
                components.day = day
                guard let date = calendar.date(from: components) else { return inner }
                return inner + (habit.completedDays.contains(dayKey(date, calendar: calendar)) ? 1 : 0)
            }
        }
        return possible == 0 ? 0 : Double(completed) / Double(possible)
    }

    static func monthDays(for month: Date, calendar: Calendar = .current) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let first = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else { return [] }
        let offset = calendar.component(.weekday, from: first) - 1
        var cells: [Date?] = Array(repeating: nil, count: offset)
        for day in range {
            cells.append(calendar.date(byAdding: .day, value: day - 1, to: first))
        }
        return cells
    }
}
