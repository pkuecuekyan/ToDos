//
//  ListView.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import SwiftData
import SwiftUI

/// ListView showing ToDos, embedded within the app's main view
struct ListView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    @Query var todos: [Todo]

    @State private var sortOrder = [
        SortDescriptor(\Todo.isCompleted, order: .reverse), 
        SortDescriptor(\Todo.id, order: .reverse)
    ]

    @State private var filter = TodoFilter.completed

    @State private var newTodoTitle = ""
    
    // MARK: - Initializer
    
    init(filter: TodoFilter) {
        self._todos = Query(filter: filter.predicate, sort: sortOrder)
    }

    // MARK: - Main view
    
    var body: some View {
        List {
            ForEach(todos) { todo in
                row(for: todo)
            }
            .onDelete(perform: deleteTodos)
            newEntryRow()
        }
        .accessibilityIdentifier("toDoList")
    }
    
    // MARK: - View builders (private)
    
    private func row(for todo: Todo) -> some View {
        HStack {
            Image(
                systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle"
            )
            .accessibilityIdentifier("toDoCheck-\(todo.id)")
            .accessibilityLabel("To-Do Checkmark")
            .accessibilityValue("Tap to \(todo.isCompleted ? "uncheck" : "check")")
            .accessibilityAddTraits(.isToggle)
            .foregroundColor(
                todo.isCompleted ? .green : .gray
            )
            
            .onTapGesture {
                toggleTodoCompletion(todo)
            }
            if editMode?.wrappedValue == .inactive {
                Text(todo.title)
                    .accessibilityLabel("To-Do Entry")
                    .accessibilityValue(todo.title)
                    .accessibilityIdentifier("toDoText-\(todo.id)")
            } else {
                TextField(todo.title, text: Binding(
                    get: { todo.title },
                    set: {
                        TodoWriter.edit(
                            text: $0, for: todo, in: modelContext
                        )
                    }), axis: .vertical)
                .frame(maxHeight: .infinity)
                .accessibilityLabel("To-Do Edit Field")
                .accessibilityValue(todo.title)
                .accessibilityHint("Change your entry here")
                .accessibilityAddTraits(.isKeyboardKey)
                .accessibilityIdentifier("toDoEntry-\(todo.id)")
            }
            Spacer()
        }
        .accessibilityIdentifier("toDoRow")
    }
    
    private func newEntryRow() -> some View {
        HStack {
            Button(action: addTodo) {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier("addToDoButton")
            .disabled(newTodoTitle.isEmpty)
            TextField(
                "Add a task",
                text: $newTodoTitle,
                axis: .vertical
            )
            .accessibilityIdentifier("newToDoField")
//            .accessibilityLabel("To-Do New Entry Field")
//            .accessibilityHint("Type your to-do here")
        }
    }
    
    // MARK: - Action helpers (private)
    
    private func addTodo() {
        withAnimation {
            TodoWriter.add(newTodoTitle, into: modelContext)
            newTodoTitle = ""
        }
    }
    
    private func deleteTodos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                TodoWriter.delete(todos[index], in: modelContext)
            }
        }
    }
    
    private func toggleTodoCompletion(_ todo: Todo) {
        withAnimation {
            TodoWriter.toggle(todo)
        }
    }

}
