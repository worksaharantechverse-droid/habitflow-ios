import SwiftUI

struct CalendarHistoryView: View {
    @Bindable var store: HabitStore
    @State private var monthStart: Date = {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var selectedName: String?

    private var selectedHabit: Habit? {
        store.habits.first { $0.name == selectedName } ?? store.habits.first
    }

    private var cells: [Date?] {
        HabitAnalytics.monthDays(for: monthStart)
    }

    var body: some View {
        SectionCard(title: "History") {
            if store.habits.isEmpty {
                Text("Create a habit to see its history.")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.secondaryText)
            } else {
                Picker("Habit", selection: $selectedName) {
                    ForEach(store.habits, id: \.name) { habit in
                        Text(habit.name).tag(Optional(habit.name))
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("habit-picker")

                HStack {
                    Button { changeMonth(-1) } label: {
                        Image(systemName: "chevron.left.circle.fill").font(.title2)
                    }
                    .accessibilityIdentifier("previous-month")
                    Spacer()
                    Text(monthStart.formatted(.dateTime.month(.wide).year()))
                        .font(AppTheme.Typography.body.weight(.semibold))
                    Spacer()
                    Button { changeMonth(1) } label: {
                        Image(systemName: "chevron.right.circle.fill").font(.title2)
                    }
                    .accessibilityIdentifier("next-month")
                }
                .foregroundStyle(AppTheme.primaryText)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    ForEach(cells.indices, id: \.self) { index in
                        dayCell(cells[index])
                    }
                }
                .accessibilityIdentifier("calendar-grid")
            }
        }
    }

    @ViewBuilder
    private func dayCell(_ date: Date?) -> some View {
        if let date, let habit = selectedHabit {
            let done = HabitAnalytics.isCompleted(habit, on: date)
            let isToday = Calendar.current.isDateInToday(date)
            Button { store.toggle(habit, date: date) } label: {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .background(done ? habit.color.opacity(0.85) : AppTheme.surfaceAlt, in: RoundedRectangle(cornerRadius: 9))
                    .foregroundStyle(done ? .white : AppTheme.primaryText)
                    .overlay {
                        if isToday {
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(AppTheme.violet, lineWidth: 2)
                        }
                    }
            }
            .buttonStyle(.plain)
        } else {
            Color.clear.frame(minHeight: 30)
        }
    }

    private func changeMonth(_ value: Int) {
        guard let date = Calendar.current.date(byAdding: .month, value: value, to: monthStart) else { return }
        monthStart = date
    }
}
