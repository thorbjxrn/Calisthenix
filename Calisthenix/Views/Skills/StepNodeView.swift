import SwiftUI

struct StepNodeView: View {
    let step: Step
    let state: StepState
    let onTap: () -> Void
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Circle()
                    .fill(fillColor)
                    .frame(width: 48, height: 48)
                    .overlay {
                        if state == .locked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(theme.textSecondary.opacity(0.5))
                        } else if state == .mastered {
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(theme.ctaTextColor)
                        } else {
                            Text(step.name.prefix(2).uppercased())
                                .font(Typo.small)
                                .foregroundStyle(state == .active ? theme.ctaTextColor : theme.textPrimary)
                        }
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(borderColor, lineWidth: state == .active ? 3 : 1.5)
                    }

                Text(step.name)
                    .font(Typo.small)
                    .foregroundStyle(state == .locked ? theme.textSecondary.opacity(0.5) : theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
        }
        .disabled(state == .locked)
    }

    private var fillColor: Color {
        switch state {
        case .locked: theme.cardColor.opacity(0.5)
        case .available: theme.cardColor
        case .active: theme.accentColor
        case .mastered: theme.masteredColor
        }
    }

    private var borderColor: Color {
        switch state {
        case .locked: theme.lockedColor
        case .available: theme.textSecondary.opacity(0.3)
        case .active: theme.accentColor
        case .mastered: theme.masteredColor
        }
    }
}
