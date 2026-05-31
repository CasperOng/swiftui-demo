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

// MARK: - Views
struct StateDataFlowDemoView: View {
    @StateObject private var todoViewModel = TodoViewModel()
    @State private var showingAddSheet = false
    @State private var selectedFilter: TodoFilter = .all
    
    enum TodoFilter {
        case all, active, completed
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
        VStack {
            // Filter Picker
            Picker("Filter", selection: $selectedFilter) {
                Text("All").tag(TodoFilter.all)
                Text("Active").tag(TodoFilter.active)
                Text("Completed").tag(TodoFilter.completed)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Todo List
            List {
                ForEach(filteredTodos) { todo in
                    TodoRowView(todo: todo, viewModel: todoViewModel)
                }
            }
            
            // Add Todo Button
            Button(action: { showingAddSheet = true }) {
                Label("Add Todo", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("State & Data Flow")
        .sheet(isPresented: $showingAddSheet) {
            AddTodoView(viewModel: todoViewModel)
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isCompleted ? .green : .gray)
                .onTapGesture {
                    viewModel.toggleTodo(todo)
                }
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
            
            Spacer()
            
            Button(action: { viewModel.deleteTodo(todo) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Todo Title", text: $viewModel.newTodoTitle)
            }
            .navigationTitle("New Todo")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    viewModel.addTodo()
                    dismiss()
                }
                .disabled(viewModel.newTodoTitle.isEmpty)
            )
        }
    }
}

#Preview {
    NavigationStack {
        StateDataFlowDemoView()
    }
} 