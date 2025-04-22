//
//  ScannerViewProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import UIKit.UIImage

protocol ScannerViewModelProtocol {
    func saveQRCode(content: String, image: UIImage?)
    
    func showHistory()
    
    var onShowHistory: (() -> Void)? { get set }
    
    var delegate: ScannerViewModelDelegate? { get set }
}
