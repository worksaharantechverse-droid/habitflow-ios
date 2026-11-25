import Foundation
import SwiftData
import SwiftUI

@Model
final class Habit {
    var name: String
    var symbol: String
    var colorRaw: String
    var completedDays: [String]
    var reminderEnabled: Bool
    var reminderHour: Int
    var reminderID: String
    var createdAt: Date

    init(name: String, symbol: String = "checkmark.circle.fill", colorRaw: String = "violet", completedDays: [String] = [], reminderEnabled: Bool = false, reminderHour: Int = 9, reminderID: String = UUID().uuidString, createdAt: Date = .now) {
        self.name = name
        self.symbol = symbol
        self.colorRaw = colorRaw
        self.completedDays = completedDays
        self.reminderEnabled = reminderEnabled
        self.reminderHour = reminderHour
        self.reminderID = reminderID
        self.createdAt = createdAt
    }

    var color: Color { AppTheme.habitColor(colorRaw) }
}
