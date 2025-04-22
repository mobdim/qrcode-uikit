//
//  ImageStorageService.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import UIKit

final class ImageStorageService: ImageStorageServiceProtocol {
    private let fileManagerHelper = FileManagerHelper.shared
    
    func saveImage(_ image: UIImage) -> (originalPath: String?, thumbnailPath: String?) {
        do {
            let paths = try fileManagerHelper.saveImage(image)
            return (paths.imagePath, paths.thumbnailPath)
        } catch {
            print("Failed to save image: \(error)")
            return (nil, nil)
        }
    }
    
    func deleteImage(at path: String) throws {
        try fileManagerHelper.deleteFile(at: path)
        
        let thumbnailPath = path.replacingOccurrences(of: "QRCodeImages", with: "QRCodeThumbnails")
        try fileManagerHelper.deleteFile(at: thumbnailPath)
    }
    
    func loadImage(at path: String) -> UIImage? {
        guard fileManagerHelper.fileExists(at: path) else { return nil }
        return UIImage(contentsOfFile: path)
    }
    
    func loadThumbnail(at path: String) -> UIImage? {
        let thumbnailPath = path.replacingOccurrences(of: "QRCodeImages", with: "QRCodeThumbnails")
        guard fileManagerHelper.fileExists(at: thumbnailPath) else { return nil }
        return UIImage(contentsOfFile: thumbnailPath)
    }
}
