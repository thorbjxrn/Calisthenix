import SwiftUI
import SwiftData

struct GtGSessionView: View {
    let plan: TrainingPlan
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var viewModel: GtGViewModel?
    @State private var showingQuickLog = false

    var body: some View {
        Group {
            if let viewModel {
                VStack(spacing: 24) {
                    Spacer()
                    Text(viewModel.stepName)
                        .font(Typo.title)
                        .foregroundStyle(theme.textPrimary)
                    VStack(spacing: 4) {
                        Text("\(viewModel.setsCompletedToday) / \(viewModel.totalSetsPlanned)")
                            .font(Typo.repCount)
                            .foregroundStyle(theme.textPrimary)
                        Text("sets today")
                            .font(Typo.caption)
                            .foregroundStyle(theme.textSecondary)
                    }
                    if viewModel.setsRemaining > 0 {
                        VStack(spacing: 4) {
                            Text("Target: \(viewModel.targetReps) reps")
                                .font(Typo.bodyEmphasis)
                                .foregroundStyle(theme.textPrimary)
                            Text("\(viewModel.setsRemaining) sets remaining")
                                .font(Typo.caption)
                                .foregroundStyle(theme.textSecondary)
                        }
                        Button("Log Set") { showingQuickLog = true }
                            .font(Typo.heading)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(theme.accentColor, in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(theme.ctaTextColor)
                            .padding(.horizontal, 16)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(theme.completedColor)
                            Text("All sets done for today")
                                .font(Typo.heading)
                                .foregroundStyle(theme.completedColor)
                        }
                    }
                    Spacer()
                }
                .sheet(isPresented: $showingQuickLog) {
                    QuickLogView(stepName: viewModel.stepName, targetReps: viewModel.targetReps) { reps in
                        viewModel.logSet(reps: reps)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .background(theme.backgroundColor.ignoresSafeArea())
        .onAppear {
            if viewModel == nil {
                viewModel = GtGViewModel(plan: plan, context: modelContext)
            }
        }
    }
}
