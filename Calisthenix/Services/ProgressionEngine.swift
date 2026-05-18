import Foundation
import SwiftData

@MainActor
final class ProgressionEngine {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func initializeProgress(for skill: Skill) {
        let existingIDs = Set((try? context.fetch(FetchDescriptor<UserStepProgress>()))?.filter { $0.skillID == skill.id }.map(\.stepID) ?? [])

        for step in skill.steps {
            guard !existingIDs.contains(step.id) else { continue }
            let isRoot = step.prerequisiteIDs.isEmpty
            let progress = UserStepProgress(stepID: step.id, skillID: skill.id, state: isRoot ? .available : .locked)
            context.insert(progress)
        }
        try? context.save()
    }

    func state(for stepID: String) -> StepState {
        let descriptor = FetchDescriptor<UserStepProgress>(predicate: #Predicate { $0.stepID == stepID })
        guard let progress = try? context.fetch(descriptor).first else { return .locked }
        return progress.stepState
    }

    func activate(stepID: String) {
        let descriptor = FetchDescriptor<UserStepProgress>(predicate: #Predicate { $0.stepID == stepID })
        guard let progress = try? context.fetch(descriptor).first else { return }
        progress.stepState = .active
        progress.dateStarted = .now
        try? context.save()
    }

    func master(stepID: String, in skill: Skill) {
        let descriptor = FetchDescriptor<UserStepProgress>(predicate: #Predicate { $0.stepID == stepID })
        guard let progress = try? context.fetch(descriptor).first else { return }
        progress.stepState = .mastered
        progress.dateMastered = .now

        let children = skill.children(of: stepID)
        for child in children {
            let allPrereqsMet = child.prerequisiteIDs.allSatisfy { prereqID in
                state(for: prereqID) == .mastered
            }
            if allPrereqsMet {
                let childID = child.id
                let childDescriptor = FetchDescriptor<UserStepProgress>(predicate: #Predicate<UserStepProgress> { p in p.stepID == childID })
                if let childProgress = try? context.fetch(childDescriptor).first, childProgress.stepState == .locked {
                    childProgress.stepState = .available
                }
            }
        }
        try? context.save()
    }

    func manualUnlock(stepID: String) {
        let descriptor = FetchDescriptor<UserStepProgress>(predicate: #Predicate { $0.stepID == stepID })
        guard let progress = try? context.fetch(descriptor).first else { return }
        if progress.stepState == .locked {
            progress.stepState = .available
            try? context.save()
        }
    }

    func checkAdvancement(for step: Step) -> Bool {
        let stepID = step.id
        let criteria = step.advancementCriteria
        let descriptor = FetchDescriptor<LogEntry>(
            predicate: #Predicate { $0.stepID == stepID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        guard let entries = try? context.fetch(descriptor) else { return false }

        let calendar = Calendar.current
        var sessionsByDay: [Date: [LogEntry]] = [:]
        for entry in entries {
            let day = calendar.startOfDay(for: entry.date)
            sessionsByDay[day, default: []].append(entry)
        }

        var qualifyingSessions = 0
        for (_, dayEntries) in sessionsByDay {
            let totalSets = dayEntries.count
            guard totalSets >= criteria.sets else { continue }

            if let targetReps = criteria.reps {
                let qualifyingEntries = dayEntries.filter { ($0.reps ?? 0) >= targetReps }
                if qualifyingEntries.count >= criteria.sets {
                    qualifyingSessions += 1
                }
            } else if let targetHold = criteria.holdSeconds {
                let qualifyingEntries = dayEntries.filter { ($0.holdSeconds ?? 0) >= targetHold }
                if qualifyingEntries.count >= criteria.sets {
                    qualifyingSessions += 1
                }
            }
        }

        return qualifyingSessions >= criteria.sessionsRequired
    }
}
