import Foundation

struct Skill: Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let isPremium: Bool
    let steps: [Step]

    var rootSteps: [Step] { steps.filter { $0.prerequisiteIDs.isEmpty } }

    func step(byID id: String) -> Step? { steps.first { $0.id == id } }

    func children(of stepID: String) -> [Step] { steps.filter { $0.prerequisiteIDs.contains(stepID) } }
}

struct Step: Identifiable, Sendable {
    let id: String
    let name: String
    let skillID: String
    let description: String
    let formCues: [String]
    let commonMistakes: [String]
    let prerequisiteIDs: [String]
    let movementCategory: MovementCategory
    let recommendedMethod: TrainingMethod
    let advancementCriteria: AdvancementCriteria
    var mediaAsset: String? = nil
}

struct AdvancementCriteria: Sendable {
    let sets: Int
    var reps: Int? = nil
    var holdSeconds: Int? = nil
    let sessionsRequired: Int
}

enum TrainingMethod: String, CaseIterable, Sendable {
    case greaseTheGroove = "gtg"
    case structured = "structured"
    case skillPractice = "skill_practice"

    var displayName: String {
        switch self {
        case .greaseTheGroove: "Grease the Groove"
        case .structured: "Structured Session"
        case .skillPractice: "Skill Practice"
        }
    }

    var shortName: String {
        switch self {
        case .greaseTheGroove: "GtG"
        case .structured: "Sets & Reps"
        case .skillPractice: "Practice"
        }
    }
}

enum MovementCategory: String, CaseIterable, Sendable {
    case push, pull, legs, skill

    var splitGroup: SplitGroup {
        switch self {
        case .push, .pull, .skill: .upper
        case .legs: .lower
        }
    }

    var pplGroup: PPLGroup {
        switch self {
        case .push, .skill: .push
        case .pull: .pull
        case .legs: .legs
        }
    }
}

enum SplitGroup: String, Sendable { case upper, lower }
enum PPLGroup: String, Sendable { case push, pull, legs }

enum SplitType: String, CaseIterable, Sendable {
    case fullBody = "full_body"
    case pushPullLegs = "ppl"
    case upperLower = "upper_lower"

    var displayName: String {
        switch self {
        case .fullBody: "Full Body"
        case .pushPullLegs: "Push / Pull / Legs"
        case .upperLower: "Upper / Lower"
        }
    }
}

enum StepState: String, Sendable { case locked, available, active, mastered }

enum TrainingMode: String, CaseIterable, Sendable {
    case guided, manual

    var displayName: String {
        switch self {
        case .guided: "Guided"
        case .manual: "Manual"
        }
    }
}
