import SwiftUI

struct MenusDemoView: View {
    @State private var selectedFruit = "Apple"
    @State private var sortOrder = "Name"
    @State private var isBookmarked = false

    let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]

    var body: some View {
        List {
            Section {
                Menu("Sort By") {
                    Button {
                        sortOrder = "Name"
                    } label: {
                        Label("Name", systemImage: sortOrder == "Name" ? "checkmark" : "")
                    }
                    Button {
                        sortOrder = "Date"
                    } label: {
                        Label("Date", systemImage: sortOrder == "Date" ? "checkmark" : "")
                    }
                    Button {
                        sortOrder = "Size"
                    } label: {
                        Label("Size", systemImage: sortOrder == "Size" ? "checkmark" : "")
                    }
                }

                LabeledContent("Current Sort") {
                    Text(sortOrder)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Pull-Down Menu Button")
            } footer: {
                Text("Menus provide secondary actions without cluttering the interface. Use context menus for long-press, pull-down menus for toolbar actions, and Menu buttons for inline choices.")
            }

            Section("Menu with Sections") {
                Menu("Actions") {
                    Section("Edit") {
                        Button { } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        Button { } label: {
                            Label("Paste", systemImage: "doc.on.clipboard")
                        }
                    }

                    Section("Share") {
                        Button { } label: {
                            Label("AirDrop", systemImage: "airplayaudio")
                        }
                        Button { } label: {
                            Label("Messages", systemImage: "message")
                        }
                    }

                    Section {
                        Button(role: .destructive) { } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }

            Section("Picker as Menu") {
                Picker("Favorite Fruit", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { fruit in
                        Text(fruit).tag(fruit)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Context Menu") {
                ForEach(fruits, id: \.self) { fruit in
                    Text(fruit)
                        .contextMenu {
                            Button {
                                selectedFruit = fruit
                            } label: {
                                Label("Select", systemImage: "checkmark.circle")
                            }

                            Button { } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }

                            Divider()

                            Button(role: .destructive) { } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        } preview: {
                            VStack(spacing: 8) {
                                Image(systemName: "leaf.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.green)
                                Text(fruit)
                                    .font(.headline)
                            }
                            .padding(24)
                        }
                }
            }

            Section("Menu with Primary Action") {
                Menu {
                    Button { } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    Button { } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Label("More Options", systemImage: "ellipsis.circle")
                } primaryAction: {
                    isBookmarked.toggle()
                }

                LabeledContent("Bookmarked") {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(isBookmarked ? Color.accentColor : Color.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Menus")
    }
}

#Preview {
    NavigationStack {
        MenusDemoView()
    }
}
