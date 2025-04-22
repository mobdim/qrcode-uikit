//
//  QRCodeRepositoryProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

protocol QRCodeRepositoryProtocol {
    func saveQRCode(content: String, imagePath: String?, thumbnailPath: String?) throws
    func fetchQRCodeHistory() throws -> [QRCodeEntity]
    func deleteQRCode(by id: UUID) throws
}
