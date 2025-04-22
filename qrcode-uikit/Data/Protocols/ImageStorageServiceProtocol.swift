//
//  ImageStorageServiceProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import UIKit

protocol ImageStorageServiceProtocol {
    /// Сохраняет изображение и его миниатюру в файловой системе
    func saveImage(_ image: UIImage) -> (originalPath: String?, thumbnailPath: String?)
    
    /// Удаляет изображение и его миниатюру по указанному пути
    func deleteImage(at path: String) throws
    
    /// Загружает изображение по указанному пути
    func loadImage(at path: String) -> UIImage?
    
    /// Загружает миниатюру по указанному пути
    func loadThumbnail(at path: String) -> UIImage?
}
