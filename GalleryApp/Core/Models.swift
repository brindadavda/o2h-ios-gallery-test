import Foundation
import CoreGraphics

struct UserProfile: Equatable {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
}

struct Wallpaper: Identifiable, Equatable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let remoteURL: URL
    var localFilePath: String?

    var displayURL: URL {
        if let localFilePath {
            return URL(fileURLWithPath: localFilePath)
        }
        return remoteURL
    }

    var aspectRatio: CGFloat {
        guard height > 0 else { return 1 }
        return CGFloat(width) / CGFloat(height)
    }
}

struct PicsumImageDTO: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let downloadURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case downloadURL = "download_url"
    }

    func toDomain() -> Wallpaper {
        Wallpaper(
            id: id,
            author: author,
            width: width,
            height: height,
            remoteURL: downloadURL,
            localFilePath: nil
        )
    }
}
