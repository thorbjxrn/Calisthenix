import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        NavigationStack {
            Text("Settings coming soon")
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
                .navigationTitle("Settings")
        }
    }
}
