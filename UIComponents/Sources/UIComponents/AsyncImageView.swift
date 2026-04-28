import SwiftUI

public struct AsyncImageView: View {
    private let url: URL?
    private let size: CGFloat

    public init(url: URL?, size: CGFloat = 44) {
        self.url = url
        self.size = size
    }

    public var body: some View {
        AsyncImage(url: url) { phase in //замыкание с 3мя состояниями
            switch phase {
            case .empty:
                ProgressView()
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "person.fill")
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
