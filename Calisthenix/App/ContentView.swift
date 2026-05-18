import SwiftUI

struct ContentView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        TabView {
            TrainView()
                .tabItem { Label("Train", systemImage: "figure.mixed.cardio") }

            SkillsView()
                .tabItem { Label("Skills", systemImage: "arrow.up.right.circle") }

            CalisthenixProgressView()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(theme.accentColor)
        .preferredColorScheme(theme.preferredColorScheme)
    }
}
