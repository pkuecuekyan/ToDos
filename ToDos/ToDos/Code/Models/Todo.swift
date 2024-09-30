//
//  Todo.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import SwiftData
import Foundation

// MARK: - Models (Todo) 

/// Main SwiftData entity that hold entries
@Model
class Todo {
    @Attribute(.unique) var id: Int
    var title: String
    var isCompleted: Bool
    var isImported: Bool
    
    init(id: Int, 
         title: String,
         isCompleted: Bool = false,
         isImported: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isImported = isImported
    }
    
}

extension Todo {
    
    // MARK: - FetchDescriptor conveniences
    
    static var all: FetchDescriptor<Todo> {
        return FetchDescriptor<Todo>()
    }
    static var allReverseOrder: FetchDescriptor<Todo> {
        return FetchDescriptor<Todo>(sortBy: [SortDescriptor(\.id, order: .reverse)])
    }
    
    static var isImported: FetchDescriptor<Todo> {
        FetchDescriptor<Todo>(
            predicate: #Predicate { todo in
                todo.isImported == true
            }
        )
    }
    
    static func hasId(_ identifier: Int) -> FetchDescriptor<Todo> {
        FetchDescriptor<Todo>(
            predicate: #Predicate { todo in
                todo.id == identifier
            }
        )
    }
    
}

extension Todo {
    
    // MARK: - Fetch convenience methods to find identifiers, get task numbers, count entities
    
    static func doesIdExist(_ identifier: Int, context: ModelContext) -> Bool {
        do {
            let todos = try context.fetch(Todo.hasId(identifier))
            return !todos.isEmpty
        } catch {
            TodoLogger.shared.logger.error("Todo lookup failed with \(error.localizedDescription)")
            return false
        }
    }
    
    static func importCount(in context: ModelContext) throws -> Int {
        do {
            let todos = try context.fetch(Todo.isImported)
            return todos.count
        } catch {
            TodoLogger.shared.logger.error("Todo lookup failed with \(error.localizedDescription)")
            throw error
        }
    }

    static func getNextTaskId(in context: ModelContext) -> Int {
        var descriptor = Self.allReverseOrder
        descriptor.fetchLimit = 1
        
        if let highestIdTodo = try? context.fetch(descriptor).first {
            return highestIdTodo.id + 1
        } else {
            return 1
        }
    }

}

