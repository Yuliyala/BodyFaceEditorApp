import UIKit

class TabBarCoordinator: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Main", image: nil, tag: 0)
        
        setViewControllers([mainVC], animated: false)
    }
}

