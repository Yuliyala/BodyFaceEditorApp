import UIKit

class PrimaryButton: UIButton {
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private var currrentBackgroundColor: UIColor?
    
    override var backgroundColor: UIColor? {
        didSet {
            guard isEnabled else { return }
            currrentBackgroundColor = backgroundColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? currrentBackgroundColor : .systemGray4
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
   required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        setTitleColor(.systemGray, for: .disabled)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        impactFeedback.prepare()
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        impactFeedback.impactOccurred()
    }
}