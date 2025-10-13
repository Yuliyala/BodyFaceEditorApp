import UIKit

protocol RootView: UIView {}

class GenericViewController<T: RootView>: UIViewController {
    var rootView: T { view as! T }
    
    override func loadView() {
        self.view = T()
    }
}