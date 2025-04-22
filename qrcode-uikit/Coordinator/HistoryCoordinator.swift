//
//  HistoryCoordinator.swift
//  qrcode-uikit
//
//  Created by dima on 20.04.2025.
//

import UIKit

//final class HistoryCoordinator: Coordinator {
//    private let navigationController: UINavigationController
//    private let coreDataStack: CoreDataStack
//    private let fileManagerHelper: FileManagerHelper
//    weak var delegate: HistoryCoordinatorDelegate?
//    
//    var childCoordinators: [Coordinator] = []
//    
//    init(navigationController: UINavigationController,
//         coreDataStack: CoreDataStack,
//         fileManagerHelper: FileManagerHelper) {
//        self.navigationController = navigationController
//        self.coreDataStack = coreDataStack
//        self.fileManagerHelper = fileManagerHelper
//    }
//    
//    func start() {
//        let repository = QRScannerRepository(
//            dataSource: QRScannerDataSource(),
//            coreDataStack: coreDataStack,
//            fileManagerHelper: fileManagerHelper
//        )
//        
//        let fetchUseCase = FetchHistoryUseCase(repository: repository)
//        let deleteUseCase = DeleteQRCodeUseCase(repository: repository)
//        
//        let viewModel = HistoryViewModel(
//            fetchHistoryUseCase: fetchUseCase,
//            deleteQRCodeUseCase: deleteUseCase,
//            fileManagerHelper: fileManagerHelper
//        )
//        
//        let historyVC = HistoryViewController(viewModel: viewModel)
//        viewModel.view = historyVC
//        
//        navigationController.pushViewController(historyVC, animated: true)
//    }
//}
