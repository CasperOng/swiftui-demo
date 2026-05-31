import SwiftUI

struct LiveActivityDemoView: View {
    @State private var progress: Double = 0.6

    var body: some View {
        List {
            Section {
                lockScreenActivity
                    .padding(.vertical, 4)
            } header: {
                Text("Lock Screen Presentation")
            } footer: {
                Text("Live Activities show real-time information on the Lock Screen and in the Dynamic Island. They run with ActivityKit and WidgetKit in a widget extension, so these are static design previews of the layouts.")
            }

            Section("Dynamic Island — Compact") {
                HStack {
                    Spacer()
                    dynamicIslandCompact
                    Spacer()
                }
                .padding(.vertical, 8)
            }

            Section("Dynamic Island — Expanded") {
                dynamicIslandExpanded
                    .padding(.vertical, 4)
            }

            Section {
                Slider(value: $progress, in: 0...1)
                    .accessibilityLabel("Adjust delivery progress")
            } header: {
                Text("Progress")
            } footer: {
                Text("Update Live Activities frequently enough to stay useful, but respect the system budget. Always provide a meaningful compact and minimal presentation for the Dynamic Island.")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Live Activities")
    }

    private var lockScreenActivity: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Delivery", systemImage: "shippingbox.fill")
                    .font(.headline)
                    .foregroundStyle(.tint)
                Spacer()
                Text("12 min")
                    .font(.headline)
                    .monospacedDigit()
            }
            ProgressView(value: progress)
                .tint(.green)
            HStack {
                Text("Preparing")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Out for delivery")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lock Screen Live Activity, delivery in 12 minutes")
    }

    private var dynamicIslandCompact: some View {
        HStack(spacing: 8) {
            Image(systemName: "shippingbox.fill")
                .foregroundStyle(.green)
            Text("12 min")
                .font(.callout.bold())
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.black, in: Capsule())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Dynamic Island compact, 12 minutes remaining")
    }

    private var dynamicIslandExpanded: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Delivery")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Arriving soon")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "shippingbox.fill")
                    .font(.title)
                    .foregroundStyle(.green)
            }
            ProgressView(value: progress)
                .tint(.green)
            Text("12 minutes remaining")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.black, in: RoundedRectangle(cornerRadius: 24))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Dynamic Island expanded, delivery arriving soon, 12 minutes remaining")
    }
}

#Preview {
    NavigationStack {
        LiveActivityDemoView()
    }
}
