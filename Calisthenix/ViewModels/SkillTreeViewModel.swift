import SwiftUI
import SwiftData

@Observable
@MainActor
final class SkillTreeViewModel {
    let skill: Skill
    private let engine: ProgressionEngine
    private(set) var levels: [[Step]] = []

    init(skill: Skill, context: ModelContext) {
        self.skill = skill
        self.engine = ProgressionEngine(context: context)
        engine.initializeProgress(for: skill)
        buildLevels()
    }

    func state(for stepID: String) -> StepState {
        engine.state(for: stepID)
    }

    func activate(stepID: String) {
        engine.activate(stepID: stepID)
    }

    func master(stepID: String) {
        engine.master(stepID: stepID, in: skill)
        buildLevels()
    }

    func manualUnlock(stepID: String) {
        engine.manualUnlock(stepID: stepID)
    }

    private func buildLevels() {
        var depth: [String: Int] = [:]

        func computeDepth(_ step: Step) -> Int {
            if let d = depth[step.id] { return d }
            if step.prerequisiteIDs.isEmpty {
                depth[step.id] = 0
                return 0
            }
            let maxPrereqDepth = step.prerequisiteIDs.compactMap { prereqID in
                skill.step(byID: prereqID).map { computeDepth($0) }
            }.max() ?? 0
            let d = maxPrereqDepth + 1
            depth[step.id] = d
            return d
        }

        for step in skill.steps {
            _ = computeDepth(step)
        }

        let maxDepth = depth.values.max() ?? 0
        var result: [[Step]] = Array(repeating: [], count: maxDepth + 1)
        for step in skill.steps {
            let d = depth[step.id] ?? 0
            result[d].append(step)
        }

        levels = result
    }
}
