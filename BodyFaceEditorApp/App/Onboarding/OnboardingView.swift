import UIKit
import SnapKit

class OnboardingView: RootView {
    
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 8
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
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
        label.font = UIFont(name: "Inter-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let continueButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Continue", for: .normal)
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
            imageView, contentStackView, progressBar, continueButton
        ].forEach(addSubview(_:))
        [titleLabel, descriptionLabel].forEach(contentStackView.addArrangedSubview(_:))
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            if isSmallScreen || isIpad {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            }
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.isUserInteractionEnabled = false
        insertSubview(overlayView, aboveSubview: imageView)
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).offset(-12)
        }
        
        continueButton.snp.makeConstraints {
            $0.height.equalTo(isSmallScreen ? 44 : 56)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func set(
        title: String,
        body: String,
        image: UIImage,
        buttonTitle: String,
        progressIndex: Int,
        isPaywall: Bool,
        isBugs: Bool = false
    ) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = body
        continueButton.setTitle(buttonTitle, for: .normal)
        progressBar.setSelected(progressIndex)
        
        if isPaywall {
            descriptionLabel.font = isBugs ? UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular) : UIFont(name: "Inter-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        }
    }
}
