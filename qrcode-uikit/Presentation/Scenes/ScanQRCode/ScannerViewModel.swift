//
//  ScannerViewModel.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import UIKit.UIImage

protocol ScannerViewModelDelegate: AnyObject {
    /// Уведомляет о успешном сохранении QR-кода
    func didSaveQRCodeSuccessfully()
    
    /// Уведомляет об ошибке при сохранении QR-кода
    func didFailWithError(_ error: Error)
    
    /// Уведомляет о необходимости перехода к экрану истории
    func navigateToHistory()
}

final class ScannerViewModel: ScannerViewModelProtocol {
    private let saveQRCodeUseCase: SaveQRCodeUseCaseProtocol
    private let imageStorageService: ImageStorageServiceProtocol
    
    weak var delegate: ScannerViewModelDelegate?
    
    /// Замыкание для перехода на экран истории
    var onShowHistory: (() -> Void)?
    
    init(
        saveQRCodeUseCase: SaveQRCodeUseCaseProtocol,
        imageStorageService: ImageStorageServiceProtocol = ImageStorageService()
    ) {
        self.saveQRCodeUseCase = saveQRCodeUseCase
        self.imageStorageService = imageStorageService
    }
    
    /// Сохраняет отсканированный QR-код
    func saveQRCode(content: String, image: UIImage?) {
        // Сохраняем изображение и миниатюру
        let paths = imageStorageService.saveImage(image ?? UIImage())
        
        // Вызываем Use Case для сохранения QR-кода
        do {
            try saveQRCodeUseCase.execute(content: content, imagePath: paths.originalPath, thumbnailPath: paths.thumbnailPath)
            delegate?.didSaveQRCodeSuccessfully()
        } catch {
            delegate?.didFailWithError(error)
        }
    }
    
    /// Переход к экрану истории
    func showHistory() {
        onShowHistory?()
    }
}
