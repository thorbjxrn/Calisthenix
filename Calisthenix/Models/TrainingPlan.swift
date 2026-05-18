import Foundation
import SwiftData

@Model
final class TrainingPlan {
    var stepID: String
    var skillID: String
    var method: String
    var mode: String
    var targetReps: Int?
    var targetSets: Int?
    var targetHoldSeconds: Int?
    var restSeconds: Int?
    var maxReps: Int?
    var gtgWindowStart: Int?
    var gtgWindowEnd: Int?
    var gtgSessionsPerDay: Int?
    var isActive: Bool

    init(
        stepID: String,
        skillID: String,
        method: TrainingMethod,
        mode: TrainingMode = .guided,
        targetReps: Int? = nil,
        targetSets: Int? = nil,
        targetHoldSeconds: Int? = nil,
        restSeconds: Int? = nil
    ) {
        self.stepID = stepID
        self.skillID = skillID
        self.method = method.rawValue
        self.mode = mode.rawValue
        self.targetReps = targetReps
        self.targetSets = targetSets
        self.targetHoldSeconds = targetHoldSeconds
        self.restSeconds = restSeconds
        self.maxReps = nil
        self.gtgWindowStart = nil
        self.gtgWindowEnd = nil
        self.gtgSessionsPerDay = nil
        self.isActive = true
    }

    var trainingMethod: TrainingMethod {
        TrainingMethod(rawValue: method) ?? .structured
    }

    var trainingMode: TrainingMode {
        TrainingMode(rawValue: mode) ?? .guided
    }

    var gtgTargetReps: Int? {
        guard let maxReps else { return nil }
        return Int(Double(maxReps) * 0.6)
    }
}
