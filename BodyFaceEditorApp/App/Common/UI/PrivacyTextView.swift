import UIKit

class PrivacyTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    private func setupTextView() {
        self.isEditable = false
        self.isScrollEnabled = false
        self.backgroundColor = .clear
        self.delegate = self
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = .zero
        
        // Set link text attributes to control link appearance
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attributedString = createAttributedString()
        self.attributedText = attributedString
    }

    private func createAttributedString() -> NSAttributedString {
        let fullText = "By subscribing, you agree to our\nTerms of Use and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: fullText)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.4

        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .paragraphStyle: paragraphStyle
        ]
        attributedString.addAttributes(mainAttributes, range: NSRange(location: 0, length: fullText.count))

        let termsOfUseText = "Terms of Use"
        if let termsRange = fullText.range(of: termsOfUseText) {
            let nsRange = NSRange(termsRange, in: fullText)
            let termsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Inter-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium),
                .link: "terms_of_use"
            ]
            attributedString.addAttributes(termsAttributes, range: nsRange)
        }

        let privacyPolicyText = "Privacy Policy"
        if let privacyRange = fullText.range(of: privacyPolicyText) {
            let nsRange = NSRange(privacyRange, in: fullText)
            let privacyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Inter-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium),
                .link: "privacy_policy"
            ]
            attributedString.addAttributes(privacyAttributes, range: nsRange)
        }

        return attributedString
    }
}

extension PrivacyTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "terms_of_use":
            BrowserPresenter.presentInAppBrowser(with: Constants.termsOfUseURL)
        case "privacy_policy":
            BrowserPresenter.presentInAppBrowser(with: Constants.privacyPolicyURL)
        default:
            break
        }
        return false
    }
}
