import CoreData
import Foundation

final class DefaultGalleryRepository: GalleryRepository {
    private let apiService: GalleryAPIServiceProtocol
    private let persistence: PersistenceController
    private let imageCache: ImageFileCache

    init(
        apiService: GalleryAPIServiceProtocol,
        persistence: PersistenceController,
        imageCache: ImageFileCache
    ) {
        self.apiService = apiService
        self.persistence = persistence
        self.imageCache = imageCache
    }

    func fetchPage(page: Int, pageSize: Int) async throws -> [Wallpaper] {
        let wallpapers = try await apiService.fetchImages(page: page, limit: pageSize)

        for wallpaper in wallpapers {
            await imageCache.cacheImageIfNeeded(id: wallpaper.id, from: wallpaper.remoteURL)
        }

        try await persist(pageWallpapers: wallpapers)
        return await loadCachedWallpapers().filter { wallpapers.map(\.id).contains($0.id) }
    }

    func loadCachedWallpapers() async -> [Wallpaper] {
        await withCheckedContinuation { continuation in
            let context = persistence.container.newBackgroundContext()
            context.perform {
                let request = CachedWallpaperEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]

                let items = (try? context.fetch(request)) ?? []
                let wallpapers = items.compactMap { entity -> Wallpaper? in
                    guard let remoteURL = URL(string: entity.remoteURL) else { return nil }
                    return Wallpaper(
                        id: entity.id,
                        author: entity.author,
                        width: Int(entity.width),
                        height: Int(entity.height),
                        remoteURL: remoteURL,
                        localFilePath: entity.localPath
                    )
                }
                continuation.resume(returning: wallpapers)
            }
        }
    }

    private func persist(pageWallpapers: [Wallpaper]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let context = persistence.container.newBackgroundContext()
            context.perform {
                do {
                    for wallpaper in pageWallpapers {
                        let request = CachedWallpaperEntity.fetchRequest()
                        request.predicate = NSPredicate(format: "id == %@", wallpaper.id)
                        request.fetchLimit = 1

                        let entity = try context.fetch(request).first ?? CachedWallpaperEntity(context: context)
                        entity.id = wallpaper.id
                        entity.author = wallpaper.author
                        entity.width = Int32(wallpaper.width)
                        entity.height = Int32(wallpaper.height)
                        entity.remoteURL = wallpaper.remoteURL.absoluteString
                        entity.localPath = self.imageCache.localPath(for: wallpaper.id)
                        entity.updatedAt = Date()
                    }

                    if context.hasChanges {
                        try context.save()
                    }
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
