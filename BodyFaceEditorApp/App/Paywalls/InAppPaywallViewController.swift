import UIKit
import ApphudSDK

class InAppPaywallViewController: GenericViewController<InAppPaywallView> {
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        rootView.onContinue = { [weak self] selectedPlan in
            self?.handleContinue(selectedPlan: selectedPlan)
        }
        
        rootView.onRestore = { [weak self] in
            self?.handleRestore()
        }
        
        rootView.onClose = { [weak self] in
            self?.coordinator?.dismissPaywall()
        }
    }
    
    private func handleContinue(selectedPlan: SubscriptionPlan) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        let productId = selectedPlan == .weekly ? 
            Constants.Products.weeklySubscription : 
            Constants.Products.monthlySubscription
        
        Apphud.purchase(productId) { result in
            DispatchQueue.main.async {
                if result.success {
                    self.coordinator?.dismissPaywall()
                } else {
                    self.showErrorAlert(message: "Purchase failed. Please try again.")
                }
            }
        }
    }
    
    private func handleRestore() {
        Apphud.restorePurchases { subscriptions, nonRenewingPurchases, error in
            DispatchQueue.main.async {
                if let subscriptions = subscriptions, !subscriptions.isEmpty {
                    self.coordinator?.dismissPaywall()
                } else {
                    self.showErrorAlert(message: "No purchases found to restore")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

enum SubscriptionPlan {
    case weekly
    case monthly
}
