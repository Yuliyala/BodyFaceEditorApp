import UIKit

class MainViewController: GenericViewController<MainView> {
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        rootView.onPremiumTapped = { [weak self] in
            self?.coordinator?.showInAppPaywall()
        }
        
        rootView.onSettingsTapped = { [weak self] in
            self?.coordinator?.showSettings()
        }
    }
}