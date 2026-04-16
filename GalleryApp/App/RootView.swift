import SwiftUI

struct RootView: View {
  @StateObject private var environment: AppEnvironment

  init() {
      _environment = StateObject(wrappedValue: AppEnvironment())
  }

    var body: some View {
        if environment.currentUser == nil {
            LoginView(environment: environment)
        } else {
            TabView {
                GalleryView(repository: environment.galleryRepository)
                    .tabItem {
                        Label("Gallery", systemImage: "photo.stack")
                    }

                ProfileView(environment: environment)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        }
    }
}
