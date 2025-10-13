import UIKit
import ApphudSDK

class SplashViewController: UIViewController {

    private var coordinator: AppCoordinator? {
        navigationController as? AppCoordinator
    }

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splashIcon")
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Body & Face Editor"
        label.textColor = .white
        label.font = UIFont(name: "Inter-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        Task { @MainActor in
            // Простой тест - сразу показываем онбординг
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.coordinator?.openOnboarding()
            }
        }
    }

    private func presentNetworkErrorAlert() {
        let alertController = UIAlertController(
            title: "Нет подключения к интернету",
            message: "Проверьте подключение к интернету и попробуйте снова",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.retry()
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Продолжить", style: .default) { _ in
            self.coordinator?.openApp()
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func activate() async {
        await withCheckedContinuation { continuation in
            Apphud.start(apiKey: Constants.apphudKey) { _ in
                continuation.resume()
            }
        }
    }

    private func retry() {
         Task { @MainActor in
            let isConnected = await ReachabilityService.shared.checkNetworkStatusAsync()
            if !isConnected {
                self.presentNetworkErrorAlert()
                return
            }
            await activate()
            await AppHudService.shared.preloadData()
            await FirebaseService.shared.load()
            if LocalStorage.shared.isIntroShown || AppHudService.shared.hasSubscribed == true {
                self.coordinator?.openApp()
            } else {
                self.coordinator?.openOnboarding()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPulsatingAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPulsatingAnimation()
    }

    private func setupUI() {
        let bgImage = UIImageView(image: UIImage(named: "bg"))
        bgImage.contentMode = .scaleAspectFill
        view.addSubview(bgImage)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 125),
            logoImageView.heightAnchor.constraint(equalToConstant: 117),
            
            appNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24)
        ])
    }
    
    private func startPulsatingAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: { [weak self] in
            self?.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    private func stopPulsatingAnimation() {
        logoImageView.layer.removeAllAnimations()
        logoImageView.transform = CGAffineTransform.identity
    }
}
