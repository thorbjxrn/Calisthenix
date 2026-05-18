import Foundation
import SwiftData

@Model
final class SplitConfiguration {
    var splitType: String
    var customAssignments: [String: String]

    init(splitType: SplitType = .fullBody) {
        self.splitType = splitType.rawValue
        self.customAssignments = [:]
    }

    var split: SplitType {
        get { SplitType(rawValue: splitType) ?? .fullBody }
        set { splitType = newValue.rawValue }
    }
}
