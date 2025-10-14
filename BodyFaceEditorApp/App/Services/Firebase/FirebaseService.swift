import Foundation
import FirebaseRemoteConfig

class FirebaseService {
    private var remoteConfig: RemoteConfig?
    static let shared = FirebaseService()

    private init() {
        setup()
    }

    var isGreyFlowEnabled: Bool {
        remoteConfig?.configValue(forKey: Constants.remoteConfigKey).boolValue ?? false
    }
    
    var isTrialAvailable: Bool {
        remoteConfig?.configValue(forKey: "is_trial_available").boolValue ?? true
    }

    func setup() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }
    
    func load() async {
        do {
            let status = try await remoteConfig?.fetch()
            try await remoteConfig?.activate()
        } catch {
            print("Firebase Remote Config error: \(error)")
        }
    }
}