import SwiftUI
import Charts

private struct WeekDatum: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

struct InsightsView: View {
    @Bindable var store: HabitStore

    private var weeklyData: [WeekDatum] {
        let counts = HabitAnalytics.weeklyCompletion(store.habits)
        let symbols = Calendar.current.shortWeekdaySymbols
        return zip(symbols, counts).map { WeekDatum(day: $0.0, count: $0.1) }
    }

    private var bestStreak: Int {
        store.habits.map { HabitAnalytics.streak($0) }.max() ?? 0
    }

    private var totalCompletions: Int {
        store.habits.reduce(0) { $0 + $1.completedDays.count }
    }

    private var monthRate: Double {
        HabitAnalytics.completionRate(store.habits, in: Date())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Insights")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                        Text("See your momentum.")
                            .font(AppTheme.Typography.hero)
                            .foregroundStyle(AppTheme.primaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 12) {
                        statCard(title: "Best streak", value: "\(bestStreak)d", tint: AppTheme.violet)
                        statCard(title: "Total done", value: "\(totalCompletions)", tint: AppTheme.mint)
                        statCard(title: "This month", value: "\(Int(monthRate * 100))%", tint: AppTheme.pink)
                    }

                    SectionCard(title: "This week") {
                        Chart(weeklyData) { datum in
                            BarMark(
                                x: .value("Day", datum.day),
                                y: .value("Completed", datum.count)
                            )
                            .foregroundStyle(AppTheme.violet)
                            .cornerRadius(6)
                        }
                        .frame(height: 170)
                        .chartYScale(domain: 0...max(store.habits.count, 1))
                        .accessibilityIdentifier("insights-chart")
                    }

                    CalendarHistoryView(store: store)
                }
                .padding(20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Insights")
            .accessibilityIdentifier("insights-screen")
        }
    }

    private func statCard(title: String, value: String, tint: Color) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(AppTheme.Typography.title)
                .foregroundStyle(tint)
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
