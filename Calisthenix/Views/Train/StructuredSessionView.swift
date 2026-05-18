import SwiftUI
import SwiftData

struct StructuredSessionView: View {
    let plan: TrainingPlan
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: StructuredSessionViewModel?
    @State private var showingLogSheet = false

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
                    activeSetView(viewModel: viewModel)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(stepName)
        .background(theme.backgroundColor.ignoresSafeArea())
        .onAppear {
            if viewModel == nil, let step = SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID) {
                viewModel = StructuredSessionViewModel(plan: plan, step: step, context: modelContext)
            }
        }
        .onDisappear {
            viewModel?.timerService.stop()
        }
    }

    private var stepName: String {
        SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID)?.name ?? plan.stepID
    }

    private func activeSetView(viewModel: StructuredSessionViewModel) -> some View {
        VStack(spacing: 24) {
            Spacer()
            VStack(spacing: 4) {
                Text("Set \(viewModel.currentSet) of \(viewModel.totalSets)")
                    .font(Typo.title)
                    .foregroundStyle(theme.textPrimary)
                if viewModel.isHoldBased {
                    Text("Hold for \(viewModel.targetHold)s")
                        .font(Typo.body)
                        .foregroundStyle(theme.textSecondary)
                } else {
                    Text("Target: \(viewModel.targetReps) reps")
                        .font(Typo.body)
                        .foregroundStyle(theme.textSecondary)
                }
            }

            Button("Complete Set") {
                if viewModel.isHoldBased {
                    viewModel.completeSet(holdSeconds: viewModel.targetHold)
                } else {
                    showingLogSheet = true
                }
            }
            .font(Typo.heading)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(theme.ctaTextColor)
            .padding(.horizontal, 16)
            Spacer()
        }
        .sheet(isPresented: $showingLogSheet) {
            QuickLogView(stepName: stepName, targetReps: viewModel.targetReps) { reps in
                viewModel.completeSet(reps: reps)
            }
        }
    }

    private var completeView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(theme.completedColor)
            Text("Session Complete!")
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
