import SwiftUI

struct TrainingMethodPickerView: View {
    let step: Step
    let onSelect: (TrainingMethod, TrainingMode) -> Void
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    Text("How do you want to train \(step.name)?")
                        .font(Typo.heading)
                        .foregroundStyle(theme.textPrimary)
                        .padding(.bottom, 8)

                    ForEach(TrainingMethod.allCases, id: \.rawValue) { method in
                        let isRecommended = method == step.recommendedMethod
                        Button {
                            onSelect(method, .guided)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(method.displayName)
                                            .font(Typo.heading)
                                        if isRecommended {
                                            Text("Recommended")
                                                .font(Typo.small)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(theme.accentColor.opacity(0.2))
                                                .clipShape(Capsule())
                                                .foregroundStyle(theme.accentColor)
                                        }
                                    }
                                    Text(methodDescription(method))
                                        .font(Typo.caption)
                                        .foregroundStyle(theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(theme.textSecondary)
                            }
                            .padding(16)
                            .background(theme.cardColor, in: RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func methodDescription(_ method: TrainingMethod) -> String {
        switch method {
        case .greaseTheGroove: "Spread sub-maximal sets throughout your day"
        case .structured: "Traditional sets × reps with rest periods"
        case .skillPractice: "Timed holds, attempts, and technique drills"
        }
    }
}
