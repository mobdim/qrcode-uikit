//
//  Coordinator.swift
//  qrcode-uikit
//
//  Created by dima on 20.04.2025.
//

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

//protocol ScannerCoordinatorDelegate: AnyObject {
//    func scannerCoordinatorDidFinish(_ coordinator: ScannerCoordinator)
//}
//
//protocol HistoryCoordinatorDelegate: AnyObject {
//    func historyCoordinatorDidFinish(_ coordinator: HistoryCoordinator)
//}
