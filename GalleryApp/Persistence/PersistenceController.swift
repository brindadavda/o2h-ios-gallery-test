import CoreData
import Foundation

@objc(CachedWallpaperEntity)
final class CachedWallpaperEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var author: String
    @NSManaged var width: Int32
    @NSManaged var height: Int32
    @NSManaged var remoteURL: String
    @NSManaged var localPath: String?
    @NSManaged var updatedAt: Date
}

extension CachedWallpaperEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CachedWallpaperEntity> {
        NSFetchRequest<CachedWallpaperEntity>(entityName: "CachedWallpaperEntity")
    }
}

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "GalleryModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load error: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "CachedWallpaperEntity"
        entity.managedObjectClassName = NSStringFromClass(CachedWallpaperEntity.self)

        let id = NSAttributeDescription()
        id.name = "id"
        id.attributeType = .stringAttributeType
        id.isOptional = false

        let author = NSAttributeDescription()
        author.name = "author"
        author.attributeType = .stringAttributeType
        author.isOptional = false

        let width = NSAttributeDescription()
        width.name = "width"
        width.attributeType = .integer32AttributeType
        width.isOptional = false

        let height = NSAttributeDescription()
        height.name = "height"
        height.attributeType = .integer32AttributeType
        height.isOptional = false

        let remoteURL = NSAttributeDescription()
        remoteURL.name = "remoteURL"
        remoteURL.attributeType = .stringAttributeType
        remoteURL.isOptional = false

        let localPath = NSAttributeDescription()
        localPath.name = "localPath"
        localPath.attributeType = .stringAttributeType
        localPath.isOptional = true

        let updatedAt = NSAttributeDescription()
        updatedAt.name = "updatedAt"
        updatedAt.attributeType = .dateAttributeType
        updatedAt.isOptional = false

        entity.properties = [id, author, width, height, remoteURL, localPath, updatedAt]
        entity.uniquenessConstraints = [["id"]]

        model.entities = [entity]
        return model
    }
}
