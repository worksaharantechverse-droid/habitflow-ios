import SwiftUI

struct HabitEditorView: View {
    @Bindable var store: HabitStore
    let habit: Habit?
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var symbol: String
    @State private var colorRaw: String
    @State private var reminderEnabled: Bool
    @State private var reminderHour: Int

    private let symbols = ["checkmark.circle.fill", "book.fill", "figure.walk", "drop.fill", "bed.fill", "dumbbell.fill", "leaf.fill", "sun.max.fill"]
    private let colors = ["violet", "pink", "mint", "amber"]

    init(store: HabitStore, habit: Habit? = nil) {
        self.store = store
        self.habit = habit
        _name = State(initialValue: habit?.name ?? "")
        _symbol = State(initialValue: habit?.symbol ?? "checkmark.circle.fill")
        _colorRaw = State(initialValue: habit?.colorRaw ?? "violet")
        _reminderEnabled = State(initialValue: habit?.reminderEnabled ?? false)
        _reminderHour = State(initialValue: habit?.reminderHour ?? 9)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    TextField("e.g. Stretch for 10 minutes", text: $name)
                        .accessibilityIdentifier("habit-name-field")
                }

                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(symbols, id: \.self) { item in
                            Button { symbol = item } label: {
                                Image(systemName: item)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(symbol == item ? AppTheme.violet.opacity(0.2) : Color.clear, in: RoundedRectangle(cornerRadius: 12))
                                    .foregroundStyle(symbol == item ? AppTheme.violet : AppTheme.secondaryText)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Colour") {
                    HStack(spacing: 16) {
                        ForEach(colors, id: \.self) { item in
                            Button { colorRaw = item } label: {
                                Circle()
                                    .fill(AppTheme.habitColor(item))
                                    .frame(width: 32, height: 32)
                                    .overlay {
                                        if colorRaw == item {
                                            Circle().stroke(Color.primary, lineWidth: 2).padding(2)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Reminder") {
                    Toggle("Daily reminder", isOn: $reminderEnabled)
                    if reminderEnabled {
                        Picker("Time", selection: $reminderHour) {
                            ForEach(6..<23, id: \.self) { hour in
                                Text(String(format: "%02d:00", hour)).tag(hour)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle(habit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .accessibilityIdentifier("save-habit")
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let habit {
            store.update(habit, name: trimmed, symbol: symbol, colorRaw: colorRaw, reminderEnabled: reminderEnabled, reminderHour: reminderHour)
        } else {
            store.addHabit(name: trimmed, symbol: symbol, colorRaw: colorRaw, reminderEnabled: reminderEnabled, reminderHour: reminderHour)
        }
        dismiss()
    }
}
