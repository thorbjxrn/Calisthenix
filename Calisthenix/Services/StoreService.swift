import StoreKit

@Observable
@MainActor
final class StoreService {
    static let shared = StoreService()
    private(set) var isPremium: Bool = false
    private(set) var products: [Product] = []
    private var updateTask: Task<Void, Never>?

    static let premiumProductID = "thorbjxrn.Calisthenix.premium"

    private init() {
        updateTask = Task { [weak self] in
            guard let self else { return }
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self.refreshPurchaseStatus()
                }
            }
        }
        Task {
            await loadProducts()
            await refreshPurchaseStatus()
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.premiumProductID])
        } catch {
            products = []
        }
    }

    func purchase() async -> Bool {
        guard let product = products.first else { return false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshPurchaseStatus()
                    return true
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Purchase failed
        }
        return false
    }

    func restorePurchases() async {
        try? await AppStore.sync()
        await refreshPurchaseStatus()
    }

    private func refreshPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.premiumProductID {
                isPremium = true
                return
            }
        }
        isPremium = false
    }
}
