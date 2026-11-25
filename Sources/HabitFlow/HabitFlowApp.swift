import SwiftUI
import SwiftData

@main
struct HabitFlowApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [Habit.self])
        }
    }
}
