import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel: GalleryViewModel

    init(repository: GalleryRepository) {
        _viewModel = StateObject(wrappedValue: GalleryViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.wallpapers) { wallpaper in
                        VStack(alignment: .leading, spacing: 8) {
                            RemoteOrLocalImageView(wallpaper: wallpaper)
                            Text(wallpaper.author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentItem: wallpaper)
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.vertical)
                    }
                }
                .padding()
            }
            .navigationTitle("Wallpapers")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                viewModel.bootstrap()
            }
            .overlay(alignment: .bottom) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom)
                }
            }
        }
    }
}
