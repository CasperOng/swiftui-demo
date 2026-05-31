import SwiftUI

struct DynamicTypeDemoView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    LabeledContent("Current Size") {
                        Text(sizeLabel)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.secondarySystemFill))
                            .clipShape(Capsule())
                    }
                    Text("Change text size in Settings → Accessibility → Display & Text Size → Larger Text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Layout Reflow") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("At accessibility sizes, horizontal layouts should reflow to vertical:")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ViewThatFits {
                        HStack(spacing: 16) {
                            iconLabel
                            detailText
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            iconLabel
                            detailText
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            Section("All Text Styles at Current Size") {
                Group {
                    DynamicTypeRow(label: "Large Title", style: .largeTitle)
                    DynamicTypeRow(label: "Title", style: .title)
                    DynamicTypeRow(label: "Title 2", style: .title2)
                    DynamicTypeRow(label: "Title 3", style: .title3)
                    DynamicTypeRow(label: "Headline", style: .headline)
                    DynamicTypeRow(label: "Body", style: .body)
                    DynamicTypeRow(label: "Callout", style: .callout)
                    DynamicTypeRow(label: "Subheadline", style: .subheadline)
                    DynamicTypeRow(label: "Footnote", style: .footnote)
                    DynamicTypeRow(label: "Caption", style: .caption)
                    DynamicTypeRow(label: "Caption 2", style: .caption2)
                }
            }

            Section("Accessibility Size Detection") {
                if dynamicTypeSize.isAccessibilitySize {
                    Label("Accessibility size is active", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Layouts should use vertical stacking and ensure no text is truncated.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Label("Standard size range", systemImage: "textformat.size")
                        .foregroundStyle(.secondary)
                    Text("Horizontal layouts are appropriate at this size.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Truncation vs. Wrapping") {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Correct — wraps naturally:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("This is a long piece of text that should wrap to multiple lines rather than being truncated, ensuring all content remains readable at any Dynamic Type size.")
                            .font(.body)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Incorrect — truncated (anti-pattern):")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("This text is truncated and the user cannot read the full content which is a violation of accessibility guidelines.")
                            .font(.body)
                            .lineLimit(1)
                            .foregroundStyle(.red.opacity(0.7))
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Minimum Sizes") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("11pt is the absolute minimum (caption2)")
                        .font(.caption2)
                    Text("Never go below 11pt for any text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Dynamic Type")
    }

    private var iconLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)
            Text("John Appleseed")
                .font(.headline)
        }
    }

    private var detailText: some View {
        Text("Senior iOS Developer at Apple Inc.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private var sizeLabel: String {
        switch dynamicTypeSize {
        case .xSmall: return "xSmall"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large (Default)"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        case .accessibility1: return "Accessibility 1"
        case .accessibility2: return "Accessibility 2"
        case .accessibility3: return "Accessibility 3"
        case .accessibility4: return "Accessibility 4"
        case .accessibility5: return "Accessibility 5"
        @unknown default: return "Unknown"
        }
    }
}

private struct DynamicTypeRow: View {
    let label: String
    let style: Font.TextStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Sample Text")
                .font(.system(style))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        DynamicTypeDemoView()
    }
}
