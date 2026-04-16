import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(environment: environment))
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "photo.stack")
                .font(.system(size: 54))
                .foregroundStyle(.blue)

            Text("Gallery App")
                .font(.largeTitle.bold())

            Text("Sign in with Google to view wallpapers")
                .foregroundStyle(.secondary)

            GoogleLogin(viewModel: viewModel)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(24)
    }
}
