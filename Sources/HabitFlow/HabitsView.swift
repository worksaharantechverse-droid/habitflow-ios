import SwiftUI

struct HabitsView: View {
    @Bindable var store: HabitStore
    let onAdd: () -> Void
    let onEdit: (Habit) -> Void

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Loading habits…")
                } else if store.habits.isEmpty {
                    EmptyStateView(title: "No habits yet", message: "Create a habit to start tracking your streak.", systemImage: "square.stack.3d.up")
                } else {
                    List {
                        ForEach(store.habits) { habit in
                            Button { onEdit(habit) } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle().fill(habit.color.opacity(0.16))
                                        Image(systemName: habit.symbol).foregroundStyle(habit.color)
                                    }
                                    .frame(width: 44, height: 44)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(habit.name)
                                            .font(AppTheme.Typography.body.weight(.semibold))
                                        Text(habit.reminderEnabled ? "Reminder at \(String(format: "%02d:00", habit.reminderHour))" : "No reminder")
                                            .font(AppTheme.Typography.caption)
                                            .foregroundStyle(AppTheme.secondaryText)
                                    }
                                    Spacer()
                                    Text("\(HabitAnalytics.streak(habit))d")
                                        .font(AppTheme.Typography.caption)
                                        .foregroundStyle(habit.color)
                                }
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) { store.delete(habit) } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(AppTheme.surface)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .accessibilityIdentifier("habits-list")
                }
            }
            .background(AppTheme.background)
            .navigationTitle("Habits")
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
}
