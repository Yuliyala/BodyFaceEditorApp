import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let apphudService = AppHudService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .bgPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
    
    private func handleRestorePurchases() {
        LoaderView.show()
        Task { @MainActor in
            if let error = await apphudService.restoreSubs() {
                LoaderView.hide()
                presentRestorePurchasesFailureAlert(errorDescription: error.localizedDescription)
            } else {
                LoaderView.hide()
                presentRestorePurchasesSuccessBanner()
            }
        }
    }
    
    private func handlePrivacyPolicy() {
        BrowserPresenter.presentInAppBrowser(with: Constants.ppURL)
    }
    
    private func handleTermsOfUse() {
        BrowserPresenter.presentInAppBrowser(with: Constants.termsURL)
    }
    
    private func handleContactUs() {
        BrowserPresenter.presentInAppBrowser(with: Constants.supportURL)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return apphudService.hasSubscribed ? 0 : 1 // Restore only if not subscribed
        case 1:
            return 3 // Privacy, Terms, Contact
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Subscription"
        case 1:
            return "Support"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Restore Purchases"
            cell.accessoryType = .none
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Privacy Policy"
            case 1:
                cell.textLabel?.text = "Terms of Use"
            case 2:
                cell.textLabel?.text = "Contact Us"
            default:
                break
            }
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            handleRestorePurchases()
        case 1:
            switch indexPath.row {
            case 0:
                handlePrivacyPolicy()
            case 1:
                handleTermsOfUse()
            case 2:
                handleContactUs()
            default:
                break
            }
        default:
            break
        }
    }
}

