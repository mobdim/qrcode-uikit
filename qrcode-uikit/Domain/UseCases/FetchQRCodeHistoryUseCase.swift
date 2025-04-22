//
//  FetchQRCodeHistoryUseCase.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

final class FetchQRCodeHistoryUseCase: FetchQRCodeHistoryUseCaseProtocol {
    private let repository: QRCodeRepositoryProtocol
    
    init(repository: QRCodeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [QRCode] {
        // Получение данных из репозитория
        let qrCodeEntities = try repository.fetchQRCodeHistory()
        
        // Преобразование в модели домена
        return qrCodeEntities.map { $0.toDomain() }
    }
}
