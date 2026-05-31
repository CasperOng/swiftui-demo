import SwiftUI

struct ListsDemoView: View {
    @State private var selectedItems = Set<String>()
    @State private var searchText = ""
    
    let items = [
        "Item 1", "Item 2", "Item 3", "Item 4", "Item 5",
        "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"
    ]
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        List {
            Section("Basic List") {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
            
            Section("Selectable List") {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        if selectedItems.contains(item) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedItems.contains(item) {
                            selectedItems.remove(item)
                        } else {
                            selectedItems.insert(item)
                        }
                    }
                }
            }
            
            Section("Grid Layout") {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue.opacity(0.2))
                                .frame(height: 100)
                                .overlay(
                                    Text(item)
                                        .foregroundStyle(.blue)
                                )
                        }
                    }
                }
                .padding(.vertical)
            }
            
            Section("List with Swipe Actions") {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Delete action
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                // Edit action
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
            }
            
            Section("List with Context Menu") {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .contextMenu {
                            Button {
                                // Share action
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            
                            Button {
                                // Edit action
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                // Delete action
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("Lists & Grids")
        .searchable(text: $searchText, prompt: "Search items")
    }
}

#Preview {
    NavigationStack {
        ListsDemoView()
    }
} 