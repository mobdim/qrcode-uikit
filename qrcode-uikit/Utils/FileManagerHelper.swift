//
//  FileManagerHelper.swift
//  qrcode-uikit
//
//  Created by dima on 21.04.2025.
//

import UIKit

final class FileManagerHelper {
    static let shared = FileManagerHelper()
    private let fileManager = FileManager.default
    private let thumbnailCache = NSCache<NSString, UIImage>()
    
    private let imagesDirectory = "QRCodeImages"
    private let thumbnailsDirectory = "QRCodeThumbnails"
    private let queue = DispatchQueue(label: "FileManagerHelperQueue", qos: .utility)
    
    private init() {
        setupDirectories()
    }
    
    // MARK: - Public Interface
    func saveImage(_ image: UIImage) throws -> (imagePath: String, thumbnailPath: String) {
        try queue.sync {
            try createDirectoryIfNeeded(imagesDirectory)
            try createDirectoryIfNeeded(thumbnailsDirectory)
            
            let timestamp = Date().timeIntervalSince1970
            let filename = "\(Int(timestamp)).jpg"
            
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageURL = documentsURL.appendingPathComponent("\(imagesDirectory)/\(filename)")
            let thumbnailURL = documentsURL.appendingPathComponent("\(thumbnailsDirectory)/\(filename)")
            
            guard let imageData = image.jpegData(compressionQuality: 0.7),
                  let thumbnailData = image.resized(to: CGSize(width: 200, height: 200)).jpegData(compressionQuality: 0.8) else {
                throw FileManagerError.imageConversionFailed
            }
            
            do {
                try imageData.write(to: imageURL)
                try thumbnailData.write(to: thumbnailURL)
                return ("\(imagesDirectory)/\(filename)", "\(thumbnailsDirectory)/\(filename)")
            } catch {
                try? fileManager.removeItem(at: imageURL)
                try? fileManager.removeItem(at: thumbnailURL)
                throw error
            }
        }
    }
    
    func fileExists(at path: String) -> Bool {
        queue.sync {
            let url = URL(fileURLWithPath: path)
            return fileManager.fileExists(atPath: url.path)
        }
    }
    
    func deleteFile(at path: String) throws {
        try queue.sync {
            let url = URL(fileURLWithPath: path)
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
        }
    }
    
    // MARK: - Private
    private func setupDirectories() {
        [imagesDirectory, thumbnailsDirectory].forEach {
            try? createDirectoryIfNeeded($0)
        }
    }
    
    private func createDirectoryIfNeeded(_ name: String) throws {
        let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(name)
        
        if !fileManager.fileExists(atPath: url.path) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
}

enum FileManagerError: Error {
    case imageConversionFailed
    case directoryCreationFailed
}
