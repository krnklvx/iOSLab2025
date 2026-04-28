import SwiftUI

public struct UserCardView: View {
    private let name: String
    private let email: String
    private let detail: String
    private let imageURL: URL?

    public init(name: String, email: String, detail: String, imageURL: URL?) {
        self.name = name
        self.email = email
        self.detail = detail
        self.imageURL = imageURL
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImageView(url: imageURL, size: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}
