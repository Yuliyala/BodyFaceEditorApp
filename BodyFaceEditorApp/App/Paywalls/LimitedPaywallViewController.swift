import UIKit

class LimitedPaywallViewController: GenericViewController<LimitedPaywallView> {
    private let product = AppHudService.shared.limitedProduct
    private let firebaseService = FirebaseService.shared
    private let localStorage = LocalStorage.shared
    private let apphudService = AppHudService.shared
    var isLoading: Bool = false
    var timer: Timer?
    var closeCallback: (() -> Void)?
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimer()
        setupProduct()
        actionsSetup()
    }
    
    private func setupProduct() {
        let weekProduct = AppHudService.shared.allProductWeek
        let displayPrice = weekProduct?.price()
        let discountDisplayPrice = product?.price()
        
        let price = weekProduct?.priceDecimal() ?? 0
        let discountPrice = product?.priceDecimal() ?? 0
        let discountPercentage = (price - discountPrice) / price * 100
        let strDiscount = String(NSDecimalNumber(decimal: discountPercentage).int32Value)
        
        let trialDuration = product?.trialDuration()
        let subscriptionDuration = product?.duration()
        let hasTrial = AppHudService.shared.hasLimitedTrial
        
        rootView.configure(
            discount: strDiscount,
            price: displayPrice ?? "",
            discountPrice: discountDisplayPrice ?? "",
            expires: "",
            IsBackgroundSystemGrey: firebaseService.isGreyFlowEnabled,
            hasTrial: hasTrial,
            trialDuration: trialDuration?.pluralizedTitle ?? "",
            subscriptionDuration: subscriptionDuration?.pluralizedTitle ?? ""
        )
    }
    
    private func actionsSetup() {
        rootView.onClose = { [weak self] in
            self?.coordinator?.dismissPaywall()
        }
        
        rootView.onRestore = { [weak self] in
            self?.handleRestore()
        }
        
        rootView.onContinue = { [weak self] in
            self?.handleContinue()
        }
    }
    
    private func handleContinue() {
        guard !isLoading else { return }
        isLoading = true
        
        Task { @MainActor in
            let result = await apphudService.makePurchase(product: product)
            isLoading = false
            
            if result {
                coordinator?.dismissPaywall()
            } else {
                showErrorAlert(message: "Purchase failed. Please try again.")
            }
        }
    }
    
    private func handleRestore() {
        Task { @MainActor in
            if let error = await apphudService.restoreSubs() {
                showErrorAlert(message: error.localizedDescription)
            } else {
                coordinator?.dismissPaywall()
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        apphudService.markLimitedAsShow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
        apphudService.markLimitedAsClosed()
    }
    
    @MainActor
    deinit {
        stopTimer()
    }
}

extension LimitedPaywallViewController {
    
    var timerDuration: TimeInterval {
        return 24 * 60 * 60
    }
    
    // MARK: - Timer Management
    
    func setupTimer() {
        let storage = LocalStorage.shared
        
        if let startDate = storage.timer24HourStartDate {
            let elapsed = Date().timeIntervalSince(startDate)
            
            if elapsed >= timerDuration {
                storage.clearTimerLimitedStartDate()
                startNewTimer()
            } else {
                startTimerUpdates()
            }
        } else {
            startNewTimer()
        }
        updateTimerLabel()
    }
    
    func startNewTimer() {
        let now = Date()
        LocalStorage.shared.setLimitedTimerStartDate(now)
        startTimerUpdates()
    }
    
    func startTimerUpdates() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimerLabel()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimerLabel() {
        let timerString = getCurrentTimerString()
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateTimerLabel(timerString)
        }
    }
    
    func getCurrentTimerString() -> String {
        guard let startDate = LocalStorage.shared.timer24HourStartDate else {
            return "00h : 00m : 00s"
        }
        
        let elapsed = Date().timeIntervalSince(startDate)
        let remaining = max(0, timerDuration - elapsed)
        
        if remaining <= 0 {
            LocalStorage.shared.clearTimerLimitedStartDate()
            return "00h : 00m : 00s"
        }
        
        return formatTimeInterval(remaining)
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02dh : %02dm : %02ds", hours, minutes, seconds)
    }
}
