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
            view.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
            view.layer.cornerRadius = 1.5
            return view
        }
        
        addSubview(dotsStackView)
        dots.forEach(dotsStackView.addArrangedSubview(_:))
        dotsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        // Устанавливаем начальные размеры для всех точек (самый маленький размер)
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
                // Выбранная точка: 14 width, полная непрозрачность
                dot.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                dot.snp.makeConstraints {
                    $0.width.equalTo(14)
                    $0.height.equalTo(3)
                }
            } else if abs(index - selectedIndex) == 1 {
                // Соседние точки: 6 width, 0.3 alpha
                dot.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
                dot.snp.makeConstraints {
                    $0.width.equalTo(6)
                    $0.height.equalTo(3)
                }
            } else {
                // Остальные точки: 3 width, 0.3 alpha
                dot.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
                dot.snp.makeConstraints {
                    $0.width.equalTo(3)
                    $0.height.equalTo(3)
                }
            }
        }
    }
}

