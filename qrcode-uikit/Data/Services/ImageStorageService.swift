//
//  ImageStorageService.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import UIKit

final class ImageStorageService: ImageStorageServiceProtocol {
    private let fileManagerHelper = FileManagerHelper.shared
    
    /// Сохраняет изображение и его миниатюру в файловой системе
    func saveImage(_ image: UIImage) -> (originalPath: String?, thumbnailPath: String?) {
        do {
            let paths = try fileManagerHelper.saveImage(image)
            return (paths.imagePath, paths.thumbnailPath)
        } catch {
            print("Failed to save image: \(error)")
            return (nil, nil)
        }
    }
    
    /// Удаляет изображение и его миниатюру по указанному пути
    func deleteImage(at path: String) throws {
        // Удаление оригинального изображения
        try fileManagerHelper.deleteFile(at: path)
        
        // Удаление миниатюры
        let thumbnailPath = path.replacingOccurrences(of: "QRCodeImages", with: "QRCodeThumbnails")
        try fileManagerHelper.deleteFile(at: thumbnailPath)
    }
    
    /// Загружает изображение по указанному пути
    func loadImage(at path: String) -> UIImage? {
        guard fileManagerHelper.fileExists(at: path) else { return nil }
        return UIImage(contentsOfFile: path)
    }
    
    /// Загружает миниатюру по указанному пути
    func loadThumbnail(at path: String) -> UIImage? {
        let thumbnailPath = path.replacingOccurrences(of: "QRCodeImages", with: "QRCodeThumbnails")
        guard fileManagerHelper.fileExists(at: thumbnailPath) else { return nil }
        return UIImage(contentsOfFile: thumbnailPath)
    }
}
