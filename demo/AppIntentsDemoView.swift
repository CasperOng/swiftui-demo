import SwiftUI

struct AppIntentsDemoView: View {
    var body: some View {
        List {
            Section {
                Text("App Intents expose your app's actions to Siri, Shortcuts, Spotlight, and the Action button. You define an intent once and the system surfaces it everywhere, with parameters, confirmation, and result dialogs.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
            }

            Section("Anatomy of an Intent") {
                LabeledContent("Protocol", value: "AppIntent")
                LabeledContent("Title", value: "LocalizedStringResource")
                LabeledContent("Parameters", value: "@Parameter")
                LabeledContent("Action", value: "perform() async")
            }

            Section("Example") {
                Text(
                    """
                    struct LogWaterIntent: AppIntent {
                        static let title: LocalizedStringResource = "Log Water"

                        @Parameter(title: "Amount")
                        var milliliters: Int

                        func perform() async throws -> some IntentResult {
                            Store.shared.addWater(milliliters)
                            return .result()
                        }
                    }
                    """
                )
                .font(.caption.monospaced())
                .foregroundStyle(.primary)
                .padding(.vertical, 4)
            }

            Section("Surfaces") {
                Label("Siri & voice requests", systemImage: "mic.fill")
                Label("Shortcuts app & automations", systemImage: "square.stack.3d.up.fill")
                Label("Spotlight suggestions", systemImage: "magnifyingglass")
                Label("Action button (on supported devices)", systemImage: "button.horizontal.top.press")
            }

            Section {
                Text("Register an AppShortcutsProvider so your most common intents appear automatically without user setup. Keep titles short and verb-led so they read naturally as spoken phrases.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("App Intents")
    }
}

#Preview {
    NavigationStack {
        AppIntentsDemoView()
    }
}
