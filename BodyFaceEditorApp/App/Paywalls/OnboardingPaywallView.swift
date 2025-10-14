import UIKit
import SnapKit

class OnboardingPaywallView: RootView {
    
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let continueButton: PrimaryButton = {
        let button = PrimaryButton()
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return button
    }()
    
    let progressBar = OnboardingProgressView(count: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        [
            imageView, titleLabel, descriptionLabel, progressBar, continueButton, restoreButton, closeButton
        ].forEach(addSubview(_:))
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            if isSmallScreen || isIpad {
                $0.top.equalToSuperview().offset(20)
            } else {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            }
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.isUserInteractionEnabled = false
        insertSubview(overlayView, aboveSubview: imageView)
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(24)
            $0.height.equalTo(isSmallScreen ? 44 : 56)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
        }
        
        restoreButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func set(
        title: String,
        description: String,
        buttonTitle: String,
        progressIndex: Int
    ) {
        imageView.image = UIImage(named: "paywall_onboarding") // Картинка будет добавлена позже
        titleLabel.text = title
        descriptionLabel.text = description
        continueButton.setTitle(buttonTitle, for: .normal)
        progressBar.setSelected(progressIndex)
    }
}
