import ApphudSDK
import StoreKit

extension ApphudProduct {
    
    func price() -> String {
        AppHudService.shared.storeProduct(for: self)?.displayPrice ?? "7.99$"
    }
    
    func priceDecimal() -> Decimal? {
        AppHudService.shared.storeProduct(for: self)?.price
    }
    
    func duration() -> SubscriptionDuration? {
        guard let skProduct = self.skProduct else { return nil }
        
        let durationInSeconds = subscriptionDuration(product: skProduct)
        let durationInDays = Int(durationInSeconds / (24 * 60 * 60))
        
        switch durationInDays {
        case 7:
            return .week
        case 28...31:
            return .month
        default:
            return .days(durationInDays)
        }
    }
    
    func trialDuration() -> SubscriptionDuration? {
        guard let skProductDuration = self.skProduct?.introductoryPrice?.subscriptionPeriod else {
            return nil
        }
        let durationInSeconds = subscriptionToTimeInterval(skProductDuration)
        let durationInDays = Int(durationInSeconds / (24 * 60 * 60))

        switch durationInDays {
        case 7:
            return .week
        case 28...31:
            return .month
        default:
            return .days(durationInDays)
        }
    }
    
    private func subscriptionDuration(product: SKProduct) -> TimeInterval {
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            return 0
        }
        
        return subscriptionToTimeInterval(subscriptionPeriod)
    }
    
    private func subscriptionToTimeInterval(_ subscriptionPeriod: SKProductSubscriptionPeriod) -> TimeInterval {
        let currentDate = Date()
        let numberOfUnits = subscriptionPeriod.numberOfUnits
        let unit = subscriptionPeriod.unit
        
        var calendarComponent: Calendar.Component? = nil
        
        switch unit {
        case .day:
            calendarComponent = .day
        case .month:
            calendarComponent = .month
        case .week:
            calendarComponent = .weekOfYear
        case .year:
            calendarComponent = .year
        default:
            break
        }
        
        guard let component = calendarComponent else {
            return 0
        }
        
        let calendar = Calendar(identifier: .iso8601)
        
        guard let newDate = calendar.date(byAdding: component, value: numberOfUnits, to: currentDate) else {
            return 0
        }
        
        return newDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
    }
}
