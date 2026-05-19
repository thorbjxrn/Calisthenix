import SwiftUI
import SwiftData

struct SkillsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var theme
    @State private var viewModel: SkillsViewModel?
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.skills) { skill in
                                if skill.isPremium && !StoreService.shared.isPremium {
                                    Button {
                                        showingPaywall = true
                                    } label: {
                                        SkillCard(skill: skill, mastered: viewModel.masteredCount(for: skill))
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    NavigationLink(value: skill.id) {
                                        SkillCard(skill: skill, mastered: viewModel.masteredCount(for: skill))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Skills")
            .navigationDestination(for: String.self) { skillID in
                if let skill = SkillCatalog.skill(byID: skillID) {
                    if skill.isPremium && !StoreService.shared.isPremium {
                        PaywallView()
                    } else {
                        SkillTreeView(skill: skill)
                    }
                }
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
        .onAppear {
            if viewModel == nil {
                viewModel = SkillsViewModel(context: modelContext)
            }
        }
    }
}

struct SkillCard: View {
    let skill: Skill
    let mastered: Int
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(skill.name)
                        .font(Typo.heading)
                        .foregroundStyle(theme.textPrimary)
                    if skill.isPremium {
                        Text("PRO")
                            .font(Typo.small)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(theme.accentColor.opacity(0.2))
                            .clipShape(Capsule())
                            .foregroundStyle(theme.accentColor)
                    }
                }
                Text(skill.description)
                    .font(Typo.caption)
                    .foregroundStyle(theme.textSecondary)
            }
            Spacer()
            Text("\(mastered)/\(skill.steps.count)")
                .font(Typo.repStandard)
                .foregroundStyle(mastered == skill.steps.count ? theme.masteredColor : theme.textSecondary)
        }
        .padding(16)
        .background(theme.cardColor, in: RoundedRectangle(cornerRadius: 14))
    }
}
