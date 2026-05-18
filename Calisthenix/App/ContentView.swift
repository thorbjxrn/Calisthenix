import SwiftUI

struct ContentView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        TabView {
            Text("Train")
                .tabItem { Label("Train", systemImage: "figure.mixed.cardio") }
            Text("Skills")
                .tabItem { Label("Skills", systemImage: "arrow.up.right.circle") }
            Text("Progress")
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(theme.accentColor)
        .preferredColorScheme(theme.preferredColorScheme)
    }
}
