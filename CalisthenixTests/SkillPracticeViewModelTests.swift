import Testing
import SwiftData
@testable import Calisthenix

@Suite("SkillPracticeViewModel")
struct SkillPracticeViewModelTests {
    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    private func makeTestStep() -> Step {
        Step(
            id: "test_hold",
            name: "Test Hold",
            skillID: "test_skill",
            description: "A hold step",
            formCues: [],
            commonMistakes: [],
            prerequisiteIDs: [],
            movementCategory: .skill,
            recommendedMethod: .skillPractice,
            advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 30, sessionsRequired: 3)
        )
    }

    @Test @MainActor
    func completingAttemptIncrementsCounter() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .skillPractice, targetSets: 3, targetHoldSeconds: 30)
        context.insert(plan)
        let vm = SkillPracticeViewModel(plan: plan, step: step, context: context)

        #expect(vm.currentSet == 1)
        vm.startHold()
        vm.completeAttempt()
        #expect(vm.currentSet == 2)
        #expect(vm.isResting == true)
    }

    @Test @MainActor
    func practiceCompletesAfterAllAttempts() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .skillPractice, targetSets: 2, targetHoldSeconds: 30)
        context.insert(plan)
        let vm = SkillPracticeViewModel(plan: plan, step: step, context: context)

        vm.startHold()
        vm.completeAttempt()
        vm.skipRest()
        vm.startHold()
        vm.completeAttempt()
        #expect(vm.isComplete == true)
    }

    @Test @MainActor
    func logsHoldDurationToSwiftData() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .skillPractice, targetSets: 3, targetHoldSeconds: 30)
        context.insert(plan)
        let vm = SkillPracticeViewModel(plan: plan, step: step, context: context)

        vm.startHold()
        vm.completeAttempt()
        let entries = try context.fetch(FetchDescriptor<LogEntry>())
        #expect(entries.count == 1)
        #expect(entries.first?.holdSeconds != nil)
    }
}
