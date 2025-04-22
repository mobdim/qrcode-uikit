//
//  QRCodeRepository.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

final class QRCodeRepository: QRCodeRepositoryProtocol {
    private let dataSource: QRCodeDataSourceProtocol
    private let coreDataStack: CoreDataStack
    
    init(dataSource: QRCodeDataSourceProtocol, coreDataStack: CoreDataStack) {
        self.dataSource = dataSource
        self.coreDataStack = coreDataStack
    }
    
    /// Сохраняет QR-код в базу данных
    func saveQRCode(content: String, imagePath: String?, thumbnailPath: String?) throws {
        try dataSource.insertQRCode(content: content, imagePath: imagePath, thumbnailPath: thumbnailPath)
        coreDataStack.saveContext()
    }
    
    /// Получает историю сканированных QR-кодов
    func fetchQRCodeHistory() throws -> [QRCodeEntity] {
        return try dataSource.fetchAllQRCodeEntities()
    }
    
    /// Удаляет QR-код по уникальному идентификатору
    func deleteQRCode(by id: UUID) throws {
        try dataSource.deleteQRCode(by: id)
        coreDataStack.saveContext()
    }
}
