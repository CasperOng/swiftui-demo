import SwiftUI

struct SFSymbolsDemoView: View {
    @State private var symbolName = "star.fill"
    @State private var selectedRendering: SymbolRenderingOption = .monochrome
    @State private var symbolWeight: Font.Weight = .regular
    @State private var variableValue: Double = 0.5
    @State private var isBouncing = false

    enum SymbolRenderingOption: String, CaseIterable {
        case monochrome = "Mono"
        case hierarchical = "Hierarchical"
        case palette = "Palette"
        case multicolor = "Multicolor"
    }

    let showcaseSymbols: [(name: String, category: String)] = [
        ("house.fill", "System"),
        ("person.crop.circle.fill", "People"),
        ("gearshape.fill", "Settings"),
        ("bell.badge.fill", "Notifications"),
        ("heart.fill", "Health"),
        ("map.fill", "Maps"),
        ("camera.fill", "Camera"),
        ("music.note", "Media"),
        ("wifi", "Connectivity"),
        ("battery.100percent.bolt", "Device"),
        ("cloud.sun.fill", "Weather"),
        ("folder.badge.plus", "Files"),
    ]

    var body: some View {
        List {
            Section("Live Preview") {
                VStack(spacing: 16) {
                    symbolView
                        .font(.system(size: 60, weight: symbolWeight))
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        #if IOS17
                        .symbolEffect(.bounce, value: isBouncing)
                        #endif

                    Text(symbolName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospaced()
                }
                .padding(.vertical)
            }

            Section("Rendering Mode") {
                Picker("Rendering", selection: $selectedRendering) {
                    ForEach(SymbolRenderingOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Weight") {
                Picker("Weight", selection: $symbolWeight) {
                    Text("Ultra Light").tag(Font.Weight.ultraLight)
                    Text("Light").tag(Font.Weight.light)
                    Text("Regular").tag(Font.Weight.regular)
                    Text("Medium").tag(Font.Weight.medium)
                    Text("Semibold").tag(Font.Weight.semibold)
                    Text("Bold").tag(Font.Weight.bold)
                    Text("Heavy").tag(Font.Weight.heavy)
                }
            }

            Section("Variable Value") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 16) {
                        Image(systemName: "speaker.wave.3.fill", variableValue: variableValue)
                            .font(.title)
                            .foregroundStyle(.tint)
                        Image(systemName: "wifi", variableValue: variableValue)
                            .font(.title)
                            .foregroundStyle(.tint)
                        Image(systemName: "chart.bar.fill", variableValue: variableValue)
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
                    Slider(value: $variableValue, in: 0...1)
                    Text("Variable value: \(String(format: "%.2f", variableValue))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            #if IOS17
            Section("Symbol Effects (iOS 17+)") {
                Button("Bounce") {
                    isBouncing.toggle()
                }

                HStack(spacing: 24) {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .symbolEffect(.pulse, isActive: true)
                    #if IOS18
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .symbolEffect(.rotate, isActive: true)
                    #endif
                    Image(systemName: "wifi")
                        .font(.title2)
                        .symbolEffect(.variableColor.iterative, isActive: true)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            #endif

            Section("Symbol Catalog") {
                ForEach(showcaseSymbols, id: \.name) { symbol in
                    Button {
                        symbolName = symbol.name
                    } label: {
                        HStack {
                            Image(systemName: symbol.name)
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                                .foregroundStyle(.tint)
                                .frame(width: 32)
                            Text(symbol.name)
                                .font(.caption)
                                .monospaced()
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(symbol.category)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("SF Symbols")
    }

    @ViewBuilder
    private var symbolView: some View {
        switch selectedRendering {
        case .monochrome:
            Image(systemName: symbolName)
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.tint)
        case .hierarchical:
            Image(systemName: symbolName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.tint)
        case .palette:
            Image(systemName: symbolName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .orange)
        case .multicolor:
            Image(systemName: symbolName)
                .symbolRenderingMode(.multicolor)
        }
    }
}

#Preview {
    NavigationStack {
        SFSymbolsDemoView()
    }
}
