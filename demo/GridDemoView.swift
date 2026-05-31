import SwiftUI

struct GridDemoView: View {
    @State private var columns = 3
    @State private var spacing: CGFloat = 12

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Controls
                VStack(spacing: 16) {
                    Stepper("Columns: \(columns)", value: $columns, in: 1...5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spacing: \(Int(spacing))pt")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Slider(value: $spacing, in: 0...32, step: 4)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // LazyVGrid
                VStack(alignment: .leading, spacing: 12) {
                    Text("LazyVGrid")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    LazyVGrid(columns: gridColumns, spacing: spacing) {
                        ForEach(0..<12) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hue: Double(index) / 12.0, saturation: 0.6, brightness: 0.9))
                                .frame(height: 80)
                                .overlay(
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                )
                                .accessibilityLabel("Grid item \(index + 1)")
                        }
                    }
                }

                // Adaptive Grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Adaptive Grid")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Text("Columns adapt to available width (min 80pt each)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 12)], spacing: 12) {
                        ForEach(0..<8) { index in
                            VStack(spacing: 4) {
                                Image(systemName: "square.fill")
                                    .font(.title)
                                    .foregroundStyle(.tint.opacity(0.7))
                                Text("Item")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                // LazyHGrid
                VStack(alignment: .leading, spacing: 12) {
                    Text("LazyHGrid (Horizontal)")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 12) {
                            ForEach(0..<20) { index in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.tint.opacity(0.3))
                                    .frame(width: 80)
                                    .overlay(
                                        Text("\(index + 1)")
                                            .font(.caption)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 132)
                }

                // ViewThatFits
                VStack(alignment: .leading, spacing: 12) {
                    Text("ViewThatFits")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Text("Automatically picks the layout that fits the available space")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ViewThatFits {
                        // Try horizontal first
                        HStack(spacing: 12) {
                            ForEach(0..<4) { i in
                                Label("Option \(i + 1)", systemImage: "star")
                                    .padding(8)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(Capsule())
                            }
                        }
                        // Fall back to vertical
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<4) { i in
                                Label("Option \(i + 1)", systemImage: "star")
                                    .padding(8)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Grids & Layout")
    }
}

#Preview {
    NavigationStack {
        GridDemoView()
    }
}
