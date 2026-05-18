import Foundation
import SwiftData

@Model
final class UserStepProgress {
    var stepID: String
    var skillID: String
    var state: String
    var dateStarted: Date?
    var dateMastered: Date?

    init(stepID: String, skillID: String, state: StepState = .locked) {
        self.stepID = stepID
        self.skillID = skillID
        self.state = state.rawValue
        self.dateStarted = state == .active ? .now : nil
    }

    var stepState: StepState {
        get { StepState(rawValue: state) ?? .locked }
        set { state = newValue.rawValue }
    }
}
