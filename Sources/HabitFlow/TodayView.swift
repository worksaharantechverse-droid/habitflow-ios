import SwiftUI

struct TodayView: View {
    @Bindable var store: HabitStore
    let onAdd: () -> Void
    let onEdit: (Habit) -> Void

    private var completed: Int {
        store.habits.filter { HabitAnalytics.isCompleted($0, on: Date()) }.count
    }

    private var progress: Double {
        store.habits.isEmpty ? 0 : Double(completed) / Double(store.habits.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    header
                    if store.isLoading {
                        ProgressView("Loading habits…")
                            .frame(maxWidth: .infinity, minHeight: 180)
                    } else if store.habits.isEmpty {
                        EmptyStateView(title: "Build your first habit", message: "Small actions, repeated daily, become your identity.", systemImage: "sparkles")
                    } else {
                        progressCard
                        habitList
                    }
                }
                .padding(20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onAdd) {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .accessibilityIdentifier("add-habit-button")
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.secondaryText)
            Text("Make today count.")
                .font(AppTheme.Typography.hero)
                .foregroundStyle(AppTheme.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var progressCard: some View {
        SectionCard(title: "Daily progress") {
            HStack(spacing: 24) {
                ProgressRing(progress: progress, tint: AppTheme.violet)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(completed) of \(store.habits.count)")
                        .font(AppTheme.Typography.title)
                        .foregroundStyle(AppTheme.primaryText)
                    Text("habits completed today")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                    if completed == store.habits.count {
                        Label("Perfect day", systemImage: "star.fill")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.mint)
                    }
                }
            }
        }
    }

    private var habitList: some View {
        SectionCard(title: "Your habits") {
            ForEach(store.habits) { habit in
                HabitRow(
                    habit: habit,
                    isCompleted: HabitAnalytics.isCompleted(habit, on: Date()),
                    toggle: { store.toggle(habit) },
                    edit: { onEdit(habit) }
                )
            }
        }
    }
}
