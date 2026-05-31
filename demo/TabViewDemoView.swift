import SwiftUI

struct TabViewDemoView: View {
    @State private var selectedTab = 0
    @State private var badgeCount = 3

    var body: some View {
        VStack(spacing: 24) {
            Text("TabView Patterns")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            Text("Tab bars provide top-level navigation for 3–5 sections. Each tab uses SF Symbols with filled variants for the selected state.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Embedded TabView preview
            TabView(selection: $selectedTab) {
                TabContentView(title: "Home", icon: "house.fill", description: "Primary content lives here")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                TabContentView(title: "Search", icon: "magnifyingglass", description: "Find content across the app")
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)

                TabContentView(title: "Favorites", icon: "heart.fill", description: "Your saved items appear here")
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                    .badge(badgeCount)
                    .tag(2)

                TabContentView(title: "Profile", icon: "person.fill", description: "Account and settings")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .padding(.horizontal)

            // Controls
            VStack(spacing: 16) {
                Stepper("Badge Count: \(badgeCount)", value: $badgeCount, in: 0...99)

                LabeledContent("Selected Tab") {
                    Text("\(selectedTab)")
                        .monospacedDigit()
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .navigationTitle("TabView")
    }
}

private struct TabContentView: View {
    let title: String
    let icon: String
    let description: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.tint)
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        TabViewDemoView()
    }
}
