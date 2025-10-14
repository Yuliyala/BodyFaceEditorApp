import UIKit
import SnapKit
import ApphudSDK

class OnboardingPaywallViewController: GenericViewController<OnboardingPaywallView> {
    
    private var coordinator: AppCoordinator? {
        navigationController as? AppCoordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        rootView.set(
            title: "Unlock Full Access",
            description: "Subscribe for unlimited access to Transform Your Body and Face for $7.99 per week after a 3-day trial.",
            buttonTitle: "Continue",
            progressIndex: 4
        )
    }
    
    private func setupActions() {
        rootView.continueButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleContinue()
        }), for: .touchUpInside)
        
        rootView.restoreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleRestore()
        }), for: .touchUpInside)
        
        rootView.closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleClose()
        }), for: .touchUpInside)
    }
    
    private func handleContinue() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Purchase weekly subscription
        Apphud.purchase(Constants.Products.weeklySubscription) { result in
            DispatchQueue.main.async {
                if result.success {
                    self.coordinator?.openAppAfterOnboarding()
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
                    self.coordinator?.openAppAfterOnboarding()
                } else {
                    self.showErrorAlert(message: "No purchases found to restore")
                }
            }
        }
    }
    
    private func handleClose() {
        if FirebaseService.shared.isGreyFlowEnabled {
            let limited = LimitedPaywallViewController()
            limited.closeCallback = { [weak self] in
                self?.dismiss(animated: true)
                self?.coordinator?.openAppAfterOnboarding()
            }
            limited.modalPresentationStyle = .fullScreen
            present(limited, animated: true)
        } else {
            coordinator?.openAppAfterOnboarding()
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
