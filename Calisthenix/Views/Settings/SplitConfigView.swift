import SwiftUI
import SwiftData

struct SplitConfigView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var currentSplit: SplitType = .fullBody

    var body: some View {
        List {
            Section {
                ForEach(SplitType.allCases, id: \.rawValue) { split in
                    Button {
                        currentSplit = split
                        let manager = SplitManager(context: modelContext)
                        manager.updateSplit(split)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(split.displayName)
                                    .font(Typo.heading)
                                    .foregroundStyle(theme.textPrimary)
                                Text(splitDescription(split))
                                    .font(Typo.caption)
                                    .foregroundStyle(theme.textSecondary)
                            }
                            Spacer()
                            if split == currentSplit {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(theme.accentColor)
                            }
                        }
                    }
                    .listRowBackground(theme.cardColor)
                }
            } header: {
                Text("Training Split")
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.backgroundColor)
        .navigationTitle("Training Split")
        .onAppear {
            let manager = SplitManager(context: modelContext)
            currentSplit = manager.currentConfiguration().split
        }
    }

    private func splitDescription(_ split: SplitType) -> String {
        switch split {
        case .fullBody: "Train all movement patterns each session"
        case .pushPullLegs: "Alternate push, pull, and leg days"
        case .upperLower: "Alternate upper and lower body days"
        }
    }
}
