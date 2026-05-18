import SwiftUI
import SwiftData

struct TrainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var viewModel: TrainViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.activePlans.isEmpty {
                        emptyState
                    } else {
                        activePlansList(viewModel: viewModel)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Train")
            .background(theme.backgroundColor.ignoresSafeArea())
        }
        .onAppear {
            if viewModel == nil {
                viewModel = TrainViewModel(context: modelContext)
            } else {
                viewModel?.refreshPlans()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.mixed.cardio")
                .font(.system(size: 48))
                .foregroundStyle(theme.textSecondary.opacity(0.3))
            Text("No active training plans")
                .font(Typo.heading)
                .foregroundStyle(theme.textPrimary)
            Text("Go to Skills and start training a step")
                .font(Typo.body)
                .foregroundStyle(theme.textSecondary)
        }
    }

    private func activePlansList(viewModel: TrainViewModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.activePlans, id: \.stepID) { plan in
                    if let step = viewModel.step(for: plan) {
                        NavigationLink {
                            switch plan.trainingMethod {
                            case .greaseTheGroove:
                                GtGSessionView(plan: plan)
                            case .structured:
                                StructuredSessionView(plan: plan)
                            case .skillPractice:
                                SkillPracticeView(plan: plan)
                            }
                        } label: {
                            ActivePlanCard(step: step, plan: plan, viewModel: viewModel)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ActivePlanCard: View {
    let step: Step
    let plan: TrainingPlan
    let viewModel: TrainViewModel
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(step.name)
                    .font(Typo.heading)
                    .foregroundStyle(theme.textPrimary)
                Spacer()
                Text(plan.trainingMethod.shortName)
                    .font(Typo.small)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(theme.accentColor.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundStyle(theme.accentColor)
            }
            if let skillName = SkillCatalog.skill(byID: plan.skillID)?.name {
                Text(skillName)
                    .font(Typo.caption)
                    .foregroundStyle(theme.textSecondary)
            }
        }
        .padding(16)
        .background(theme.cardColor, in: RoundedRectangle(cornerRadius: 14))
    }
}
