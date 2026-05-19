import SwiftUI

struct PaywallView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false

    let storeService = StoreService.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "crown.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(theme.masteredColor)

                Text("Unlock Premium")
                    .font(Typo.title)
                    .foregroundStyle(theme.textPrimary)

                Text("Get access to Muscle-Up, Handstand, and Planche skill trees")
                    .font(Typo.body)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 8) {
                    premiumFeature("Muscle-Up progression")
                    premiumFeature("Handstand progression")
                    premiumFeature("Planche progression")
                    premiumFeature("All future premium skills")
                }

                Spacer()

                VStack(spacing: 12) {
                    if let product = storeService.products.first {
                        Button {
                            isPurchasing = true
                            Task {
                                _ = await storeService.purchase()
                                isPurchasing = false
                                if storeService.isPremium { dismiss() }
                            }
                        } label: {
                            if isPurchasing {
                                SwiftUI.ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            } else {
                                Text("Upgrade — \(product.displayPrice)")
                                    .font(Typo.heading)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                        }
                        .background(theme.masteredColor, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.black)
                        .disabled(isPurchasing)
                    }

                    Button("Restore Purchases") {
                        Task {
                            await storeService.restorePurchases()
                            if storeService.isPremium { dismiss() }
                        }
                    }
                    .font(Typo.body)
                    .foregroundStyle(theme.textSecondary)
                }
                .padding(.horizontal, 16)
            }
            .padding(24)
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func premiumFeature(_ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(theme.masteredColor)
            Text(text)
                .font(Typo.body)
                .foregroundStyle(theme.textPrimary)
            Spacer()
        }
    }
}
