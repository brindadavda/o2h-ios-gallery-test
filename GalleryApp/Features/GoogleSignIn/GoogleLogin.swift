//
//  GoogleLogin.swift
//  GalleryApp
//
//  Created by Enpointe on 16/04/26.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct GoogleLogin: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            GoogleSignInButton(action: handleSignInButton)
                .padding()
                .disabled(viewModel.isLoading)
        }
    }

    @MainActor
    func handleSignInButton() {
        guard !viewModel.isLoading else { return }
        viewModel.isLoading = true
        viewModel.errorMessage = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            viewModel.isLoading = false
            viewModel.errorMessage = "No active window scene found."
            return
        }

        guard
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            viewModel.isLoading = false
            viewModel.errorMessage = "Could not find a root view controller."
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult else {
                Task { @MainActor in
                    viewModel.isLoading = false
                    viewModel.errorMessage = error?.localizedDescription ?? "Google sign-in failed."
                }
                return
            }

            let googleUser = result.user
            let profile = UserProfile(
                id: googleUser.userID ?? "",
                name: googleUser.profile?.name ?? googleUser.profile?.givenName ?? "",
                email: googleUser.profile?.email ?? "",
                avatarURL: googleUser.profile?.imageURL(withDimension: 128)
            )

            Task { @MainActor in
                await viewModel.environment.saveSession(for: profile)
                viewModel.isLoading = false
            }
        }
    }
}

#Preview {
    @StateObject var viewModel = LoginViewModel(environment: .init())

    GoogleLogin(viewModel: viewModel)
}
