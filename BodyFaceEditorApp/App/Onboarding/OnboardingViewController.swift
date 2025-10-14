import UIKit
import StoreKit

class OnboardingViewController: GenericViewController<OnboardingView> {
    let onboarding: Onboarding
    
    var coordinator: AppCoordinator? {
        navigationController as? AppCoordinator
    }

    init(onboarding: Onboarding) {
        self.onboarding = onboarding
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("📱 OnboardingViewController: Загружен экран - \(onboarding)")
        
        rootView.set(
            title: onboarding.title,
            body: onboarding.body,
            image: onboarding.bgImage,
            buttonTitle: NSLocalizedString("continue.button", comment: "Continue button text"),
            progressIndex: onboarding.progressIndex,
            isPaywall: false
        )
        rootView.continueButton.addAction(UIAction(handler: { [weak self] _ in
            self?.continueTapped()
        }), for: .touchUpInside)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if onboarding == .fourth, let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func continueTapped() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        if let next = self.onboarding.next {
            self.coordinator?.openOnboarding(next)
        } else {
            self.coordinator?.paywallAfterOnboarding()
        }
    }
}