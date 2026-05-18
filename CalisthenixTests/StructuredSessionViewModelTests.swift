import Testing
import SwiftData
@testable import Calisthenix

@Suite("StructuredSessionViewModel")
struct StructuredSessionViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    private func makeTestStep() -> Step {
        Step(
            id: "test_step",
            name: "Test Step",
            skillID: "test_skill",
            description: "A test step",
            formCues: [],
            commonMistakes: [],
            prerequisiteIDs: [],
            movementCategory: .push,
            recommendedMethod: .structured,
            advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 3)
        )
    }

    @Test("Completing a set increments the counter")
    @MainActor func completingSetIncrementsCounter() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .structured, targetReps: 10, targetSets: 3)
        context.insert(plan)
        let vm = StructuredSessionViewModel(plan: plan, step: step, context: context)

        #expect(vm.currentSet == 1)
        vm.completeSet(reps: 10)
        #expect(vm.currentSet == 2)
        #expect(vm.isResting == true)
    }

    @Test("Session completes after all sets")
    @MainActor func sessionCompletesAfterAllSets() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .structured, targetReps: 8, targetSets: 2)
        context.insert(plan)
        let vm = StructuredSessionViewModel(plan: plan, step: step, context: context)

        vm.completeSet(reps: 8)
        vm.skipRest()
        vm.completeSet(reps: 8)
        #expect(vm.isComplete == true)
    }

    @Test("Logs entries to SwiftData")
    @MainActor func logsEntriesToSwiftData() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let step = makeTestStep()
        let plan = TrainingPlan(stepID: step.id, skillID: step.skillID, method: .structured, targetReps: 10, targetSets: 3)
        context.insert(plan)
        let vm = StructuredSessionViewModel(plan: plan, step: step, context: context)

        vm.completeSet(reps: 10)
        let entries = try context.fetch(FetchDescriptor<LogEntry>())
        #expect(entries.count == 1)
        #expect(entries.first?.reps == 10)
    }
}
