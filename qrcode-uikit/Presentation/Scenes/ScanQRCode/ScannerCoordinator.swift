//
//  ScannerCoordinator.swift
//  qrcode-uikit
//
//  Created by dima on 20.04.2025.
//

import UIKit
import AVFoundation

protocol ScannerCoordinatorDelegate: AnyObject {
    func scannerCoordinatorDidFinish(_ coordinator: ScannerCoordinator)
    func scannerCoordinator(_ coordinator: ScannerCoordinator, didScanQRCode code: String, withImage image: UIImage?)
}

final class ScannerCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let imageLoader: ImageLoader
    private let coreDataStack: CoreDataStack
    private let prefilledContent: String?
    weak var delegate: ScannerCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    private var currentImage: UIImage?
    
    init(navigationController: UINavigationController,
         imageLoader: ImageLoader = .shared,
         coreDataStack: CoreDataStack = .shared,
         prefilledContent: String? = nil) {
        self.navigationController = navigationController
        self.imageLoader = imageLoader
        self.coreDataStack = coreDataStack
        self.prefilledContent = prefilledContent
    }
    
    func start() {
        if let content = prefilledContent {
            showQRCodeDetails(content: content, image: nil)
        } else {
            showScanner()
        }
    }
    
    // MARK: - Flow Navigation
    private func showScanner() {
        let saveQRCodeUseCase = SaveQRCodeUseCase(repository: QRCodeRepository(
            dataSource: QRCodeDataSource(context: CoreDataStack.shared.viewContext),
            coreDataStack: CoreDataStack.shared
        ))
        let imageStorageService = ImageStorageService()
        
        let scannerViewModel = ScannerViewModel(
            saveQRCodeUseCase: saveQRCodeUseCase,
            imageStorageService: imageStorageService
        )
        
        let scannerViewController = ScannerViewController(viewModel: scannerViewModel)
        scannerViewController.title = "Scan QR Code"
        
        scannerViewModel.onShowHistory = { [weak self] in
            self?.showHistory()
        }
        
        navigationController.setViewControllers([scannerViewController], animated: true)
    }
    
    private func showHistory() {
//        let historyCoordinator = HistoryCoordinator(
//            navigationController: navigationController,
//            imageLoader: imageLoader,
//            coreDataStack: coreDataStack
//        )
//        
//        historyCoordinator.delegate = self
//        childCoordinators.append(historyCoordinator)
//        historyCoordinator.start()
    }
    
    func showQRCodeDetails(content: String, image: UIImage?) {
//        let detailCoordinator = DetailCoordinator(
//            navigationController: navigationController,
//            qrContent: content,
//            qrImage: image,
//            imageLoader: imageLoader
//        )
//        
//        detailCoordinator.delegate = self
//        childCoordinators.append(detailCoordinator)
//        detailCoordinator.start()
    }
}

// MARK: - ScannerViewControllerDelegate
//extension ScannerCoordinator: ScannerViewControllerDelegate {
//    func scannerViewController(_ controller: ScannerViewController,
//                             didScanQRCode code: String,
//                             withImage image: UIImage?) {
//        currentImage = image
//        delegate?.scannerCoordinator(self, didScanQRCode: code, withImage: image)
//        showQRCodeDetails(content: code, image: image)
//    }
//    
//    func scannerViewControllerDidFailWithError(_ controller: ScannerViewController,
//                                             error: QRScannerError) {
//        showErrorAlert(message: error.localizedDescription)
//    }
//}

// MARK: - Child Coordinators Delegates
//extension ScannerCoordinator: HistoryCoordinatorDelegate {
//    func historyCoordinatorDidFinish(_ coordinator: HistoryCoordinator) {
//        removeChildCoordinator(coordinator)
//    }
//    
//    func historyCoordinator(_ coordinator: HistoryCoordinator,
//                          didSelectItemWithContent content: String,
//                          imagePath: String?) {
//        let image = imagePath.flatMap { imageLoader.loadImage(from: $0, targetSize: .optimized) }
//        showQRCodeDetails(content: content, image: image)
//    }
//}

//extension ScannerCoordinator: DetailCoordinatorDelegate {
//    func detailCoordinatorDidFinish(_ coordinator: DetailCoordinator) {
//        removeChildCoordinator(coordinator)
//        navigationController.popToRootViewController(animated: true)
//    }
//}

// MARK: - Private Methods
private extension ScannerCoordinator {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
