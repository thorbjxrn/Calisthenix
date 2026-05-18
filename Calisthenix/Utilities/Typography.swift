import SwiftUI

enum Typo {
    static var hero: Font { .system(size: 56, weight: .heavy) }
    static var title: Font { .system(size: 28, weight: .bold) }
    static var heading: Font { .system(.headline) }
    static var body: Font { .subheadline }
    static var bodyEmphasis: Font { .subheadline.weight(.semibold) }
    static var caption: Font { .caption }
    static var captionEmphasis: Font { .caption.bold() }
    static var small: Font { .caption2.weight(.medium) }
    static var repCount: Font { .system(size: 40, weight: .bold, design: .rounded) }
    static var repStandard: Font { .system(.body, design: .rounded, weight: .semibold) }
    static var timer: Font { .system(.title2, design: .monospaced, weight: .bold) }
    static var timerCompact: Font { .system(.subheadline, design: .monospaced) }
    static var statValue: Font { .system(.title3, design: .rounded, weight: .bold) }
    static var statLabel: Font { .caption2 }
    static var tabLabel: Font { .system(size: 12, weight: .medium) }
}
