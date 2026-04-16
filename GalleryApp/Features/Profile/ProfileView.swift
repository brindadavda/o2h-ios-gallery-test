import SwiftUI

struct ProfileView: View {
    @ObservedObject var environment: AppEnvironment
    @StateObject private var viewModel: ProfileViewModel
    @State private var isLogoutAlertPresented = false

    init(environment: AppEnvironment) {
        self.environment = environment
        _viewModel = StateObject(wrappedValue: ProfileViewModel(environment: environment))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 78))
                    .foregroundStyle(.blue)

                Text(viewModel.user?.name ?? "Guest")
                    .font(.title2.bold())

                Text(viewModel.user?.email ?? "-")
                    .foregroundStyle(.secondary)

                Button(role: .destructive) {
                    isLogoutAlertPresented = true
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)

                Spacer()
            }
            .padding(24)
            .navigationTitle("Profile")
            .alert("Log out?", isPresented: $isLogoutAlertPresented) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    viewModel.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}
