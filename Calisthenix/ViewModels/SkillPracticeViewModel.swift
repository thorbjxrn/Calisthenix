import SwiftUI
import SwiftData

@Observable
@MainActor
final class SkillPracticeViewModel {
    let plan: TrainingPlan
    let step: Step
    private let context: ModelContext
    let timerService = TimerService()

    private(set) var currentSet: Int = 1
    private(set) var isResting: Bool = false
    var isComplete: Bool { currentSet > totalSets }

    var totalSets: Int { plan.targetSets ?? step.advancementCriteria.sets }
    var targetHold: Int { plan.targetHoldSeconds ?? step.advancementCriteria.holdSeconds ?? 30 }
    var restSeconds: Int { plan.restSeconds ?? 120 }

    init(plan: TrainingPlan, step: Step, context: ModelContext) {
        self.plan = plan
        self.step = step
        self.context = context
    }

    func startHold() {
        timerService.start(seconds: targetHold)
    }

    func completeAttempt() {
        guard timerService.isRunning else { return }
        let holdDuration = targetHold - timerService.remainingSeconds
        timerService.stop()

        let entry = LogEntry(
            stepID: plan.stepID,
            skillID: plan.skillID,
            holdSeconds: holdDuration,
            sets: 1,
            trainingMethod: .skillPractice
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
