import SwiftUI

struct HapticsDemoView: View {
    @State private var lastTriggered = ""

    var body: some View {
        List {
            Section {
                Text("Haptic feedback provides tactile responses to user actions. Use them sparingly for meaningful interactions — not every tap needs a haptic.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Impact Feedback") {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    lastTriggered = "Impact: Light"
                } label: {
                    Label("Light Impact", systemImage: "hand.tap")
                }

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    lastTriggered = "Impact: Medium"
                } label: {
                    Label("Medium Impact", systemImage: "hand.tap.fill")
                }

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    lastTriggered = "Impact: Heavy"
                } label: {
                    Label("Heavy Impact", systemImage: "hand.point.up.braille.fill")
                }

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    lastTriggered = "Impact: Rigid"
                } label: {
                    Label("Rigid Impact", systemImage: "square.fill")
                }

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                    lastTriggered = "Impact: Soft"
                } label: {
                    Label("Soft Impact", systemImage: "circle.fill")
                }
            }

            Section("Notification Feedback") {
                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    lastTriggered = "Notification: Success"
                } label: {
                    Label("Success", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }

                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                    lastTriggered = "Notification: Warning"
                } label: {
                    Label("Warning", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }

                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                    lastTriggered = "Notification: Error"
                } label: {
                    Label("Error", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }

            Section("Selection Feedback") {
                Button {
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    lastTriggered = "Selection Changed"
                } label: {
                    Label("Selection Changed", systemImage: "hand.point.up.left.and.text")
                }

                Text("Used for picker scrolling, segment changes, and similar selection interactions.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("When to Use Haptics") {
                VStack(alignment: .leading, spacing: 12) {
                    HapticGuidelineRow(icon: "checkmark.circle", text: "Confirming an action (save, send, delete)")
                    HapticGuidelineRow(icon: "checkmark.circle", text: "Toggle state changes")
                    HapticGuidelineRow(icon: "checkmark.circle", text: "Reaching a boundary (end of scroll)")
                    HapticGuidelineRow(icon: "xmark.circle", text: "Every button tap")
                    HapticGuidelineRow(icon: "xmark.circle", text: "Continuous scrolling")
                    HapticGuidelineRow(icon: "xmark.circle", text: "Background events")
                }
                .padding(.vertical, 4)
            }

            if !lastTriggered.isEmpty {
                Section("Last Triggered") {
                    LabeledContent("Haptic") {
                        Text(lastTriggered)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Haptics")
    }
}

private struct HapticGuidelineRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(icon.contains("checkmark") ? .green : .red)
            Text(text)
                .font(.caption)
        }
    }
}

#Preview {
    NavigationStack {
        HapticsDemoView()
    }
}
