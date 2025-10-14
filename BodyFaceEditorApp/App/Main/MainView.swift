import UIKit
import SnapKit

class MainView: RootView {
    
    var onPremiumTapped: (() -> Void)?
    var onSettingsTapped: (() -> Void)?
    
    private let settingsButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Body & Face Editor"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let premiumBanner = {
        let view = PremiumBannerView()
        return view
    }()
    
    private let featuresStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private let startButton = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(settingsButton)
        addSubview(titleLabel)
        addSubview(premiumBanner)
        addSubview(featuresStackView)
        addSubview(startButton)
        
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
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        premiumBanner.onTap = { [weak self] in
            self?.onPremiumTapped?()
        }
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        startButton.setTitle("Start Editing", for: .normal)
    }
    
    @objc private func settingsTapped() {
        onSettingsTapped?()
    }
    
    @objc private func startTapped() {
        // Здесь будет логика открытия редактора
        // Пока что показываем премиум баннер
        onPremiumTapped?()
    }
    
    private func setupConstraints() {
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(settingsButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        premiumBanner.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        
        featuresStackView.snp.makeConstraints {
            $0.top.equalTo(premiumBanner.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(featuresStackView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

class PremiumBannerView: UIView {
    var onTap: (() -> Void)?
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Unlock Premium Features"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.text = "Get access to all editing tools"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()
    
    private let arrowImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
    }
    
    @objc private func bannerTapped() {
        onTap?()
    }
}
