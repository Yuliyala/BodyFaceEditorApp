import UIKit
import SnapKit

class OnboardingProgressView: UIView {
    let count: Int
    
    private var dots: [UIView] = []
    private let dotsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        backgroundColor = .clear
        dots = (0..<count).map { _ in
            let view = UIView()
            view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            view.layer.cornerRadius = 3 // border-radius: 20px для height: 6
            return view
        }
        
        addSubview(dotsStackView)
        dots.forEach(dotsStackView.addArrangedSubview(_:))
        dotsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        // Устанавливаем начальные размеры для всех точек
        updateDotConstraints(selectedIndex: 0)
    }

    func setSelected(_ selected: Int) {
        updateDotConstraints(selectedIndex: selected)
    }
    
    private func updateDotConstraints(selectedIndex: Int) {
        dots.enumerated().forEach { index, dot in
            // Удаляем предыдущие constraints
            dot.snp.removeConstraints()
            
            if index == selectedIndex {
                // Активная точка: width: 36, height: 6, градиент
                dot.snp.makeConstraints {
                    $0.width.equalTo(36)
                    $0.height.equalTo(6)
                }
                
                // Применяем градиент
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [
                    UIColor(red: 0.235, green: 0.282, blue: 0.914, alpha: 1.0).cgColor, // #3C48E9
                    UIColor(red: 0.243, green: 0.847, blue: 0.635, alpha: 1.0).cgColor  // #3ED8A2
                ]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                gradientLayer.cornerRadius = 3
                
                // Удаляем предыдущий градиент если есть
                dot.layer.sublayers?.removeAll { $0 is CAGradientLayer }
                dot.layer.insertSublayer(gradientLayer, at: 0)
                
                // Обновляем frame градиента
                DispatchQueue.main.async {
                    gradientLayer.frame = dot.bounds
                }
                
            } else {
                // Неактивные точки: width: 14, height: 6, полупрозрачные
                dot.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                dot.snp.makeConstraints {
                    $0.width.equalTo(14)
                    $0.height.equalTo(6)
                }
                
                // Удаляем градиент если есть
                dot.layer.sublayers?.removeAll { $0 is CAGradientLayer }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Обновляем frame градиентов
        dots.enumerated().forEach { index, dot in
            if let gradientLayer = dot.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                gradientLayer.frame = dot.bounds
            }
        }
    }
}

