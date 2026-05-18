import Testing
import SwiftData
@testable import Calisthenix

@Suite("SkillTreeViewModel")
struct SkillTreeViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    @Test("Organizes steps into levels by depth")
    @MainActor func organizesIntoLevels() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = SkillTreeViewModel(skill: SkillCatalog.pistolSquat, context: context)

        #expect(vm.levels.count >= 3)
        #expect(vm.levels[0].contains { $0.id == "ps-bw-squat" })
    }

    @Test("Step state reflects progression engine")
    @MainActor func stepStateFromEngine() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = SkillTreeViewModel(skill: SkillCatalog.pistolSquat, context: context)

        #expect(vm.state(for: "ps-bw-squat") == .available)
        #expect(vm.state(for: "ps-full") == .locked)
    }

    @Test("Activating a step updates state")
    @MainActor func activateStep() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = SkillTreeViewModel(skill: SkillCatalog.pistolSquat, context: context)

        vm.activate(stepID: "ps-bw-squat")
        #expect(vm.state(for: "ps-bw-squat") == .active)
    }
}
