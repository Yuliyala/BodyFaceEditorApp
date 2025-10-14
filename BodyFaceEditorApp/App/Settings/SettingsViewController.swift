import UIKit
import ApphudSDK

class SettingsViewController: GenericViewController<SettingsView> {
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateUI()
    }
    
    private func setupActions() {
        rootView.onClose = { [weak self] in
            self?.coordinator?.dismissSettings()
        }
        
        rootView.onRestore = { [weak self] in
            self?.handleRestore()
        }
        
        rootView.onTerms = { [weak self] in
            self?.openTerms()
        }
        
        rootView.onPrivacy = { [weak self] in
            self?.openPrivacy()
        }
    }
    
    private func updateUI() {
        let hasSubscription = AppHudService.shared.hasActiveSubscription
        rootView.updateSubscriptionStatus(hasSubscription)
    }
    
    private func handleRestore() {
        Apphud.restorePurchases { subscriptions, nonRenewingPurchases, error in
            DispatchQueue.main.async {
                if let subscriptions = subscriptions, !subscriptions.isEmpty {
                    self.updateUI()
                    self.showSuccessAlert(message: "Purchases restored successfully!")
                } else {
                    self.showErrorAlert(message: "No purchases found to restore")
                }
            }
        }
    }
    
    private func openTerms() {
        BrowserPresenter.presentInAppBrowser(with: Constants.termsOfUseURL)
    }
    
    private func openPrivacy() {
        BrowserPresenter.presentInAppBrowser(with: Constants.privacyPolicyURL)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}