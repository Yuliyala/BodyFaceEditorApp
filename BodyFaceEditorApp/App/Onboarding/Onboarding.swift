import UIKit

enum Onboarding: CaseIterable {
    case first
    case second
    case third
    case fourth

    var bgImage: UIImage {
        switch self {
        case .first:
            return UIImage(named: "picture") ?? UIImage()
        case .second:
            return UIImage(named: "picture1") ?? UIImage()
        case .third:
            return UIImage(named: "picture2") ?? UIImage()
        case .fourth:
            return UIImage(named: "picture3") ?? UIImage()
        }
    }

    var title: String {
        switch self {
        case .first:
            return "Transform Your Body & Face"
        case .second:
            return "Modify Waist, Hips and Height"
        case .third:
            return "Reshape Your Face"
        case .fourth:
            return "We appreciate your feedback!"
        }
    }
    
    var body: String {
        switch self {
        case .first:
            return "Transform your body in seconds for a stunning new look"
        case .second:
            return "Easily adjust your waist, hips, and height with just one tap"
        case .third:
            return "Enhance facial details and shape body contours for a flawless appearance"
        case .fourth:
            return "Rate us and help others discover body and face editing features"
        }
    }
    
    var next: Onboarding? {
        switch self {
        case .first:
            return .second
        case .second:
            return .third
        case .third:
            return .fourth
        case .fourth:
            return nil
        }
    }
    
    var progressIndex: Int {
        switch self {
        case .first:
            return 0
        case .second:
            return 1
        case .third:
            return 2
        case .fourth:
            return 3
        }
    }
}

