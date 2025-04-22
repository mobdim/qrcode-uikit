//
//  CoreDataStack.swift
//  qrcode-uikit
//
//  Created by dima on 21.04.2025.
//

import UIKit
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        removeExistingDatabaseIfNeeded()
        
        let container = NSPersistentContainer(name: "qrcode_uikit")
        
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error as NSError? {
                self?.handlePersistentStoreError(error)
            }
        }
        
        return container
    }()
    
    // Контексты для разных потоков
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Создает новый контекст для фоновых задач
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Methods
    func saveContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch {
            handleSaveError(error)
        }
    }
    
    /// Сохраняет изменения в фоновом контексте
    func saveBackgroundContext(_ context: NSManagedObjectContext, completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            do {
                try context.save()
                completion(.success(()))
            } catch {
                context.rollback()
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Error Handling
    private func handlePersistentStoreError(_ error: NSError) {
        let reason: String
        
        switch (error.code, error.domain) {
        case (NSPersistentStoreIncompatibleVersionHashError, NSCocoaErrorDomain):
            reason = "Model version mismatch. Try reinstalling the app."
        case (NSMigrationMissingSourceModelError, NSCocoaErrorDomain):
            reason = "Migration failed. Reinstall required."
        case (NSPersistentStoreInvalidTypeError, NSCocoaErrorDomain):
            reason = "Invalid store type configuration."
        default:
            reason = "Unknown Core Data error: \(error.localizedDescription)"
        }
        
        print("Unresolved Core Data error: \(reason)")
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: reason,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func handleSaveError(_ error: Error) {
        let nsError = error as NSError
        print("Unresolved Core Data save error \(nsError), \(nsError.userInfo)")
        
        #if DEBUG
        assertionFailure("Core Data save failed")
        #endif
    }
    
    // MARK: - Migration
    private func removeExistingDatabaseIfNeeded() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = paths[0]
        let databaseURL = appSupportURL.appendingPathComponent("qrcode_uikit.sqlite")
        
        if FileManager.default.fileExists(atPath: databaseURL.path) {
            try? FileManager.default.removeItem(at: databaseURL)
            print("Old database removed.")
        }
    }
    
    // MARK: - Debug
    func printDatabaseStats() {
        let request: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        
        do {
            let count = try viewContext.count(for: request)
            print("Total QR codes in database: \(count)")
        } catch {
            print("Error counting records: \(error)")
        }
    }
}
