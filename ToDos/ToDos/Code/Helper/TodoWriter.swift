//
//  TodoWriter.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Foundation
import SwiftData

/// Facilitates reading, writing, and updating of Todo entities
struct TodoWriter {
    
    // MARK: - CRUD functionality
    
    static func add(_ text: String, into context: ModelContext) {
        let newTodo = Todo(
            id: Todo.getNextTaskId(in: context),
            title: text
        )
        context.insert(newTodo)
    }
    
    static func delete(_ todo: Todo, in context: ModelContext) {
        context.delete(todo)
    }
    
    static func edit(text: String, for todo: Todo, in context: ModelContext) {
        todo.title = text
        try? context.save()
    }

    static func toggle(_ todo: Todo) {
        todo.isCompleted.toggle()
    }
    
}
