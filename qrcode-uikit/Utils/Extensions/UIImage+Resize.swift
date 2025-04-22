//
//  UIImage+Resize.swift
//  qrcode-uikit
//
//  Created by dima on 21.04.2025.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func resized(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let ratio = size.width > size.height ?
            maxDimension / size.width :
            maxDimension / size.height
        
        let newSize = CGSize(
            width: size.width * ratio,
            height: size.height * ratio
        )
        return resized(to: newSize)
    }
}
