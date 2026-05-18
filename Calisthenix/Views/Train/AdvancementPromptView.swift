import SwiftUI

struct AdvancementPromptView: View {
    let stepName: String
    let skillName: String
    let onMaster: () -> Void
    let onDismiss: () -> Void
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(theme.masteredColor)
            Text("Ready to advance!")
                .font(Typo.title)
                .foregroundStyle(theme.textPrimary)
            Text("You've met the advancement criteria for \(stepName)")
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button("Mark as Mastered") {
                    onMaster()
                    dismiss()
                }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.masteredColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.black)

                Button("Not Yet") {
                    onDismiss()
                    dismiss()
                }
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .padding(24)
        .background(theme.backgroundColor)
        .presentationDetents([.medium])
    }
}
