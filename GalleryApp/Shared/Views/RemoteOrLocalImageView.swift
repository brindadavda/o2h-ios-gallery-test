import SwiftUI
import Kingfisher

struct RemoteOrLocalImageView: View {
    let wallpaper: Wallpaper
    @State private var imageLoadStage: ImageLoadStage = .display

    var body: some View {
        Group {
            switch imageLoadStage {
            case .display:
                imageView(for: wallpaper.displayURL)
            case .remote:
                imageView(for: wallpaper.remoteURL)
            case .systemFallback:
                fallbackView
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onChange(of: wallpaper.displayURL) { _, _ in
            imageLoadStage = .display
        }
    }

    private func imageView(for url: URL) -> some View {
        KFImage(url)
            .placeholder {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
            }
            .onFailure { _ in
                handleImageFailure()
            }
            .resizable()
            .fade(duration: 0.3)
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .clipped()
    }

    private func handleImageFailure() {
        switch imageLoadStage {
        case .display:
            if wallpaper.displayURL != wallpaper.remoteURL {
                imageLoadStage = .remote
            } else {
                imageLoadStage = .systemFallback
            }
        case .remote, .systemFallback:
            imageLoadStage = .systemFallback
        }
    }

    private var fallbackView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
    }
}

private enum ImageLoadStage {
    case display
    case remote
    case systemFallback
}
