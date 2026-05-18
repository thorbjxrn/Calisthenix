import SwiftUI
import SwiftData

@Observable
@MainActor
final class SkillsViewModel {
    private let context: ModelContext
    private let engine: ProgressionEngine

    var skills: [Skill] { SkillCatalog.all }

    init(context: ModelContext) {
        self.context = context
        self.engine = ProgressionEngine(context: context)
        initializeAllProgress()
    }

    private func initializeAllProgress() {
        for skill in skills {
            engine.initializeProgress(for: skill)
        }
    }

    func masteredCount(for skill: Skill) -> Int {
        skill.steps.filter { engine.state(for: $0.id) == .mastered }.count
    }

    func activeCount(for skill: Skill) -> Int {
        skill.steps.filter { engine.state(for: $0.id) == .active }.count
    }
}
