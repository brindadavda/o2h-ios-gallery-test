import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    var user: UserProfile? {
        environment.currentUser
    }

    func logout() {
        Task {
            await environment.logout()
        }
    }
}
