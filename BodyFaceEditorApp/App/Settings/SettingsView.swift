import UIKit
import SnapKit

class SettingsView: RootView {
    
    var onClose: (() -> Void)?
    var onRestore: (() -> Void)?
    var onTerms: (() -> Void)?
    var onPrivacy: (() -> Void)?
    
    private let closeButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subscriptionStatusView = {
        let view = SubscriptionStatusView()
        return view
    }()
    
    private let restoreButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let legalStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private let termsButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms of Use", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let privacyButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let versionLabel = {
        let label = UILabel()
        label.text = "Version 1.0.0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .center
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
        addSubview(titleLabel)
        addSubview(subscriptionStatusView)
        addSubview(restoreButton)
        addSubview(legalStackView)
        addSubview(versionLabel)
        
        legalStackView.addArrangedSubview(termsButton)
        legalStackView.addArrangedSubview(privacyButton)
        
        setupActions()
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
    }
    
    func updateSubscriptionStatus(_ hasSubscription: Bool) {
        subscriptionStatusView.updateStatus(hasSubscription)
        restoreButton.isHidden = hasSubscription
    }
    
    @objc private func closeTapped() {
        onClose?()
    }
    
    @objc private func restoreTapped() {
        onRestore?()
    }
    
    @objc private func termsTapped() {
        onTerms?()
    }
    
    @objc private func privacyTapped() {
        onPrivacy?()
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        subscriptionStatusView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(60)
        }
        
        restoreButton.snp.makeConstraints {
            $0.top.equalTo(subscriptionStatusView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
        legalStackView.snp.makeConstraints {
            $0.top.equalTo(restoreButton.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(legalStackView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

class SubscriptionStatusView: UIView {
    private let statusLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        addSubview(statusLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func updateStatus(_ hasSubscription: Bool) {
        if hasSubscription {
            statusLabel.text = "Premium Active"
            descriptionLabel.text = "You have access to all features"
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            statusLabel.text = "Free Version"
            descriptionLabel.text = "Upgrade to unlock all features"
            backgroundColor = UIColor.white.withAlphaComponent(0.1)
            layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
    }
}
