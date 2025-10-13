import Foundation

final class LocalStorage {
    
    static let shared = LocalStorage()
    private init() {}
    
    private enum Keys {
        static let isOnboardingShown = "isOnboardingShown"
        static let timer24hStartDate = "timer24hStartDate"
    }
    
    private let userDefaults = UserDefaults.standard
    
    var isIntroShown: Bool {
        get {
            userDefaults.bool(forKey: Keys.isOnboardingShown)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isOnboardingShown)
        }
    }
    
    func markIntroAsShown() {
        isIntroShown = true
    }
    
    func setLimitedTimerStartDate(_ date: Date) {
        userDefaults.set(date, forKey: Keys.timer24hStartDate)
    }
    
    var timer24HourStartDate: Date? {
        get {
            userDefaults.object(forKey: Keys.timer24hStartDate) as? Date
        }
        set {
            if let date = newValue {
                userDefaults.set(date, forKey: Keys.timer24hStartDate)
            } else {
                userDefaults.removeObject(forKey: Keys.timer24hStartDate)
            }
        }
    }
    
    func clearTimerLimitedStartDate() {
        userDefaults.removeObject(forKey: Keys.timer24hStartDate)
    }
}

