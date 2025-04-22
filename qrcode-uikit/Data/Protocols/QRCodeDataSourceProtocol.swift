//
//  QRCodeDataSourceProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

protocol QRCodeDataSourceProtocol {
    func insertQRCode(content: String, imagePath: String?, thumbnailPath: String?) throws
    func fetchAllQRCodeEntities() throws -> [QRCodeEntity]
    func deleteQRCode(by id: UUID) throws
}
