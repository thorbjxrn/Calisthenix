import Testing
import SwiftData
@testable import Calisthenix

@Suite("GtGViewModel")
struct GtGViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    @Test("Calculates target reps from max at 60%")
    @MainActor func targetRepsCalculation() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let plan = TrainingPlan(stepID: "ps-bw-squat", skillID: "pistol-squat", method: .greaseTheGroove)
        plan.maxReps = 20
        context.insert(plan)
        try context.save()
        let vm = GtGViewModel(plan: plan, context: context)
        #expect(vm.targetReps == 12)
    }

    @Test("Logs completed set and increments count")
    @MainActor func logCompletedSet() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let plan = TrainingPlan(stepID: "ps-bw-squat", skillID: "pistol-squat", method: .greaseTheGroove)
        plan.maxReps = 20
        plan.gtgSessionsPerDay = 5
        context.insert(plan)
        try context.save()
        let vm = GtGViewModel(plan: plan, context: context)
        vm.logSet(reps: 12)
        #expect(vm.setsCompletedToday == 1)
        let entries = try context.fetch(FetchDescriptor<LogEntry>())
        #expect(entries.count == 1)
        #expect(entries.first?.reps == 12)
    }

    @Test("Sets remaining calculation")
    @MainActor func setsRemaining() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let plan = TrainingPlan(stepID: "ps-bw-squat", skillID: "pistol-squat", method: .greaseTheGroove)
        plan.maxReps = 20
        plan.gtgSessionsPerDay = 5
        context.insert(plan)
        try context.save()
        let vm = GtGViewModel(plan: plan, context: context)
        #expect(vm.setsRemaining == 5)
        vm.logSet(reps: 12)
        #expect(vm.setsRemaining == 4)
    }
}
