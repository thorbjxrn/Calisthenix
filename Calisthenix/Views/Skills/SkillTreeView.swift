import SwiftUI
import SwiftData

struct SkillTreeView: View {
    let skill: Skill
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var viewModel: SkillTreeViewModel?
    @State private var selectedStep: Step?
    @State private var stepForTrainingPlan: Step?
    @State private var showingTrainingMethodPicker = false

    var body: some View {
        Group {
            if let viewModel {
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(Array(viewModel.levels.enumerated()), id: \.offset) { _, level in
                            HStack(spacing: 20) {
                                ForEach(level) { step in
                                    StepNodeView(
                                        step: step,
                                        state: viewModel.state(for: step.id)
                                    ) {
                                        selectedStep = step
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(skill.name)
        .background(theme.backgroundColor.ignoresSafeArea())
        .sheet(item: $selectedStep) { step in
            if let viewModel {
                TechniqueCardView(
                    step: step,
                    state: viewModel.state(for: step.id),
                    onActivate: {
                        viewModel.activate(stepID: step.id)
                        stepForTrainingPlan = step
                        showingTrainingMethodPicker = true
                    },
                    onMaster: { viewModel.master(stepID: step.id) },
                    onManualUnlock: { viewModel.manualUnlock(stepID: step.id) }
                )
            }
        }
        .sheet(isPresented: $showingTrainingMethodPicker) {
            if let stepForTrainingPlan {
                TrainingMethodPickerView(step: stepForTrainingPlan) { method, mode in
                    let plan = TrainingPlan(
                        stepID: stepForTrainingPlan.id,
                        skillID: stepForTrainingPlan.skillID,
                        method: method,
                        mode: mode
                    )
                    modelContext.insert(plan)
                    try? modelContext.save()
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = SkillTreeViewModel(skill: skill, context: modelContext)
            }
        }
    }
}

extension Step: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.id == rhs.id
    }
}
