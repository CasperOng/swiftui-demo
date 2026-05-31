import SwiftUI

struct ColorSystemDemoView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            Section {
                LabeledContent("Current Mode") {
                    Text(colorScheme == .dark ? "Dark" : "Light")
                        .foregroundStyle(.secondary)
                }
            } footer: {
                Text("All colors below adapt automatically to Light and Dark Mode. Use semantic colors instead of hardcoded values.")
            }

            Section("Foreground Styles") {
                ColorRow(name: ".primary", color: .primary)
                ColorRow(name: ".secondary", color: .secondary)
                HStack {
                    Text(".tertiary")
                        .font(.caption)
                    Spacer()
                    Text("Sample")
                        .foregroundStyle(.tertiary)
                }
                HStack {
                    Text(".quaternary")
                        .font(.caption)
                    Spacer()
                    Text("Sample")
                        .foregroundStyle(.quaternary)
                }
            }

            Section("Background Hierarchy") {
                SystemColorRow(name: "systemBackground", uiColor: .systemBackground)
                SystemColorRow(name: "secondarySystemBackground", uiColor: .secondarySystemBackground)
                SystemColorRow(name: "tertiarySystemBackground", uiColor: .tertiarySystemBackground)
            }

            Section("Grouped Background Hierarchy") {
                SystemColorRow(name: "systemGroupedBackground", uiColor: .systemGroupedBackground)
                SystemColorRow(name: "secondarySystemGroupedBackground", uiColor: .secondarySystemGroupedBackground)
                SystemColorRow(name: "tertiarySystemGroupedBackground", uiColor: .tertiarySystemGroupedBackground)
            }

            Section("Label Colors") {
                SystemColorRow(name: "label", uiColor: .label)
                SystemColorRow(name: "secondaryLabel", uiColor: .secondaryLabel)
                SystemColorRow(name: "tertiaryLabel", uiColor: .tertiaryLabel)
                SystemColorRow(name: "quaternaryLabel", uiColor: .quaternaryLabel)
            }

            Section("System Colors") {
                HStack(spacing: 8) {
                    ForEach(systemColors, id: \.name) { item in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 28, height: 28)
                            Text(item.name)
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            Section("Separator & Fill") {
                SystemColorRow(name: "separator", uiColor: .separator)
                SystemColorRow(name: "opaqueSeparator", uiColor: .opaqueSeparator)
                SystemColorRow(name: "systemFill", uiColor: .systemFill)
                SystemColorRow(name: "secondarySystemFill", uiColor: .secondarySystemFill)
                SystemColorRow(name: "tertiarySystemFill", uiColor: .tertiarySystemFill)
            }

            Section {
                HStack {
                    Text("Current tint")
                        .font(.caption)
                    Spacer()
                    Circle()
                        .fill(.tint)
                        .frame(width: 24, height: 24)
                }
            } header: {
                Text("Tint / Accent Color")
            } footer: {
                Text("Set a single accent color via .tint() on the app root. All interactive elements inherit it.")
            }

            Section("Contrast Ratios") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("WCAG AA requires 4.5:1 for normal text, 3:1 for large text (18pt+ or 14pt+ bold).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 12) {
                        Text("Pass")
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.green.opacity(0.2))
                            .clipShape(Capsule())
                        Text("Primary on Background")
                            .font(.caption)
                    }
                    HStack(spacing: 12) {
                        Text("Caution")
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.orange.opacity(0.2))
                            .clipShape(Capsule())
                        Text("Tertiary on Background")
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Color System")
    }

    private var systemColors: [(name: String, color: Color)] {
        [
            ("Red", .red), ("Orange", .orange), ("Yellow", .yellow),
            ("Green", .green), ("Mint", .mint), ("Teal", .teal),
            ("Cyan", .cyan), ("Blue", .blue), ("Indigo", .indigo),
            ("Purple", .purple), ("Pink", .pink), ("Brown", .brown)
        ]
    }
}

private struct ColorRow: View {
    let name: String
    let color: Color

    var body: some View {
        HStack {
            Text(name)
                .font(.caption)
            Spacer()
            Text("Sample Text")
                .foregroundStyle(color)
        }
    }
}

private struct SystemColorRow: View {
    let name: String
    let uiColor: UIColor

    var body: some View {
        HStack {
            Text(".\(name)")
                .font(.caption.monospaced())
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(uiColor))
                .frame(width: 60, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
        }
    }
}

#Preview {
    NavigationStack {
        ColorSystemDemoView()
    }
}
