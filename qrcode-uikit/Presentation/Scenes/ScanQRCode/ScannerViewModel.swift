//
//  ScannerViewModel.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import UIKit.UIImage

protocol ScannerViewModelDelegate: AnyObject {
    func didSaveQRCodeSuccessfully()
    
    func didFailWithError(_ error: Error)
    
    func navigateToHistory()
}

final class ScannerViewModel: ScannerViewModelProtocol {
    private let saveQRCodeUseCase: SaveQRCodeUseCaseProtocol
    private let imageStorageService: ImageStorageServiceProtocol
    
    weak var delegate: ScannerViewModelDelegate?
    
    var onShowHistory: (() -> Void)?
    
    init(saveQRCodeUseCase: SaveQRCodeUseCaseProtocol, imageStorageService: ImageStorageServiceProtocol = ImageStorageService()) {
        self.saveQRCodeUseCase = saveQRCodeUseCase
        self.imageStorageService = imageStorageService
    }
    
    func saveQRCode(content: String, image: UIImage?) {
        let paths = imageStorageService.saveImage(image ?? UIImage())
        
        do {
            try saveQRCodeUseCase.execute(content: content, imagePath: paths.originalPath, thumbnailPath: paths.thumbnailPath)
            delegate?.didSaveQRCodeSuccessfully()
        } catch {
            delegate?.didFailWithError(error)
        }
    }
    
    func showHistory() {
        onShowHistory?()
    }
}
