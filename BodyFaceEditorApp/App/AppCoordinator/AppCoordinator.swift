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
        pushViewController(TabBarCoordinator(), animated: true)
    }
    
    func paywallAfterOnboarding() {
        pushViewController(OnboardingPaywallViewController(), animated: false)
    }

    func openAppAfterOnboarding() {
        LocalStorage.shared.markIntroAsShown()
        self.viewControllers = [TabBarCoordinator()]
    }
}
