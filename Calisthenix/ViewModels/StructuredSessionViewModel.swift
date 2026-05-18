import SwiftUI
import SwiftData

@Observable
@MainActor
final class StructuredSessionViewModel {
    let plan: TrainingPlan
    let step: Step
    private let context: ModelContext
    let timerService = TimerService()

    private(set) var currentSet: Int = 1
    private(set) var isResting: Bool = false
    var isComplete: Bool { currentSet > totalSets }

    var totalSets: Int { plan.targetSets ?? step.advancementCriteria.sets }
    var targetReps: Int { plan.targetReps ?? step.advancementCriteria.reps ?? 0 }
    var targetHold: Int { plan.targetHoldSeconds ?? step.advancementCriteria.holdSeconds ?? 0 }
    var restSeconds: Int { plan.restSeconds ?? 90 }
    var isHoldBased: Bool { targetHold > 0 }

    init(plan: TrainingPlan, step: Step, context: ModelContext) {
        self.plan = plan
        self.step = step
        self.context = context
    }

    func completeSet(reps: Int? = nil, holdSeconds: Int? = nil) {
        let entry = LogEntry(
            stepID: plan.stepID,
            skillID: plan.skillID,
            reps: reps,
            holdSeconds: holdSeconds,
            sets: 1,
            trainingMethod: .structured
        )
        context.insert(entry)
        try? context.save()

        if currentSet < totalSets {
            isResting = true
            timerService.start(seconds: restSeconds)
        }
        currentSet += 1
    }

    func skipRest() {
        timerService.skip()
        isResting = false
    }

    func onRestComplete() {
        isResting = false
    }
}
