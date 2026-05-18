import SwiftUI

struct QuickLogView: View {
    let stepName: String
    let targetReps: Int
    let onLog: (Int) -> Void
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var reps: Int

    init(stepName: String, targetReps: Int, onLog: @escaping (Int) -> Void) {
        self.stepName = stepName
        self.targetReps = targetReps
        self.onLog = onLog
        _reps = State(initialValue: targetReps)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(stepName)
                .font(Typo.heading)
                .foregroundStyle(theme.textPrimary)

            HStack(spacing: 24) {
                Button { if reps > 1 { reps -= 1 } } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(theme.textSecondary)
                }
                Text("\(reps)")
                    .font(Typo.repCount)
                    .foregroundStyle(theme.textPrimary)
                    .frame(minWidth: 60)
                Button { reps += 1 } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(theme.textSecondary)
                }
            }

            Text("reps")
                .font(Typo.caption)
                .foregroundStyle(theme.textSecondary)

            Button("Done") {
                onLog(reps)
                dismiss()
            }
            .font(Typo.heading)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(theme.ctaTextColor)
        }
        .padding(24)
        .presentationDetents([.height(300)])
    }
}
