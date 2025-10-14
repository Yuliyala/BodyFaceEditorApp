import UIKit

extension UIView {
    var isSmallScreen: Bool {
        return UIScreen.main.bounds.height < 700
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}