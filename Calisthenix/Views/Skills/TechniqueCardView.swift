import SwiftUI

struct TechniqueCardView: View {
    let step: Step
    let state: StepState
    var onActivate: (() -> Void)? = nil
    var onMaster: (() -> Void)? = nil
    var onManualUnlock: (() -> Void)? = nil
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.cardColor)
                        .frame(height: 200)
                        .overlay {
                            VStack(spacing: 8) {
                                Image(systemName: "figure.strengthtraining.functional")
                                    .font(.system(size: 48))
                                    .foregroundStyle(theme.textSecondary.opacity(0.3))
                                Text("Illustration")
                                    .font(Typo.caption)
                                    .foregroundStyle(theme.textSecondary.opacity(0.3))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(step.name)
                                    .font(Typo.title)
                                    .foregroundStyle(theme.textPrimary)
                                Spacer()
                                methodBadge
                            }
                            Text(step.description)
                                .font(Typo.body)
                                .foregroundStyle(theme.textSecondary)
                        }

                        cardSection(title: "Form Cues", items: step.formCues, icon: "checkmark.circle.fill", color: theme.completedColor)

                        cardSection(title: "Watch Out For", items: step.commonMistakes, icon: "exclamationmark.triangle.fill", color: .orange)

                        advancementSection

                        actionButton
                    }
                    .padding(16)
                }
            }
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var methodBadge: some View {
        Text(step.recommendedMethod.shortName)
            .font(Typo.small)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(theme.accentColor.opacity(0.15))
            .clipShape(Capsule())
            .foregroundStyle(theme.accentColor)
    }

    private func cardSection(title: String, items: [String], icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Typo.captionEmphasis)
                .foregroundStyle(theme.textSecondary)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundStyle(color)
                        .frame(width: 16)
                        .padding(.top, 2)
                    Text(item)
                        .font(Typo.body)
                        .foregroundStyle(theme.textPrimary)
                }
            }
        }
    }

    private var advancementSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Advancement Criteria")
                .font(Typo.captionEmphasis)
                .foregroundStyle(theme.textSecondary)
            HStack(spacing: 16) {
                criteriaItem(value: "\(step.advancementCriteria.sets)", label: "sets")
                if let reps = step.advancementCriteria.reps {
                    criteriaItem(value: "\(reps)", label: "reps")
                }
                if let hold = step.advancementCriteria.holdSeconds {
                    criteriaItem(value: "\(hold)s", label: "hold")
                }
                criteriaItem(value: "\(step.advancementCriteria.sessionsRequired)", label: "sessions")
            }
        }
    }

    private func criteriaItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Typo.statValue)
                .foregroundStyle(theme.textPrimary)
            Text(label)
                .font(Typo.statLabel)
                .foregroundStyle(theme.textSecondary)
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        switch state {
        case .locked:
            Button("Unlock Manually") { onManualUnlock?(); dismiss() }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.textSecondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(theme.textPrimary)
        case .available:
            Button("Start Training") { onActivate?(); dismiss() }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(theme.ctaTextColor)
        case .active:
            Button("Mark as Mastered") { onMaster?(); dismiss() }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.masteredColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.black)
        case .mastered:
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Mastered")
            }
            .font(Typo.heading)
            .foregroundStyle(theme.masteredColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
    }
}
