//
//  SaveQRCodeUseCase.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

final class SaveQRCodeUseCase: SaveQRCodeUseCaseProtocol {
    private let repository: QRCodeRepositoryProtocol
    
    init(repository: QRCodeRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Сохраняет QR-код в базу данных
    func execute(content: String, imagePath: String?, thumbnailPath: String?) throws {
        // Бизнес-логика: проверка содержимого QR-кода
        guard !content.isEmpty else {
            throw NSError(domain: "SaveQRCodeUseCase", code: 1, userInfo: [NSLocalizedDescriptionKey: "Content cannot be empty"])
        }
        
        // Вызов метода репозитория для сохранения QR-кода
        try repository.saveQRCode(content: content, imagePath: imagePath, thumbnailPath: thumbnailPath)
    }
}
