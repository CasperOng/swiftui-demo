import SwiftUI

struct ScrollViewDemoView: View {
    #if IOS17
    @State private var scrollPosition: Int?
    #endif
    @State private var showsIndicators = true

    var body: some View {
        List {
            verticalSection
            horizontalSection
            #if IOS17
            scrollPositionSection
            pagingSection
            #endif
            optionsSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("ScrollView")
    }

    private var verticalSection: some View {
        Section("Vertical ScrollView") {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<20) { index in
                        HStack {
                            Image(systemName: "\(index + 1).circle.fill")
                                .font(.title3)
                                .foregroundStyle(.tint)
                            Text("Row \(index + 1)")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 200)
            .scrollIndicators(showsIndicators ? .visible : .hidden)
        }
    }

    private var horizontalSection: some View {
        Section("Horizontal ScrollView") {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(0..<15) { index in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hue: Double(index) / 15.0, saturation: 0.5, brightness: 0.9))
                                .frame(width: 120, height: 120)
                            Text("Card \(index + 1)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }
        }
    }

    #if IOS17
    private var scrollPositionSection: some View {
        Section("Scroll Position (iOS 17+)") {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(0..<30) { index in
                        Text("Item \(index + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(scrollPosition == index ? Color.accentColor.opacity(0.15) : Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .id(index)
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 200)
            .scrollPosition(id: $scrollPosition)

            HStack {
                Button("Top") {
                    withAnimation { scrollPosition = 0 }
                }
                .buttonStyle(.bordered)

                Button("Middle") {
                    withAnimation { scrollPosition = 15 }
                }
                .buttonStyle(.bordered)

                Button("Bottom") {
                    withAnimation { scrollPosition = 29 }
                }
                .buttonStyle(.bordered)
            }

            if let pos = scrollPosition {
                LabeledContent("Current Position") {
                    Text("Item \(pos + 1)")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var pagingSection: some View {
        Section("Paging ScrollView") {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        VStack {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.tint)
                            Text("Page \(index + 1)")
                                .font(.headline)
                        }
                        .frame(width: 300, height: 150)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .frame(height: 160)
        }
    }
    #endif

    private var optionsSection: some View {
        Section {
            Toggle("Show Scroll Indicators", isOn: $showsIndicators)
        } header: {
            Text("Options")
        } footer: {
            Text("Use contentMargins, safeAreaPadding, and scrollClipDisabled for advanced scroll layouts.")
        }
    }
}

#Preview {
    NavigationStack {
        ScrollViewDemoView()
    }
}
