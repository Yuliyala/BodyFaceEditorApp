import UIKit
import FirebaseCoreInternal
import ApphudSDK
import StoreKit

public final class AppHudService {

    public static let shared = AppHudService()

    private init() {}

    public private(set) lazy var hasSubscribed: Bool = Apphud.hasPremiumAccess() || Apphud.hasActiveSubscription()
    
    public var hasTrial: Bool = false
    public var hasLimitedTrial = false
    
    private var placements: [ApphudPlacement] = []
    
    private var limitedPlacement: ApphudPlacement? {
        placements.first { $0.identifier == Constants.Placements.limitedPlacement }
    }

    private var startPlacement: ApphudPlacement? {
        placements.first { $0.identifier == Constants.Placements.startPlacement }
    }

    private var allPlacement: ApphudPlacement? {
        placements.first { $0.identifier == Constants.Placements.allPlacement }
    }
    
    public var limitedProduct: ApphudProduct? {
        limitedPlacement?.paywall?.products.first(where: { $0.productId == Constants.Products.weeklySale })
    }

    public var startProduct: ApphudProduct? {
        startPlacement?.paywall?.products.first { $0.productId == Constants.Products.weeklySubscription }
    }
    
    public var allProductWeek: ApphudProduct? {
        allPlacement?.paywall?.products.first { $0.productId == Constants.Products.weeklySubscription }
    }
    
    public var allProductMonth: ApphudProduct? {
        allPlacement?.paywall?.products.first { $0.productId == Constants.Products.monthlySubscription }
    }

    private var productsMap: [ApphudProduct: Product] = [:]
    
    public func storeProduct(for product: ApphudProduct?) -> Product? {
        guard let product else { return nil }
        return productsMap[product]
    }
    
    public func markLimitedAsShow() {
        guard let paywall =  limitedPlacement?.paywall else { return }
        Apphud.paywallShown(paywall)
    }
    
    public func markInAppAsShow() {
        guard let paywall = allPlacement?.paywall else { return }
        Apphud.paywallShown(paywall)
    }
    
    public func markOnbAsShow() {
        guard let paywall = startPlacement?.paywall else { return }
        Apphud.paywallShown(paywall)
    }
    
    public func markLimitedAsClosed() {
        guard let paywall =  limitedPlacement?.paywall else { return }
        Apphud.paywallClosed(paywall)
    }
    
    public func markInAppAsClosed() {
        guard let paywall = allPlacement?.paywall else { return }
        Apphud.paywallClosed(paywall)
    }
    
    public func markOnbAsClosed() {
        guard let paywall = startPlacement?.paywall else { return }
        Apphud.paywallClosed(paywall)
    }
    
    public func preloadData() async {
        self.placements = await Apphud.placements().filter {
            Constants.allPlacementIDs.contains($0.identifier)
        }
        
        self.productsMap = await withTaskGroup(of: (ApphudProduct, Product)?.self, returning: [ApphudProduct: Product].self) { taskGroup in
            let apphudProducts = [limitedProduct, startProduct, allProductWeek, allProductMonth].compactMap { $0 }
            for apphudProduct in apphudProducts {
                taskGroup.addTask {
                    if let product = try? await apphudProduct.product() {
                        return (apphudProduct, product)
                    }
                    return nil
                }
            }

            var productsMap = [ApphudProduct: Product]()
            for await result in taskGroup {
                if let (apphudProduct, product) = result {
                    productsMap[apphudProduct] = product
                    print(product.displayPrice)
                }
            }
            return productsMap
        }
        hasSubscribed = false// await hasCurrentSubscription()
        if let weekProduct = allProductWeek?.skProduct, let limitedProduct = limitedProduct?.skProduct {
            Apphud.checkEligibilityForIntroductoryOffer(product: weekProduct) { isEligible in
                self.hasTrial = isEligible
            }
            Apphud.checkEligibilityForIntroductoryOffer(product: limitedProduct, callback: { isEligible in
                self.hasLimitedTrial = isEligible
            })
        }
    }
    
    public func makePurchase(product: ApphudProduct?) async -> Bool {
        guard let product = product else { return false }
        
        let result = await Apphud.purchase(product)
        if result.success {
            hasSubscribed = true
        }
        return result.success
    }

    public func restoreSubs() async -> Error? {
        let error = await Apphud.restorePurchases()
        if error == nil && (Apphud.hasActiveSubscription() || Apphud.hasPremiumAccess()) {
            hasSubscribed = true
        } else if error == nil {
            hasSubscribed = false
            return RestoreError.notFound
        }
        return error
    }
    
    private func hasCurrentSubscription() async -> Bool {
        let apphudSubscriptions = await Apphud.subscriptions()
        let apphudNonSubscriptions = await Apphud.nonRenewingPurchases()
        
        let hasActiveSubsciption: Bool = apphudSubscriptions?.first(where: { $0.isActive() }) != nil
        let hasActiveNonSubscription: Bool = apphudNonSubscriptions?.first(where: { $0.isActive() }) != nil
        
        return Apphud.hasActiveSubscription() || Apphud.hasPremiumAccess() || hasActiveSubsciption || hasActiveNonSubscription
    }
}

enum RestoreError: Error {
    case notFound
    
    var localizedDescription: String {
        switch self {
        case .notFound:
            "No purchases found to restore"
        }
    }
}
