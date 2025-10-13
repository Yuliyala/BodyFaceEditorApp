import UIKit

class BrowserPresenter {
    static func presentInAppBrowser(with url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func presentInAppBrowser(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        presentInAppBrowser(with: url)
    }
}

