import UIKit

class AppCoordinator: UINavigationController {
    
    init() {
        super.init(rootViewController: SplashViewController())
        setNavigationBarHidden(true, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openOnboarding(_ onboarding: Onboarding = .first) {
        pushViewController(OnboardingViewController(onboarding: onboarding), animated: false)
    }

    func openApp() {
        let mainVC = MainViewController()
        mainVC.coordinator = self
        pushViewController(mainVC, animated: true)
    }
    
    func paywallAfterOnboarding() {
        pushViewController(OnboardingPaywallViewController(), animated: false)
    }

    func openAppAfterOnboarding() {
        LocalStorage.shared.markIntroAsShown()
        let mainVC = MainViewController()
        mainVC.coordinator = self
        self.viewControllers = [mainVC]
    }
    
    func showInAppPaywall() {
        let paywallVC = InAppPaywallViewController()
        paywallVC.coordinator = self
        present(paywallVC, animated: true)
    }
    
    func dismissPaywall() {
        dismiss(animated: true)
    }
    
    func showSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.coordinator = self
        present(settingsVC, animated: true)
    }
    
    func dismissSettings() {
        dismiss(animated: true)
    }
    
    func showLimitedPaywall() {
        let paywallVC = LimitedPaywallViewController()
        paywallVC.coordinator = self
        present(paywallVC, animated: true)
    }
}
