import SwiftUI

@main
struct GalleryAppApp: App {
    @StateObject private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(environment)
                .task {
                    await environment.bootstrap()
                }
        }
    }
}
