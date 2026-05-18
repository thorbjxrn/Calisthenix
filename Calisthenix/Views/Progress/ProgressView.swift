import SwiftUI
import SwiftData

struct CalisthenixProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var viewModel: ProgressViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    ScrollView {
                        VStack(spacing: 20) {
                            statsRow(viewModel: viewModel)
                            skillBreakdown(viewModel: viewModel)
                        }
                        .padding(.horizontal, 16)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Progress")
            .background(theme.backgroundColor.ignoresSafeArea())
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ProgressViewModel(context: modelContext)
            } else {
                viewModel?.refresh()
            }
        }
    }

    private func statsRow(viewModel: ProgressViewModel) -> some View {
        HStack(spacing: 12) {
            statCard(value: "\(viewModel.totalMastered)/\(viewModel.totalSteps)", label: "Mastered")
            statCard(value: "\(viewModel.totalSessions)", label: "Sessions")
            statCard(value: "\(viewModel.currentStreak)", label: "Day Streak")
        }
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Typo.statValue)
                .foregroundStyle(theme.textPrimary)
            Text(label)
                .font(Typo.statLabel)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(theme.cardColor, in: RoundedRectangle(cornerRadius: 14))
    }

    private func skillBreakdown(viewModel: ProgressViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills")
                .font(Typo.heading)
                .foregroundStyle(theme.textPrimary)

            ForEach(viewModel.skillProgress, id: \.skill.id) { item in
                HStack {
                    Text(item.skill.name)
                        .font(Typo.body)
                        .foregroundStyle(theme.textPrimary)
                    Spacer()
                    Text("\(item.mastered)/\(item.total)")
                        .font(Typo.repStandard)
                        .foregroundStyle(item.mastered == item.total ? theme.masteredColor : theme.textSecondary)
                }
                .padding(12)
                .background(theme.cardColor, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
