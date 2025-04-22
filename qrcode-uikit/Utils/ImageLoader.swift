//
//  ImageLoader.swift
//  qrcode-uikit
//
//  Created by dima on 21.04.2025.
//

import UIKit
import ImageIO

final class ImageLoader {
    static let shared = ImageLoader()
    private let fileManagerHelper = FileManagerHelper.shared
    
    private var screenScale: CGFloat {
        UIScreen.main.scale
    }
    
    private var thumbnailSize: CGSize {
        CGSize(width: 200 * screenScale, height: 200 * screenScale)
    }
    
    private var maxImageDimension: CGFloat {
        2048 * screenScale
    }
    
    func loadImage(from path: String, targetSize: TargetSize) -> UIImage? {
        guard fileManagerHelper.fileExists(at: path) else { return nil }
        
        let url = URL(fileURLWithPath: path)
        let options: [CFString: Any]
        let createFunction: (CGImageSource, Int, CFDictionary?) -> CGImage?
        
        switch targetSize {
        case .thumbnail:
            options = [
                kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceThumbnailMaxPixelSize: max(thumbnailSize.width, thumbnailSize.height)
            ]
            createFunction = CGImageSourceCreateThumbnailAtIndex
            
        case .optimized:
            options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: false,
                kCGImageSourceThumbnailMaxPixelSize: maxImageDimension
            ]
            createFunction = CGImageSourceCreateImageAtIndex
            
        case .original:
            return loadOriginalImage(from: path)
        }
        
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let cgImage = createFunction(source, 0, options as CFDictionary) else {
            return loadOriginalImage(from: path)
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func loadOriginalImage(from path: String) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return image.fixedOrientation()
    }
    
    enum TargetSize {
        case thumbnail    // Для списков (200pt @scale)
        case optimized   // Оптимизированный размер (2048pt @scale)
        case original    // Оригинал без обработки
    }
}
