import SwiftUI

struct SearchableDemoView: View {
    @State private var searchText = ""
    @State private var searchScope: SearchScope = .all
    @State private var searchTokens: [SearchToken] = []
    @State private var isSearching = false

    enum SearchScope: String, CaseIterable {
        case all = "All"
        case fruits = "Fruits"
        case vegetables = "Vegetables"
    }

    struct SearchToken: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let icon: String
    }

    let allItems: [(name: String, category: String, icon: String)] = [
        ("Apple", "Fruits", "apple.logo"),
        ("Banana", "Fruits", "leaf"),
        ("Cherry", "Fruits", "leaf"),
        ("Mango", "Fruits", "leaf"),
        ("Orange", "Fruits", "leaf"),
        ("Strawberry", "Fruits", "leaf"),
        ("Carrot", "Vegetables", "carrot"),
        ("Broccoli", "Vegetables", "leaf.fill"),
        ("Spinach", "Vegetables", "leaf.fill"),
        ("Tomato", "Vegetables", "leaf.fill"),
        ("Pepper", "Vegetables", "leaf.fill"),
        ("Onion", "Vegetables", "leaf.fill"),
    ]

    let suggestedSearches = ["Popular", "Seasonal", "Organic"]

    var filteredItems: [(name: String, category: String, icon: String)] {
        var items = allItems

        // Filter by scope
        if searchScope != .all {
            items = items.filter { $0.category == searchScope.rawValue }
        }

        // Filter by search text
        if !searchText.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        return items
    }

    var body: some View {
        List {
            if filteredItems.isEmpty {
                #if IOS17
                ContentUnavailableView.search(text: searchText)
                #else
                ContentUnavailableMessage(
                    title: "No Results",
                    systemImage: "magnifyingglass",
                    message: searchText.isEmpty ? "Start typing to search items." : "No items match \"\(searchText)\"."
                )
                #endif
            } else {
                Section("Results (\(filteredItems.count))") {
                    ForEach(filteredItems, id: \.name) { item in
                        Label(item.name, systemImage: item.icon)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Search")
        #if IOS17
        .searchable(text: $searchText, tokens: $searchTokens, prompt: "Search items") { token in
            Label(token.name, systemImage: token.icon)
        }
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue).tag(scope)
            }
        }
        .searchSuggestions {
            if searchText.isEmpty {
                Section("Suggested") {
                    ForEach(suggestedSearches, id: \.self) { suggestion in
                        Label(suggestion, systemImage: "magnifyingglass")
                            .searchCompletion(suggestion)
                    }
                }

                Section("Recent") {
                    Label("Apple", systemImage: "clock")
                        .searchCompletion("Apple")
                    Label("Carrot", systemImage: "clock")
                        .searchCompletion("Carrot")
                }
            }
        }
        #else
        .searchable(text: $searchText, prompt: "Search items")
        #endif
    }
}

#Preview {
    NavigationStack {
        SearchableDemoView()
    }
}
