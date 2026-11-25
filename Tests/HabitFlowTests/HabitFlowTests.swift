import XCTest
@testable import HabitFlow
import SwiftData

final class HabitAnalyticsTests: XCTestCase {
    private var calendar: Calendar!
    private var now: Date!

    override func setUp() {
        super.setUp()
        var configured = Calendar.current
        configured.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar = configured
        now = calendar.date(from: DateComponents(year: 2026, month: 11, day: 25))!
    }

    func testDayKeyFormatsDate() {
        XCTAssertEqual(HabitAnalytics.dayKey(now, calendar: calendar), "2026-11-25")
    }

    func testStreakCountsConsecutiveDaysIncludingToday() {
        let habit = Habit(name: "Read", completedDays: ["2026-11-25", "2026-11-24", "2026-11-23"])
        XCTAssertEqual(HabitAnalytics.streak(habit, asOf: now, calendar: calendar), 3)
    }

    func testStreakUsesYesterdayWhenTodayIsIncomplete() {
        let habit = Habit(name: "Read", completedDays: ["2026-11-24", "2026-11-23"])
        XCTAssertEqual(HabitAnalytics.streak(habit, asOf: now, calendar: calendar), 2)
    }

    func testStreakStopsAtGap() {
        let habit = Habit(name: "Read", completedDays: ["2026-11-25", "2026-11-23"])
        XCTAssertEqual(HabitAnalytics.streak(habit, asOf: now, calendar: calendar), 1)
    }

    func testWeeklyCompletionCountsEachHabitPerDay() {
        let first = Habit(name: "A", completedDays: ["2026-11-23", "2026-11-25"])
        let second = Habit(name: "B", completedDays: ["2026-11-25"])
        let counts = HabitAnalytics.weeklyCompletion([first, second], asOf: now, calendar: calendar)
        XCTAssertEqual(counts.reduce(0, +), 3)
    }

    func testMonthDaysIncludesLeadingBlanks() {
        let cells = HabitAnalytics.monthDays(for: now, calendar: calendar)
        XCTAssertEqual(cells.filter { $0 == nil }.count, 6)
        XCTAssertEqual(cells.compactMap { $0 }.count, 30)
    }
}

@MainActor
final class HabitStoreTests: XCTestCase {
    func testAddToggleAndDeletePersist() throws {
        let container = try ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        let store = HabitStore(scheduler: NoopNotificationScheduler())
        store.configure(with: context, seedDemoData: false)
        XCTAssertTrue(store.habits.isEmpty)

        store.addHabit(name: "Read", symbol: "book.fill", colorRaw: "mint", reminderEnabled: false, reminderHour: 9)
        XCTAssertEqual(store.habits.count, 1)
        let habit = try XCTUnwrap(store.habits.first)
        XCTAssertFalse(HabitAnalytics.isCompleted(habit, on: Date()))

        store.toggle(habit)
        XCTAssertTrue(HabitAnalytics.isCompleted(habit, on: Date()))

        store.delete(habit)
        XCTAssertTrue(store.habits.isEmpty)
    }
}
