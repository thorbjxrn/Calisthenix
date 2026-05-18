import Foundation
import SwiftData

@Model
final class LogEntry {
    var stepID: String
    var skillID: String
    var reps: Int?
    var holdSeconds: Int?
    var sets: Int
    var date: Date
    var trainingMethod: String
    var notes: String?

    init(stepID: String, skillID: String, reps: Int? = nil, holdSeconds: Int? = nil, sets: Int = 1, trainingMethod: TrainingMethod, notes: String? = nil) {
        self.stepID = stepID
        self.skillID = skillID
        self.reps = reps
        self.holdSeconds = holdSeconds
        self.sets = sets
        self.date = .now
        self.trainingMethod = trainingMethod.rawValue
        self.notes = notes
    }
}
