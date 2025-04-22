//
//  FetchQRCodeHistoryUseCaseProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

protocol FetchQRCodeHistoryUseCaseProtocol {
    func execute() throws -> [QRCode]
}
