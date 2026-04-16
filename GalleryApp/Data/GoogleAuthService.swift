import Foundation

final class GoogleAuthService: AuthService {
    private let defaults = UserDefaults.standard
    private let sessionUserKey = "session_user"

    func restoreSession() async -> UserProfile? {
        guard
            let data = defaults.data(forKey: sessionUserKey),
            let user = try? JSONDecoder().decode(StoredUser.self, from: data)
        else {
            return nil
        }

        return UserProfile(id: user.id, name: user.name, email: user.email, avatarURL: URL(string: user.avatarURL ?? ""))
    }

    func logout() async {
        defaults.removeObject(forKey: sessionUserKey)
    }

    func saveSession(user: UserProfile) async {
        persist(user: user)
    }

    private func persist(user: UserProfile) {
        let stored = StoredUser(
            id: user.id,
            name: user.name,
            email: user.email,
            avatarURL: user.avatarURL?.absoluteString
        )

        if let data = try? JSONEncoder().encode(stored) {
            defaults.set(data, forKey: sessionUserKey)
        }
    }
}

private struct StoredUser: Codable {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?
}
