import UIKit
import SnapKit

class LimitedPaywallView: RootView {
    
    var onClose: (() -> Void)?
    var onRestore: (() -> Void)?
    var onContinue: (() -> Void)?
    
    private let closeButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let restoreButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let discountLabel = {
        let label = UILabel()
        label.text = "-38%"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Limited Offer"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let featuresStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let timerLabel = {
        let label = UILabel()
        label.text = "EXPIRES IN 23:59:59"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private let continueButton = PrimaryButton()
    
    private let legalLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "By subscribing, you agree to our Terms of Use and Privacy Policy"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(closeButton)
        addSubview(restoreButton)
        addSubview(discountLabel)
        addSubview(titleLabel)
        addSubview(featuresStackView)
        addSubview(priceLabel)
        addSubview(timerLabel)
        addSubview(continueButton)
        addSubview(legalLabel)
        
        setupFeatures()
        setupActions()
    }
    
    private func setupFeatures() {
        let features = [
            ("Transform Body & Face", "body"),
            ("Reshape Figure", "figure"),
            ("Increase Height", "height"),
            ("Modify Facial Features", "face")
        ]
        
        features.forEach { title, iconName in
            let featureView = FeatureView(title: title, iconName: iconName)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        continueButton.setTitle("Continue", for: .normal)
    }
    
    func configure(discount: String, price: String, discountPrice: String, expires: String, IsBackgroundSystemGrey: Bool, hasTrial: Bool, trialDuration: String = "", subscriptionDuration: String) {
        discountLabel.text = "-\(discount)%"
        
        if hasTrial {
            priceLabel.text = "3 Days Of Trial then \(price) \(discountPrice) per \(subscriptionDuration)"
        } else {
            priceLabel.text = "\(price) \(discountPrice) per \(subscriptionDuration)"
        }
        
        if IsBackgroundSystemGrey {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.closeButton.isHidden = false
            }
            continueButton.setTitle("Try Free", for: .normal)
        } else {
            closeButton.isHidden = false
            continueButton.setTitle("Continue", for: .normal)
        }
    }
    
    func updateTimerLabel(_ timerText: String) {
        timerLabel.text = "EXPIRES IN \(timerText)"
    }
    
    @objc private func closeTapped() {
        onClose?()
    }
    
    @objc private func restoreTapped() {
        onRestore?()
    }
    
    @objc private func continueTapped() {
        onContinue?()
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        restoreButton.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.leading.equalToSuperview().inset(16)
        }
        
        discountLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(discountLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        featuresStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(featuresStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
        legalLabel.snp.makeConstraints {
            $0.top.equalTo(continueButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
}
