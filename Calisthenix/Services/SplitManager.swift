import SwiftData

@MainActor
final class SplitManager {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func currentConfiguration() -> SplitConfiguration {
        let descriptor = FetchDescriptor<SplitConfiguration>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let config = SplitConfiguration()
        context.insert(config)
        try? context.save()
        return config
    }

    func updateSplit(_ splitType: SplitType) {
        let config = currentConfiguration()
        config.split = splitType
        try? context.save()
    }

    func skillsForToday(dayLabel: String) -> [Skill] {
        let config = currentConfiguration()
        switch config.split {
        case .fullBody:
            return SkillCatalog.all
        case .pushPullLegs:
            guard let group = PPLGroup(rawValue: dayLabel) else { return SkillCatalog.all }
            return SkillCatalog.all.filter { skill in
                skill.steps.contains { $0.movementCategory.pplGroup == group }
            }
        case .upperLower:
            guard let group = SplitGroup(rawValue: dayLabel) else { return SkillCatalog.all }
            return SkillCatalog.all.filter { skill in
                skill.steps.contains { $0.movementCategory.splitGroup == group }
            }
        }
    }
}
