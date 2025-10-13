import UIKit

extension UIView {
    static func horizontalSpacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }

    static func verticalSpacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        return spacer
    }
    
    var isSmallScreen: Bool {
        return UIScreen.main.bounds.height < 700
    }
}