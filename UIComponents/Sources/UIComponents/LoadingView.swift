import SwiftUI

public struct LoadingView: View {
    private let message: String

    public init(message: String = "Загрузка…") {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
