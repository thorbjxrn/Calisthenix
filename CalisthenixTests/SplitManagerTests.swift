import Testing
import SwiftData
@testable import Calisthenix

@Suite("SplitManager")
struct SplitManagerTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    @Test("Default config is full body")
    @MainActor func defaultConfigIsFullBody() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let manager = SplitManager(context: context)
        let config = manager.currentConfiguration()
        #expect(config.split == .fullBody)
    }

    @Test("Updating split persists the change")
    @MainActor func updateSplitPersists() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let manager = SplitManager(context: context)
        manager.updateSplit(.pushPullLegs)
        let config = manager.currentConfiguration()
        #expect(config.split == .pushPullLegs)
    }

    @Test("Full body returns all skills")
    @MainActor func fullBodyReturnsAllSkills() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let manager = SplitManager(context: context)
        let skills = manager.skillsForToday(dayLabel: "")
        #expect(skills.count == SkillCatalog.all.count)
    }

    @Test("PPL filters by movement group")
    @MainActor func pplFiltersByGroup() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let manager = SplitManager(context: context)
        manager.updateSplit(.pushPullLegs)
        let pushSkills = manager.skillsForToday(dayLabel: "push")
        let pullSkills = manager.skillsForToday(dayLabel: "pull")
        let legSkills = manager.skillsForToday(dayLabel: "legs")
        #expect(!pushSkills.isEmpty)
        #expect(!pullSkills.isEmpty)
        #expect(!legSkills.isEmpty)
    }
}
