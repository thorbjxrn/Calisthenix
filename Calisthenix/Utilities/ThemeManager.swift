import SwiftUI

@Observable
final class ThemeManager {
    var currentTheme: AppTheme {
        didSet { UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme") }
    }

    init() {
        let saved = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.calisthenix.rawValue
        self.currentTheme = AppTheme(rawValue: saved) ?? .calisthenix
    }

    var accentColor: Color { currentTheme.accentColor }
    var backgroundColor: Color { currentTheme.backgroundColor }
    var cardColor: Color { currentTheme.cardColor }
    var textPrimary: Color { currentTheme.textPrimary }
    var textSecondary: Color { currentTheme.textSecondary }
    var completedColor: Color { currentTheme.completedColor }
    var ctaTextColor: Color { currentTheme.ctaTextColor }
    var lockedColor: Color { currentTheme.lockedColor }
    var masteredColor: Color { currentTheme.masteredColor }
    var isPremiumTheme: Bool { currentTheme.isPremium }
    var preferredColorScheme: ColorScheme? { currentTheme.preferredColorScheme }
}

enum AppTheme: String, CaseIterable {
    case calisthenix
    case stronq

    var displayName: String {
        switch self {
        case .calisthenix: "Calisthenix"
        case .stronq: "Stronq"
        }
    }

    var isPremium: Bool { false }
    var preferredColorScheme: ColorScheme? { nil }

    var accentColor: Color {
        switch self {
        case .calisthenix: Color(red: 0.40, green: 0.75, blue: 0.65)
        case .stronq: Color(red: 0.85, green: 0.75, blue: 0.55)
        }
    }

    var backgroundColor: Color { Color(.systemBackground) }
    var cardColor: Color { Color(.secondarySystemBackground) }
    var textPrimary: Color { Color(.label) }
    var textSecondary: Color { Color(.secondaryLabel) }
    var completedColor: Color { Color(red: 0.30, green: 0.78, blue: 0.40) }
    var ctaTextColor: Color { .black }
    var lockedColor: Color { Color(.quaternaryLabel) }
    var masteredColor: Color { Color(red: 0.85, green: 0.72, blue: 0.30) }
    var themePreviewColor: Color { accentColor }
}
