import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }
}
