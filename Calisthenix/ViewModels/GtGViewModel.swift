import SwiftUI
import SwiftData

@Observable
@MainActor
final class GtGViewModel {
    let plan: TrainingPlan
    private let context: ModelContext
    private(set) var setsCompletedToday: Int = 0

    var targetReps: Int { plan.gtgTargetReps ?? 5 }
    var totalSetsPlanned: Int { plan.gtgSessionsPerDay ?? 5 }
    var setsRemaining: Int { max(0, totalSetsPlanned - setsCompletedToday) }

    var stepName: String {
        SkillCatalog.skill(byID: plan.skillID)?.step(byID: plan.stepID)?.name ?? plan.stepID
    }

    init(plan: TrainingPlan, context: ModelContext) {
        self.plan = plan
        self.context = context
        countTodaySets()
    }

    func logSet(reps: Int) {
        let entry = LogEntry(stepID: plan.stepID, skillID: plan.skillID, reps: reps, sets: 1, trainingMethod: .greaseTheGroove)
        context.insert(entry)
        try? context.save()
        setsCompletedToday += 1
    }

    private func countTodaySets() {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let stepID = plan.stepID
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate {
            $0.stepID == stepID && $0.date >= startOfDay
        })
        setsCompletedToday = (try? context.fetch(descriptor).count) ?? 0
    }
}
