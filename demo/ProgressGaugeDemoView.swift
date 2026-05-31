import SwiftUI

struct ProgressGaugeDemoView: View {
    @State private var progress: Double = 0.65
    @State private var isLoading = false

    var body: some View {
        List {
            Section("Linear Progress") {
                VStack(alignment: .leading, spacing: 12) {
                    ProgressView(value: progress) {
                        Text("Download Progress")
                    } currentValueLabel: {
                        Text("\(Int(progress * 100))%")
                    }

                    Slider(value: $progress, in: 0...1)
                        .accessibilityLabel("Adjust progress value")
                }
                .padding(.vertical, 4)
            }

            Section("Indeterminate Progress") {
                HStack(spacing: 16) {
                    ProgressView()
                        .accessibilityLabel("Loading")
                    Text("Loading content...")
                        .foregroundStyle(.secondary)
                }

                Button(isLoading ? "Stop" : "Start Loading") {
                    isLoading.toggle()
                }
                .buttonStyle(.bordered)
            }

            Section("Circular Progress") {
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        ProgressView(value: 0.3)
                            .progressViewStyle(.circular)
                        Text("30%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ProgressView(value: 0.7)
                            .progressViewStyle(.circular)
                        Text("70%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ProgressView(value: 1.0)
                            .progressViewStyle(.circular)
                        Text("100%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Gauge — Linear") {
                Gauge(value: progress) {
                    Text("Storage")
                } currentValueLabel: {
                    Text("\(Int(progress * 100))%")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .gaugeStyle(.linearCapacity)

                Gauge(value: 0.4, in: 0...1) {
                    Text("Battery")
                } currentValueLabel: {
                    Text("40%")
                }
                .gaugeStyle(.linearCapacity)
                .tint(.green)
            }

            Section("Gauge — Circular") {
                HStack(spacing: 32) {
                    Gauge(value: 0.75) {
                        Image(systemName: "heart.fill")
                    } currentValueLabel: {
                        Text("75")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.red)

                    Gauge(value: 0.5) {
                        Image(systemName: "bolt.fill")
                    } currentValueLabel: {
                        Text("50")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.yellow)

                    Gauge(value: 0.9) {
                        Image(systemName: "drop.fill")
                    } currentValueLabel: {
                        Text("90")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Gauge — Accessory") {
                HStack(spacing: 32) {
                    Gauge(value: 72, in: 0...100) {
                        Text("Speed")
                    } currentValueLabel: {
                        Text("72")
                    }
                    .gaugeStyle(.accessoryLinearCapacity)

                    Gauge(value: 0.6) {
                        Text("CPU")
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(.orange)
                }
                .padding(.vertical, 4)
            }

            Section("Tinted Progress") {
                VStack(spacing: 12) {
                    ProgressView(value: 0.8)
                        .tint(.green)
                    ProgressView(value: 0.5)
                        .tint(.orange)
                    ProgressView(value: 0.2)
                        .tint(.red)
                }
                .padding(.vertical, 4)
            }

            Section {
                Text("Use determinate progress (value:) when duration is known. Use indeterminate (no value) for unknown duration. Never block the entire screen with a spinner.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Progress & Gauges")
    }
}

#Preview {
    NavigationStack {
        ProgressGaugeDemoView()
    }
}
