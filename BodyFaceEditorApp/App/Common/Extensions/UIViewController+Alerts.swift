import UIKit

extension UIViewController {
    func presentRestorePurchasesFailureAlert(errorDescription: String) {
        let alertController = UIAlertController(
            title: "Restore Failed",
            message: errorDescription,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func presentSubscriptionErrorAlert() {
        let alertController = UIAlertController(
            title: "Subscription Error",
            message: "Something went wrong with your subscription",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func presentRestorePurchasesSuccessBanner() {
        let alertController = UIAlertController(
            title: "Restore Successful",
            message: "Your purchases have been restored",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}

