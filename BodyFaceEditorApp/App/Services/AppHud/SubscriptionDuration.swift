import Foundation

enum SubscriptionDuration {
    case days(Int)
    case week
    case month
    case year
    
    var title: String {
        switch self {
        case .days(let days):
             "\(days)-" + NSLocalizedString("day", comment: "")
        case .week:
            NSLocalizedString("week", comment: "")
        case .month:
            NSLocalizedString("month", comment: "")
        case .year:
            NSLocalizedString("year", comment: "")
        }
    }
    
    var pluralizedTitle: String {
        switch self {
        case .days(let days):
            "\(days) " + NSLocalizedString("days", comment: "")
        default:
            title
        }
    }
}
