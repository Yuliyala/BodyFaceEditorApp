import UIKit
import SnapKit

class InAppPaywallView: RootView {
    
    var onContinue: ((SubscriptionPlan) -> Void)?
    var onRestore: (() -> Void)?
    var onClose: (() -> Void)?
    
    private var selectedPlan: SubscriptionPlan = .weekly
    
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
    
    private let tapeImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tape") // Нужно добавить картинку измерительной ленты
        return imageView
    }()
    
    private let featuresStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Unlock Full Access"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subscriptionStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    private let weeklyPlanView = SubscriptionPlanView(plan: .weekly)
    private let monthlyPlanView = SubscriptionPlanView(plan: .monthly)
    
    private let infoLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
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
        addSubview(tapeImageView)
        addSubview(featuresStackView)
        addSubview(titleLabel)
        addSubview(subscriptionStackView)
        addSubview(infoLabel)
        addSubview(continueButton)
        addSubview(legalLabel)
        
        setupFeatures()
        setupSubscriptions()
        setupActions()
        updateUI()
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
    
    private func setupSubscriptions() {
        subscriptionStackView.addArrangedSubview(weeklyPlanView)
        subscriptionStackView.addArrangedSubview(monthlyPlanView)
        
        weeklyPlanView.onTap = { [weak self] in
            self?.selectPlan(.weekly)
        }
        
        monthlyPlanView.onTap = { [weak self] in
            self?.selectPlan(.monthly)
        }
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    private func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlan = plan
        weeklyPlanView.isSelected = (plan == .weekly)
        monthlyPlanView.isSelected = (plan == .monthly)
        updateUI()
    }
    
    private func updateUI() {
        let hasTrial = FirebaseService.shared.isTrialAvailable
        
        if selectedPlan == .weekly {
            if hasTrial {
                continueButton.setTitle("Start 3-Day Trial, then $7.99/week", for: .normal)
                infoLabel.text = "No Payment Required"
            } else {
                continueButton.setTitle("Continue", for: .normal)
                infoLabel.text = "Cancel Anytime"
            }
        } else {
            continueButton.setTitle("Subscribe for $19.99", for: .normal)
            infoLabel.text = "Cancel Anytime"
        }
    }
    
    @objc private func closeTapped() {
        onClose?()
    }
    
    @objc private func restoreTapped() {
        onRestore?()
    }
    
    @objc private func continueTapped() {
        onContinue?(selectedPlan)
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
        
        tapeImageView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(120)
        }
        
        featuresStackView.snp.makeConstraints {
            $0.top.equalTo(tapeImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(featuresStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        subscriptionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(subscriptionStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
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

class SubscriptionPlanView: UIView {
    let plan: SubscriptionPlan
    var onTap: (() -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            updateSelection()
        }
    }
    
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let badgeLabel = UILabel()
    private let radioButton = UIView()
    private let radioDot = UIView()
    
    init(plan: SubscriptionPlan) {
        self.plan = plan
        super.init(frame: .zero)
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
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = UIColor.systemBlue
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.textAlignment = .center
        
        radioButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        radioButton.layer.cornerRadius = 10
        
        radioDot.backgroundColor = .white
        radioDot.layer.cornerRadius = 4
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(badgeLabel)
        addSubview(radioButton)
        radioButton.addSubview(radioDot)
        
        if plan == .weekly {
            titleLabel.text = "Week"
            priceLabel.text = "then $7,99 ($7,99 / week)"
            badgeLabel.text = "3-Day Trial"
        } else {
            titleLabel.text = "Month"
            priceLabel.text = "$19,99 ($4,99 / week)"
            badgeLabel.text = "Best Price"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(planTapped))
        addGestureRecognizer(tapGesture)
        
        updateSelection()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(radioButton.snp.leading).offset(-12)
            $0.width.equalTo(80)
            $0.height.equalTo(24)
        }
        
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        radioDot.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(8)
        }
    }
    
    private func updateSelection() {
        if isSelected {
            layer.borderColor = UIColor.systemBlue.cgColor
            radioDot.isHidden = false
        } else {
            layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            radioDot.isHidden = true
        }
    }
    
    @objc private func planTapped() {
        onTap?()
    }
}

class FeatureView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    init(title: String, iconName: String) {
        super.init(frame: .zero)
        setupUI(title: title, iconName: iconName)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String, iconName: String) {
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .systemGreen
        checkmarkImageView.contentMode = .scaleAspectFit
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(checkmarkImageView)
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(24)
        }
    }
}
