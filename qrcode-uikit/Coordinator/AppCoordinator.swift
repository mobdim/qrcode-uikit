//
//  AppCoordinator.swift
//  qrcode-uikit
//
//  Created by dima on 20.04.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let coreDataStack: CoreDataStack
    private let fileManagerHelper: FileManagerHelper
    private let appStateService: AppStateService
    internal var childCoordinators: [Coordinator] = []
    
    private var needsOnboarding: Bool { appStateService.hasCompletedOnboarding }
    
    init(window: UIWindow,
         coreDataStack: CoreDataStack = .shared,
         fileManagerHelper: FileManagerHelper = .shared,
         appStateService: AppStateService = AppStateServiceImpl()) {
        self.window = window
        self.coreDataStack = coreDataStack
        self.fileManagerHelper = fileManagerHelper
        self.appStateService = appStateService
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        
        configureNavigationAppearance()
        
        window.rootViewController = navigationController
    }
    
    func start() {
        showInitialFlow()
    }
    
    func handleDeepLink(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        switch components.path {
        case "/scan":
            startScannerFlow()
        case "/history":
            startHistoryFlow()
        case "/scan/prefill":
            if let content = components.queryItems?.first(where: { $0.name == "content" })?.value {
                startScannerFlow(withPrefilledContent: content)
            }
        default:
            break
        }
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    
    private func configureNavigationBarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .systemBlue
    }
    
    func showInitialFlow() {
        if !needsOnboarding {
            startScannerFlow()
        } else {
            showOnboarding()
        }
    }
    
    func startScannerFlow(withPrefilledContent content: String? = nil) {
        
        guard let rootNavController = window.rootViewController as? UINavigationController else { return }
        
        let scannerCoordinator = ScannerCoordinator(
            navigationController: rootNavController,
            prefilledContent: content
        )
        
        scannerCoordinator.delegate = self
        childCoordinators.append(scannerCoordinator)
        
        transitionRoot(to: rootNavController)
        scannerCoordinator.start()
    }
    
    func startHistoryFlow() {
        guard let rootNavController = window.rootViewController as? UINavigationController else { return }
        
//        let historyCoordinator = HistoryCoordinator(
//            navigationController: rootNavController,
//            coreDataStack: coreDataStack,
//            fileManagerHelper: fileManagerHelper
//        )
//        
//        historyCoordinator.delegate = self
//        childCoordinators.append(historyCoordinator)
//        historyCoordinator.start()
    }
    
    
        
        private func showOnboarding() {
//            let onboardingVC = OnboardingViewController()
//            onboardingVC.onCompletion = { [weak self] in
//                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
//                self?.startMainFlow()
//            }
//            transitionRoot(to: onboardingVC)
        }
    
    func transitionRoot(to controller: UIViewController) {
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.window.rootViewController = controller
            }
        )
    }
    
    func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Coordinator Delegates
extension AppCoordinator: ScannerCoordinatorDelegate {
    func scannerCoordinator(_ coordinator: ScannerCoordinator, didScanQRCode code: String, withImage image: UIImage?) {
        
    }
    
    func scannerCoordinatorDidFinish(_ coordinator: ScannerCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

//extension AppCoordinator: HistoryCoordinatorDelegate {
//    func historyCoordinatorDidFinish(_ coordinator: HistoryCoordinator) {
//        childCoordinators.removeAll { $0 === coordinator }
//    }
//}
