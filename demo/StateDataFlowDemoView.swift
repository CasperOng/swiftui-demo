//
//  StateDataFlowDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates state management and data flow patterns in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

// MARK: - Models
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

// MARK: - View Models
#if IOS17
@Observable
class TodoViewModel {
    var todos: [TodoItem] = []
    var newTodoTitle: String = ""

    func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todos.append(TodoItem(title: newTodoTitle, isCompleted: false))
        newTodoTitle = ""
    }

    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }

    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
    }
}
#else
// iOS 16 floor: the @Observable macro is iOS 17+, so fall back to ObservableObject.
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var newTodoTitle: String = ""

    func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todos.append(TodoItem(title: newTodoTitle, isCompleted: false))
        newTodoTitle = ""
    }

    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }

    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
    }
}
#endif

// MARK: - Views
struct StateDataFlowDemoView: View {
    #if IOS17
    @State private var todoViewModel = TodoViewModel()
    #else
    @StateObject private var todoViewModel = TodoViewModel()
    #endif
    @State private var showingAddSheet = false
    @State private var selectedFilter: TodoFilter = .all

    enum TodoFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Done"
    }

    var filteredTodos: [TodoItem] {
        switch selectedFilter {
        case .all:
            return todoViewModel.todos
        case .active:
            return todoViewModel.todos.filter { !$0.isCompleted }
        case .completed:
            return todoViewModel.todos.filter { $0.isCompleted }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Filter Picker
            Picker("Filter", selection: $selectedFilter) {
                ForEach(TodoFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // Todo List
            List {
                if filteredTodos.isEmpty {
                    #if IOS17
                    ContentUnavailableView {
                        Label("No Todos", systemImage: "checklist")
                    } description: {
                        Text("Add a todo to get started.")
                    }
                    #else
                    ContentUnavailableMessage(
                        title: "No Todos",
                        systemImage: "checklist",
                        message: "Add a todo to get started."
                    )
                    #endif
                } else {
                    ForEach(filteredTodos) { todo in
                        TodoRowView(todo: todo, viewModel: todoViewModel)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("State & Data Flow")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add todo")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddTodoView(viewModel: todoViewModel)
                .presentationDetents([.medium])
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let viewModel: TodoViewModel

    var body: some View {
        HStack {
            Button {
                viewModel.toggleTodo(todo)
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .frame(minWidth: 44, minHeight: 44)
            .accessibilityLabel(todo.isCompleted ? "Mark as incomplete" : "Mark as complete")

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .secondary : .primary)

            Spacer()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.deleteTodo(todo)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct AddTodoView: View {
    #if IOS17
    let viewModel: TodoViewModel
    #else
    @ObservedObject var viewModel: TodoViewModel
    #endif
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool

    private var titleBinding: Binding<String> {
        #if IOS17
        return Bindable(viewModel).newTodoTitle
        #else
        return $viewModel.newTodoTitle
        #endif
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("What do you need to do?", text: titleBinding)
                    .focused($isFocused)
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTodo()
                        dismiss()
                    }
                    .disabled(viewModel.newTodoTitle.isEmpty)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        StateDataFlowDemoView()
    }
}
