import SwiftUI

enum AppTheme {
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor(red: 0.05, green: 0.04, blue: 0.12, alpha: 1) : UIColor(red: 0.97, green: 0.96, blue: 1.0, alpha: 1)
    })
    static let surface = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor(red: 0.11, green: 0.09, blue: 0.22, alpha: 1) : UIColor.white
    })
    static let surfaceAlt = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor(red: 0.17, green: 0.14, blue: 0.31, alpha: 1) : UIColor(red: 0.93, green: 0.91, blue: 0.99, alpha: 1)
    })
    static let primaryText = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? .white : UIColor(red: 0.11, green: 0.08, blue: 0.2, alpha: 1)
    })
    static let secondaryText = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.6) : UIColor.black.withAlphaComponent(0.55)
    })
    static let violet = Color(red: 0.55, green: 0.36, blue: 0.96)
    static let pink = Color(red: 0.95, green: 0.4, blue: 0.66)
    static let mint = Color(red: 0.32, green: 0.85, blue: 0.65)

    static func habitColor(_ raw: String) -> Color {
        switch raw {
        case "pink": return pink
        case "mint": return mint
        case "amber": return Color(red: 0.99, green: 0.72, blue: 0.29)
        default: return violet
        }
    }

    enum Typography {
        static let hero = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 21, weight: .bold, design: .rounded)
        static let section = Font.system(size: 16, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 15, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
    }
}
