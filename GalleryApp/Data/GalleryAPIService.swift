import Foundation

protocol GalleryAPIServiceProtocol {
    func fetchImages(page: Int, limit: Int) async throws -> [Wallpaper]
}

final class GalleryAPIService: GalleryAPIServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchImages(page: Int, limit: Int) async throws -> [Wallpaper] {
        var components = URLComponents(string: "https://picsum.photos/v2/list")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        guard let url = components?.url else {
            throw AppError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw AppError.invalidResponse
        }

        let decoded = try JSONDecoder().decode([PicsumImageDTO].self, from: data)
        return decoded.map { $0.toDomain() }
    }
}
