import SwiftUI

struct TypographyDemoView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        List {
            Section {
                LabeledContent("Current Size") {
                    Text(String(describing: dynamicTypeSize))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("All text styles below scale automatically with Dynamic Type. Go to Settings → Accessibility → Display & Text Size to test.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Display Styles") {
                TextStyleRow(name: ".largeTitle", style: .largeTitle)
                TextStyleRow(name: ".title", style: .title)
                TextStyleRow(name: ".title2", style: .title2)
                TextStyleRow(name: ".title3", style: .title3)
            }

            Section("Body Styles") {
                TextStyleRow(name: ".headline", style: .headline)
                TextStyleRow(name: ".subheadline", style: .subheadline)
                TextStyleRow(name: ".body", style: .body)
                TextStyleRow(name: ".callout", style: .callout)
            }

            Section("Utility Styles") {
                TextStyleRow(name: ".footnote", style: .footnote)
                TextStyleRow(name: ".caption", style: .caption)
                TextStyleRow(name: ".caption2", style: .caption2)
            }

            Section("Font Weights") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ultralight").fontWeight(.ultraLight)
                    Text("Thin").fontWeight(.thin)
                    Text("Light").fontWeight(.light)
                    Text("Regular").fontWeight(.regular)
                    Text("Medium").fontWeight(.medium)
                    Text("Semibold").fontWeight(.semibold)
                    Text("Bold").fontWeight(.bold)
                    Text("Heavy").fontWeight(.heavy)
                    Text("Black").fontWeight(.black)
                }
                .font(.body)
            }

            Section("Font Design") {
                Text("Default (SF Pro)")
                    .font(.body.width(.standard))
                Text("Rounded")
                    .font(.system(.body, design: .rounded))
                Text("Monospaced")
                    .font(.system(.body, design: .monospaced))
                Text("Serif")
                    .font(.system(.body, design: .serif))
            }

            Section("Text Formatting") {
                Text("**Bold** and *italic* and ~~strikethrough~~")
                Text("Kerning adjusted")
                    .kerning(3)
                Text("Tracking adjusted")
                    .tracking(3)
                Text("This text has a baseline offset")
                    .baselineOffset(10)
            }

            Section("Hierarchy Through Style") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Title")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("Secondary description text that provides context")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Tertiary metadata or timestamp")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, 4)
            }

            Section("Custom Font Scaling") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom font scaled relative to .body")
                        .font(.custom("Helvetica Neue", size: 17, relativeTo: .body))
                    Text("Custom font scaled relative to .caption")
                        .font(.custom("Helvetica Neue", size: 12, relativeTo: .caption))
                    Text("These scale with Dynamic Type because they use relativeTo:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Typography")
    }
}

private struct TextStyleRow: View {
    let name: String
    let style: Font.TextStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("The quick brown fox")
                .font(.system(style))
            Text(name)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        TypographyDemoView()
    }
}
