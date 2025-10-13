import UIKit

class OnboardingView: UIView, RootView {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        backgroundColor = .black
        
        [
            imageView, contentStackView, progressBar, continueButton
        ].forEach(addSubview(_:))
        [titleLabel, descriptionLabel].forEach(contentStackView.addArrangedSubview(_:))
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Основное изображение - занимает весь экран
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Темный оверлей для контента
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Контент внизу экрана
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -24)
        ])
        
        // Прогресс бар
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24)
        ])
        
        // Кнопка Continue
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    func set(
        title: String,
        body: String,
        image: UIImage,
        buttonTitle: String,
        progressIndex: Int
    ) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = body
        continueButton.setTitle(buttonTitle, for: .normal)
        progressBar.setSelected(progressIndex)
    }
}

// MARK: - Progress View
class OnboardingProgressView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private var dots: [UIView] = []
    private let count: Int
    
    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(stackView)
        
        for i in 0..<count {
            let dot = UIView()
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
            dots.append(dot)
            stackView.addArrangedSubview(dot)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setSelected(_ index: Int) {
        for (i, dot) in dots.enumerated() {
            if i <= index {
                dot.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) // Синий цвет как в макете
            } else {
                dot.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            }
        }
    }
}
