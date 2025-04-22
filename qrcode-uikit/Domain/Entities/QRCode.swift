//
//  QRCode.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import CoreData

struct QRCode {
    let content: String
    let scanDate: Date
    let imagePath: String?
    let thumbnailPath: String?
    
    func toEntity(in context: NSManagedObjectContext) -> QRCodeEntity {
        let entity = QRCodeEntity(context: context)
        entity.content = content
        entity.timestamp = scanDate
        entity.imagePath = imagePath
        entity.thumbnailPath = thumbnailPath
        return entity
    }
}
