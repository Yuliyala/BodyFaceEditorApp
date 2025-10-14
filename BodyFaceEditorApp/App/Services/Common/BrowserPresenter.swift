import UIKit

class BrowserPresenter {
    static func presentInAppBrowser(with url: URL) {
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() else {
            return
        }
        
        let webViewController = WebViewController(url: url)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        topViewController.present(navigationController, animated: true)
    }
    
    static func presentInAppBrowser(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        presentInAppBrowser(with: url)
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        
        return self
    }
}

