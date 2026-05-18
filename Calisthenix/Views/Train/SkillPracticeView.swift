import SwiftUI
import SwiftData

struct SkillPracticeView: View {
    let plan: TrainingPlan
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SkillPracticeViewModel?

    var body: some View {
        Group {
            if let viewModel {
                if viewModel.isComplete {
                    completeView
                } else if viewModel.isResting {
                    RestTimerView(timerService: viewModel.timerService) {
                        viewModel.skipRest()
                    }
                    .onChange(of: viewModel.timerService.isRunning) { _, isRunning in
                        if !isRunning && viewModel.isResting {
                            viewModel.onRestComplete()
                        }
                    }
                } else {
                    attemptView(viewModel: viewModel)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(stepName)
        .background(theme.backgroundColor.ignoresSafeArea())
        .onAppear {
            if viewModel == nil, let step = SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID) {
                viewModel = SkillPracticeViewModel(plan: plan, step: step, context: modelContext)
            }
        }
        .onDisappear {
            viewModel?.timerService.stop()
        }
    }

    private var stepName: String {
        SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID)?.name ?? plan.stepID
    }

    private func attemptView(viewModel: SkillPracticeViewModel) -> some View {
        VStack(spacing: 24) {
            Spacer()
            VStack(spacing: 4) {
                Text("Attempt \(viewModel.currentSet) of \(viewModel.totalSets)")
                    .font(Typo.title)
                    .foregroundStyle(theme.textPrimary)
                Text("Hold for \(viewModel.targetHold)s")
                    .font(Typo.body)
                    .foregroundStyle(theme.textSecondary)
            }

            if viewModel.timerService.isRunning {
                Text(viewModel.timerService.formattedTime)
                    .font(Typo.repCount)
                    .foregroundStyle(theme.accentColor)
                    .contentTransition(.numericText())

                Button("Done") {
                    viewModel.completeAttempt()
                }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.completedColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
            } else {
                Button("Start Hold") {
                    viewModel.startHold()
                }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(theme.ctaTextColor)
                .padding(.horizontal, 16)
            }
            Spacer()
        }
    }

    private var completeView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(theme.completedColor)
            Text("Practice Complete!")
                .font(Typo.title)
                .foregroundStyle(theme.textPrimary)
            Button("Done") { dismiss() }
                .font(Typo.heading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(theme.ctaTextColor)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
}
