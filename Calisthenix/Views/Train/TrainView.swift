import SwiftUI

struct TrainView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        NavigationStack {
            Text("Training content coming soon")
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
                .navigationTitle("Train")
        }
    }
}
