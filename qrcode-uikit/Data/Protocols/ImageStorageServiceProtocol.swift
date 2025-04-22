//
//  ImageStorageServiceProtocol.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import UIKit

protocol ImageStorageServiceProtocol {
    func saveImage(_ image: UIImage) -> (originalPath: String?, thumbnailPath: String?)
    
    func deleteImage(at path: String) throws
    
    func loadImage(at path: String) -> UIImage?
    
    func loadThumbnail(at path: String) -> UIImage?
}
