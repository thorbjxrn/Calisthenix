import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var theme
    @State private var showingResetAlert = false
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    ForEach(AppTheme.allCases, id: \.rawValue) { appTheme in
                        Button {
                            theme.currentTheme = appTheme
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(appTheme.themePreviewColor)
                                    .frame(width: 24, height: 24)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(appTheme.displayName)
                                        .font(Typo.heading)
                                        .foregroundStyle(theme.textPrimary)
                                    if appTheme.isPremium {
                                        Text("Premium")
                                            .font(Typo.small)
                                            .foregroundStyle(theme.accentColor)
                                    }
                                }
                                Spacer()
                                if appTheme == theme.currentTheme {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(theme.accentColor)
                                }
                            }
                        }
                        .listRowBackground(theme.cardColor)
                    }
                }

                Section("Training") {
                    NavigationLink {
                        SplitConfigView()
                    } label: {
                        HStack {
                            Text("Training Split")
                                .font(Typo.heading)
                                .foregroundStyle(theme.textPrimary)
                        }
                    }
                    .listRowBackground(theme.cardColor)
                }

                Section("Premium") {
                    if StoreService.shared.isPremium {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(theme.masteredColor)
                            Text("Premium Active")
                                .font(Typo.heading)
                                .foregroundStyle(theme.textPrimary)
                        }
                        .listRowBackground(theme.cardColor)
                    } else {
                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown")
                                    .foregroundStyle(theme.masteredColor)
                                Text("Upgrade to Premium")
                                    .font(Typo.heading)
                                    .foregroundStyle(theme.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(theme.textSecondary)
                            }
                        }
                        .listRowBackground(theme.cardColor)
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                            .font(Typo.body)
                            .foregroundStyle(theme.textPrimary)
                        Spacer()
                        Text("1.0.0")
                            .font(Typo.caption)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .listRowBackground(theme.cardColor)
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.backgroundColor)
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}
