import SwiftUI
import SwiftData

@Observable
@MainActor
final class ProgressViewModel {
    private let context: ModelContext

    private(set) var totalMastered: Int = 0
    private(set) var totalSteps: Int = 0
    private(set) var totalSessions: Int = 0
    private(set) var currentStreak: Int = 0
    private(set) var skillProgress: [(skill: Skill, mastered: Int, total: Int)] = []

    init(context: ModelContext) {
        self.context = context
        refresh()
    }

    func refresh() {
        totalSteps = SkillCatalog.all.reduce(0) { $0 + $1.steps.count }

        let allProgress = (try? context.fetch(FetchDescriptor<UserStepProgress>())) ?? []
        totalMastered = allProgress.filter { $0.stepState == .mastered }.count

        let allEntries = (try? context.fetch(FetchDescriptor<LogEntry>())) ?? []
        let calendar = Calendar.current
        let uniqueDays = Set(allEntries.map { calendar.startOfDay(for: $0.date) })
        totalSessions = uniqueDays.count

        currentStreak = calculateStreak(from: uniqueDays, calendar: calendar)

        skillProgress = SkillCatalog.all.map { skill in
            let mastered = allProgress.filter { $0.skillID == skill.id && $0.stepState == .mastered }.count
            return (skill: skill, mastered: mastered, total: skill.steps.count)
        }
    }

    private func calculateStreak(from days: Set<Date>, calendar: Calendar) -> Int {
        guard !days.isEmpty else { return 0 }
        var streak = 0
        var checkDate = calendar.startOfDay(for: .now)

        if !days.contains(checkDate) {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            if !days.contains(checkDate) { return 0 }
        }

        while days.contains(checkDate) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
}
