import Foundation

protocol AuthService {
    func restoreSession() async -> UserProfile?
    func saveSession(user: UserProfile) async
    func logout() async
}

protocol GalleryRepository {
    func fetchPage(page: Int, pageSize: Int) async throws -> [Wallpaper]
    func loadCachedWallpapers() async -> [Wallpaper]
}
