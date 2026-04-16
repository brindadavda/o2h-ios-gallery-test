import Foundation
import Combine

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published private(set) var wallpapers: [Wallpaper] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: GalleryRepository
    private var page = 1
    private let pageSize = 20
    private var reachedEnd = false

    init(repository: GalleryRepository) {
        self.repository = repository
    }

    func bootstrap() {
        Task {
            let cached = await repository.loadCachedWallpapers()
            wallpapers = cached
            if cached.isEmpty {
                await loadNextPage()
            }
        }
    }

    func loadNextPageIfNeeded(currentItem: Wallpaper?) {
        guard let currentItem else {
            Task { await loadNextPage() }
            return
        }

        let thresholdIndex = wallpapers.index(wallpapers.endIndex, offsetBy: -5, limitedBy: wallpapers.startIndex) ?? wallpapers.startIndex
        if wallpapers.indices.contains(thresholdIndex), wallpapers[thresholdIndex].id == currentItem.id {
            Task { await loadNextPage() }
        }
    }

    func refresh() async {
        page = 1
        reachedEnd = false
        wallpapers = []
        await loadNextPage()
    }

    private func loadNextPage() async {
        guard !isLoading, !reachedEnd else { return }
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await repository.fetchPage(page: page, pageSize: pageSize)
            if fetched.isEmpty {
                reachedEnd = true
            } else {
                page += 1
                let incomingIDs = Set(fetched.map(\.id))
                wallpapers.removeAll { incomingIDs.contains($0.id) }
                wallpapers.append(contentsOf: fetched)
            }
        } catch {
            let cached = await repository.loadCachedWallpapers()
            if !cached.isEmpty {
                wallpapers = cached
            }
            errorMessage = "Could not load online images. Showing offline data if available."
        }

        isLoading = false
    }
}
