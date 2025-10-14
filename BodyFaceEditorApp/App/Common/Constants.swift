import Foundation

struct Constants {
    // MARK: - App Info
    static let bundleID = "test.app.fake.bundle"
    static let appName = "BodyFaceEditor"
    
    // MARK: - AppHud
    static let apphudKey = "app_vEXDHY1EFnSZaCom4SvxUs7nadWLPD"
    
    // MARK: - Apple ID
    static let appleID = "987654321"
    
    // MARK: - Firebase
    static let remoteConfigKey = "isGreyFlow"
    
    // MARK: - URLs
    static let termsOfUseURL = URL(string: "https://docs.google.com/document/d/1oDmRrxXeJhtUs4imazuoevKuTWMT70vNoAZYVVtUZMA/edit?usp=sharing")!
    static let privacyPolicyURL = URL(string: "https://docs.google.com/document/d/1N2N5mUQ3SbsTr-6CF-E-P4DiFAuVKdydgCB5Dr6YYyI/edit?usp=sharing")!
    static let supportURL = URL(string: "https://docs.google.com/document/d/15OPv9IDkhJLrR8zIFw2msXpiXhXUmQhGXrUIdxVxaN0/edit?usp=sharing")!
//    static let email = "aboba@gmail.com"
    
    // MARK: - Products
    struct Products {
        static let weeklySubscription = "bodyfaceeditorapp_wk_799"
        static let monthlySubscription = "bodyfaceeditorapp_mo_1999"
        static let weeklySale = "bodyfaceeditorapp_wk_599"
    }
    
    // MARK: - Placements
    struct Placements {
        static let startPlacement = "bodyfaceeditorapp_onboarding"
        static let allPlacement = "bodyfaceeditorapp_allplaces"
        static let limitedPlacement = "bodyfaceeditorapp_settingslimited"
    }
    
    // MARK: - Paywalls
    struct Paywalls {
        static let oneSub = "bodyfaceeditorapp_one_sub_1"
        static let twoSub = "bodyfaceeditorapp_two_sub_2"
        static let sale = "bodyfaceeditorapp_one_sub_sale"
    }
    
    // MARK: - Feature Flags
    struct FeatureFlags {
        static let isCodesValidationEnabled = "isCodesValidationEnabled"
        static let isLongMeasurementEnabled = "isLongMeasurementEnabled"
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let isPremiumUser = "isPremiumUser"
        static let limitedPaywallTimer = "limitedPaywallTimer"
        static let lastLimitedPaywallShown = "lastLimitedPaywallShown"
    }
    
    // MARK: - Animation Durations
    struct AnimationDurations {
        static let short = 0.3
        static let medium = 0.5
        static let long = 1.0
    }
    
    // MARK: - Colors
    struct Colors {
        static let primaryBlue = "#007AFF"
        static let secondaryBlue = "#0056CC"
        static let accentGreen = "#34C759"
        static let warningRed = "#FF3B30"
        static let backgroundGray = "#F2F2F7"
        static let textPrimary = "#000000"
        static let textSecondary = "#8E8E93"
    }
    
    static var allPlacementIDs: Set<String> {
        return [Placements.startPlacement, Placements.allPlacement, Placements.limitedPlacement]
    }
}
