import SwiftUI
import SwiftData

@Observable
@MainActor
final class TrainViewModel {
    private let context: ModelContext
    private(set) var activePlans: [TrainingPlan] = []

    init(context: ModelContext) {
        self.context = context
        refreshPlans()
    }

    func refreshPlans() {
        let descriptor = FetchDescriptor<TrainingPlan>(predicate: #Predicate { $0.isActive })
        activePlans = (try? context.fetch(descriptor)) ?? []
    }

    func createPlan(stepID: String, skillID: String, method: TrainingMethod, mode: TrainingMode) {
        let plan = TrainingPlan(stepID: stepID, skillID: skillID, method: method, mode: mode)
        context.insert(plan)
        try? context.save()
        refreshPlans()
    }

    func deactivatePlan(_ plan: TrainingPlan) {
        plan.isActive = false
        try? context.save()
        refreshPlans()
    }

    func logSet(stepID: String, skillID: String, reps: Int? = nil, holdSeconds: Int? = nil, method: TrainingMethod, notes: String? = nil) {
        let entry = LogEntry(stepID: stepID, skillID: skillID, reps: reps, holdSeconds: holdSeconds, sets: 1, trainingMethod: method, notes: notes)
        context.insert(entry)
        try? context.save()
    }

    func step(for plan: TrainingPlan) -> Step? {
        SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID)
    }
}
