import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    @State private var store = HabitStore()
    @State private var selection = 0
    @State private var showingAdd = false
    @State private var editingHabit: Habit?

    var body: some View {
        TabView(selection: $selection) {
            TodayView(store: store, onAdd: { showingAdd = true }, onEdit: { editingHabit = $0 })
                .tabItem { Label("Today", systemImage: "checkmark.circle") }
                .tag(0)
            HabitsView(store: store, onAdd: { showingAdd = true }, onEdit: { editingHabit = $0 })
                .tabItem { Label("Habits", systemImage: "square.stack.3d.up") }
                .tag(1)
            InsightsView(store: store)
                .tabItem { Label("Insights", systemImage: "chart.bar.fill") }
                .tag(2)
        }
        .tint(AppTheme.violet)
        .background(AppTheme.background.ignoresSafeArea())
        .sheet(isPresented: $showingAdd) {
            HabitEditorView(store: store)
        }
        .sheet(item: $editingHabit) { habit in
            HabitEditorView(store: store, habit: habit)
        }
        .overlay(alignment: .top) {
            if let message = store.errorMessage {
                Text(message)
                    .font(AppTheme.Typography.caption)
                    .padding(8)
                    .background(.red.opacity(0.85), in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            store.configure(with: context)
            Task { await store.requestNotificationPermission() }
        }
    }
}
