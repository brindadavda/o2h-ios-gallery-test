import Foundation
import Combine
import GoogleSignIn

@MainActor
final class AppEnvironment: ObservableObject {
  
    @Published  var currentUser: UserProfile?

    let authService: AuthService
    let galleryRepository: GalleryRepository

    init(
        authService: AuthService = GoogleAuthService(),
        galleryRepository: GalleryRepository = DefaultGalleryRepository(
            apiService: GalleryAPIService(),
            persistence: .shared,
            imageCache: ImageFileCache()
        )
    ) {
        self.authService = authService
        self.galleryRepository = galleryRepository
    }

    func bootstrap() async {
        currentUser = await authService.restoreSession()
    }

    func saveSession(for user: UserProfile) async {
        await authService.saveSession(user: user)
        currentUser = user
    }

    func logout() async {
        GIDSignIn.sharedInstance.signOut()
        await authService.logout()
        currentUser = nil
    }
}
