//
//  QRCodeEntity.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation
import CoreData

@objc(QRCodeEntity)
class QRCodeEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var timestamp: Date
    @NSManaged public var imagePath: String?
    @NSManaged public var thumbnailPath: String?
}

// MARK: - Convenience Methods
extension QRCodeEntity {
    static func create(
        in context: NSManagedObjectContext,
        content: String,
        imagePath: String? = nil
    ) -> QRCodeEntity {
        let entity = QRCodeEntity(context: context)
        entity.id = UUID()
        entity.content = content
        entity.timestamp = Date()
        entity.imagePath = imagePath
        return entity
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QRCodeEntity> {
        return NSFetchRequest<QRCodeEntity>(entityName: "QRCodeEntity")
    }
    
    func toDomain() -> QRCode {
        return QRCode(content: content,
                      scanDate: timestamp,
                      imagePath: imagePath,
                      thumbnailPath: thumbnailPath)
    }
    
    static func fetchAll(in context: NSManagedObjectContext) throws -> [QRCodeEntity] {
        let fetchRequest: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error
        }
    }
}
