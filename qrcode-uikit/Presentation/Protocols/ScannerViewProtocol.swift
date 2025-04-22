//
//  ScannerViewProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import UIKit.UIImage

protocol ScannerViewModelProtocol {
    /// Сохраняет QR-код
    func saveQRCode(content: String, image: UIImage?)
    
    /// Переход к экрану истории
    func showHistory()
    
    /// Замыкание для перехода к экрану истории
    var onShowHistory: (() -> Void)? { get set }
    
    /// Делегат для уведомлений
    var delegate: ScannerViewModelDelegate? { get set }
}
