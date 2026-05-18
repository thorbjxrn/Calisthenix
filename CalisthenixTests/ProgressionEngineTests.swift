import Testing
import SwiftData
import Foundation
@testable import Calisthenix

@Suite("ProgressionEngine")
struct ProgressionEngineTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: UserStepProgress.self, LogEntry.self, TrainingPlan.self, SplitConfiguration.self,
            configurations: config
        )
    }

    @Test("Root steps start as available, others as locked")
    @MainActor
    func initialStepStates() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let skill = SkillCatalog.pistolSquat

        engine.initializeProgress(for: skill)

        let rootProgress = try context.fetch(FetchDescriptor<UserStepProgress>()).filter { $0.stepID == "ps-bw-squat" }
        #expect(rootProgress.first?.stepState == .available)

        let lockedProgress = try context.fetch(FetchDescriptor<UserStepProgress>()).filter { $0.stepID == "ps-bulgarian" }
        #expect(lockedProgress.first?.stepState == .locked)
    }

    @Test("Step state resolves correctly")
    @MainActor
    func stepStateResolution() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let skill = SkillCatalog.pistolSquat

        engine.initializeProgress(for: skill)

        #expect(engine.state(for: "ps-bw-squat") == .available)
        #expect(engine.state(for: "ps-bulgarian") == .locked)
    }

    @Test("Activating a step changes its state")
    @MainActor
    func activateStep() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let skill = SkillCatalog.pistolSquat

        engine.initializeProgress(for: skill)
        engine.activate(stepID: "ps-bw-squat")

        #expect(engine.state(for: "ps-bw-squat") == .active)
    }

    @Test("Mastering a step unlocks children whose prerequisites are all met")
    @MainActor
    func masteringUnlocksChildren() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let skill = SkillCatalog.pistolSquat

        engine.initializeProgress(for: skill)
        engine.activate(stepID: "ps-bw-squat")
        engine.master(stepID: "ps-bw-squat", in: skill)

        #expect(engine.state(for: "ps-bw-squat") == .mastered)
        #expect(engine.state(for: "ps-box-squat") == .available)
        #expect(engine.state(for: "ps-bulgarian") == .locked)
    }

    @Test("Convergent step requires all prerequisites mastered")
    @MainActor
    func convergentStepNeedsAllPrereqs() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let skill = SkillCatalog.pistolSquat

        engine.initializeProgress(for: skill)

        // Master through the eccentric path only
        for stepID in ["ps-bw-squat", "ps-box-squat", "ps-bulgarian", "ps-assisted", "ps-eccentric"] {
            engine.activate(stepID: stepID)
            engine.master(stepID: stepID, in: skill)
        }

        // Full pistol requires both ps-eccentric AND ps-archer
        #expect(engine.state(for: "ps-full") == .locked)

        // Now master the archer path
        for stepID in ["ps-wide-archer", "ps-archer"] {
            engine.activate(stepID: stepID)
            engine.master(stepID: stepID, in: skill)
        }

        #expect(engine.state(for: "ps-full") == .available)
    }

    @Test("Check advancement criteria met")
    @MainActor
    func advancementCheck() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let engine = ProgressionEngine(context: context)
        let step = SkillCatalog.pistolSquat.steps[0] // bw squat: 3x20, 2 sessions

        // Log 2 sessions on DIFFERENT days, 3 sets of 20 reps each
        for sessionIndex in 0..<2 {
            for _ in 0..<3 {
                let entry = LogEntry(stepID: step.id, skillID: "pistol-squat", reps: 20, sets: 1, trainingMethod: .greaseTheGroove)
                entry.date = Calendar.current.date(byAdding: .day, value: -sessionIndex, to: .now)!
                context.insert(entry)
            }
        }
        try context.save()

        let result = engine.checkAdvancement(for: step)
        #expect(result == true)
    }
}
