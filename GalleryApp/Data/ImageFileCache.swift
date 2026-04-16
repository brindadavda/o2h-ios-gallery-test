import Foundation

final class ImageFileCache {
    private let directoryURL: URL
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        directoryURL = caches.appendingPathComponent("gallery-images", isDirectory: true)
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    func localPath(for id: String) -> String {
        directoryURL.appendingPathComponent("\(id).jpg").path
    }

    func isCached(id: String) -> Bool {
        FileManager.default.fileExists(atPath: localPath(for: id))
    }

    func cacheImageIfNeeded(id: String, from remoteURL: URL) async {
        if isCached(id: id) { return }
        do {
            let (data, response) = try await session.data(from: remoteURL)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return }
            try data.write(to: URL(fileURLWithPath: localPath(for: id)), options: .atomic)
        } catch {
            // Ignore cache failures to keep UI responsive.
        }
    }
}
