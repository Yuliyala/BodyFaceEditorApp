//
//  AppCoordinator.swift
//  Body Face Editor App
//
//  Created by Yuliya Lapenak on 10/12/25.
//

import UIKit

class AppCoordinator: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startApp()
    }

    private func startApp() {
        let splashVC = SplashViewController()
        setViewControllers([splashVC], animated: false)
    }
    
    func openOnboarding(_ onboarding: Onboarding = .first) {
        print("🎯 AppCoordinator: Открываем онбординг - \(onboarding)")
        let onboardingVC = OnboardingViewController(onboarding: onboarding)
        setViewControllers([onboardingVC], animated: true)
    }
    
    func paywallAfterOnboarding() {
        // TODO: Implement paywall after onboarding
        openApp()
    }
    
    func openApp() {
        let mainVC = MainViewController()
        setViewControllers([mainVC], animated: true)
    }
}
