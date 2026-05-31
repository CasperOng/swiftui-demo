import SwiftUI

/// A colored rounded-square SF Symbol tile, matching the icons next to each
/// row in the iOS/iPadOS Settings app. A 29pt square with a 6pt corner
/// radius, a white symbol centered inside, and a semantic color fill.
///
/// The tile is decorative — the row's text label carries the meaning — so it
/// is hidden from accessibility to avoid a redundant VoiceOver announcement.
struct SettingsIcon: View {
    let systemName: String
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 29, height: 29)
            .background(color, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            .accessibilityHidden(true)
    }
}

#Preview {
    NavigationStack {
        List {
            Section {
                Label {
                    Text("Wi-Fi")
                } icon: {
                    SettingsIcon(systemName: "wifi", color: .blue)
                }
                Label {
                    Text("Bluetooth")
                } icon: {
                    SettingsIcon(systemName: "antenna.radiowaves.left.and.right", color: .blue)
                }
                Label {
                    Text("Battery")
                } icon: {
                    SettingsIcon(systemName: "battery.100percent", color: .green)
                }
            }
        }
        .navigationTitle("Settings")
    }
}
