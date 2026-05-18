import SwiftUI

struct CalisthenixProgressView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        NavigationStack {
            Text("Progress tracking coming soon")
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
                .navigationTitle("Progress")
        }
    }
}
