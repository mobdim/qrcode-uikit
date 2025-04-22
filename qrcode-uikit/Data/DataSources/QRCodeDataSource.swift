//
//  QRCodeDataSource.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import CoreData

final class QRCodeDataSource: QRCodeDataSourceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insertQRCode(content: String, imagePath: String?, thumbnailPath: String?) throws {
        let entity = QRCodeEntity(context: context)
        entity.id = UUID()
        entity.content = content
        entity.timestamp = Date()
        entity.imagePath = imagePath
        entity.thumbnailPath = thumbnailPath
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    func fetchAllQRCodeEntities() throws -> [QRCodeEntity] {
        let fetchRequest: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error
        }
    }
    
    func deleteQRCode(by id: UUID) throws {
        let fetchRequest: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for entity in results {
                context.delete(entity)
            }
            try context.save()
        } catch {
            throw error
        }
    }
}
