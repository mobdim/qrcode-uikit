//
//  SaveQRCodeUseCaseProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

protocol SaveQRCodeUseCaseProtocol {
    func execute(content: String, imagePath: String?, thumbnailPath: String?) throws
}
