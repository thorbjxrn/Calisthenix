import Testing
import SwiftData
@testable import Calisthenix

@Suite("TrainViewModel")
struct TrainViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    @Test("Active plans are fetched correctly")
    @MainActor func activePlans() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let plan = TrainingPlan(stepID: "ps-bw-squat", skillID: "pistol-squat", method: .greaseTheGroove)
        context.insert(plan)
        try context.save()
        let vm = TrainViewModel(context: context)
        #expect(vm.activePlans.count == 1)
        #expect(vm.activePlans.first?.stepID == "ps-bw-squat")
    }

    @Test("Creating a plan for a step persists it")
    @MainActor func createPlan() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = TrainViewModel(context: context)
        vm.createPlan(stepID: "ps-bw-squat", skillID: "pistol-squat", method: .greaseTheGroove, mode: .guided)
        let plans = try context.fetch(FetchDescriptor<TrainingPlan>())
        #expect(plans.count == 1)
        #expect(plans.first?.trainingMethod == .greaseTheGroove)
    }

    @Test("Logging a set creates a LogEntry")
    @MainActor func logSet() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = TrainViewModel(context: context)
        vm.logSet(stepID: "ps-bw-squat", skillID: "pistol-squat", reps: 15, method: .greaseTheGroove)
        let entries = try context.fetch(FetchDescriptor<LogEntry>())
        #expect(entries.count == 1)
        #expect(entries.first?.reps == 15)
    }
}
