import SwiftUI

struct RestTimerView: View {
    let timerService: TimerService
    let onSkip: () -> Void
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        VStack(spacing: 24) {
            Text("Rest")
                .font(Typo.heading)
                .foregroundStyle(theme.textSecondary)
            Text(timerService.formattedTime)
                .font(Typo.repCount)
                .foregroundStyle(theme.textPrimary)
                .contentTransition(.numericText())
            Button("Skip") { onSkip() }
                .font(Typo.body)
                .foregroundStyle(theme.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundColor)
    }
}
