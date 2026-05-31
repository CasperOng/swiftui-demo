import SwiftUI

struct WidgetPreviewDemoView: View {
    enum WidgetFamily: String, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
    }

    @State private var selectedFamily: WidgetFamily = .medium

    var body: some View {
        List {
            Section {
                Text("Widgets surface a glanceable slice of your app on the Home Screen, Lock Screen, and in StandBy. They render with WidgetKit and SwiftUI in a separate extension target, so these are static design previews of the supported families.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
            }

            Section("Family") {
                Picker("Widget Family", selection: $selectedFamily) {
                    ForEach(WidgetFamily.allCases, id: \.self) { family in
                        Text(family.rawValue).tag(family)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Preview") {
                widgetPreview
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }

            Section("Supported Families") {
                LabeledContent("systemSmall", value: "2×2")
                LabeledContent("systemMedium", value: "4×2")
                LabeledContent("systemLarge", value: "4×4")
                LabeledContent("accessoryRectangular", value: "Lock Screen")
                LabeledContent("accessoryCircular", value: "Lock Screen")
            }

            Section {
                Text("Keep widget content focused on a single piece of information. Use Link and widgetURL for deep links, and design for both light and dark appearances with semantic colors.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Widgets")
    }

    @ViewBuilder
    private var widgetPreview: some View {
        switch selectedFamily {
        case .small:
            widgetCard(width: 158, height: 158) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundStyle(.orange)
                    Spacer()
                    Text("1,248")
                        .font(.title2.bold())
                    Text("Active Calories")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        case .medium:
            widgetCard(width: 338, height: 158) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Today", systemImage: "calendar")
                            .font(.caption.bold())
                            .foregroundStyle(.tint)
                        Spacer()
                        Text("3 Events")
                            .font(.headline)
                        Text("Next: Standup at 10:00")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 44))
                        .foregroundStyle(.tint)
                }
            }
        case .large:
            widgetCard(width: 338, height: 338) {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Reminders", systemImage: "checklist")
                        .font(.headline)
                        .foregroundStyle(.tint)
                    ForEach(["Review PR", "Reply to email", "Plan sprint", "Update docs"], id: \.self) { item in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundStyle(.secondary)
                            Text(item)
                            Spacer()
                        }
                        .font(.subheadline)
                    }
                    Spacer()
                }
            }
        }
    }

    private func widgetCard<Content: View>(width: CGFloat, height: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .frame(width: width, height: height, alignment: .topLeading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(selectedFamily.rawValue) widget preview")
    }
}

#Preview {
    NavigationStack {
        WidgetPreviewDemoView()
    }
}
