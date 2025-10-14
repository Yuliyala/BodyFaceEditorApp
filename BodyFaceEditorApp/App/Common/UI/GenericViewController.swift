import UIKit
import SnapKit

class RootView: UIView {
    let backgroundImage = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = .bg
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBg()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBg()
    }
    
    private func setupBg() {
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class GenericViewController<T: RootView>: UIViewController {
    var rootView: T { view as! T }
    
    override func loadView() {
        self.view = T()
    }
}
