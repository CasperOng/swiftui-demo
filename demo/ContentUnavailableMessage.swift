import SwiftUI

/// A lightweight stand-in for `ContentUnavailableView`, which is only available
/// on iOS 17+. Used by screens that need an empty/unavailable state on the
/// iOS 16 build floor where the system view does not exist.
struct ContentUnavailableMessage: View {
    let title: String
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}

#Preview {
    ContentUnavailableMessage(
        title: "Nothing Here",
        systemImage: "tray",
        message: "There is no content to display right now."
    )
}
