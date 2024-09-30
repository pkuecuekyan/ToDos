//
//  TodoWriterTests.swift
//  ToDosTests
//
//  Created by Philipp Kuecuekyan on 9/28/24.
//

import SwiftData
import XCTest

/// Unit tests to evaluate writing, updating, and deleting to-dos
final class TodoWriterTests: XCTestCase {

    // MARK: - Properties
    
    var config = ModelConfiguration(isStoredInMemoryOnly: true)
    var container: ModelContainer!
    var context: ModelContext!
    
    // MARK: - Helper properties/methods
    
    var sampleTodos: [Todo] { return
        [
            Todo(id: Todo.getNextTaskId(in: context), title: sampleTitles[0], isCompleted: false),
            Todo(id: Todo.getNextTaskId(in: context), title: sampleTitles[1], isCompleted: true),
            Todo(id: Todo.getNextTaskId(in: context), title: sampleTitles[2], isCompleted: false)
        ]
    }

    var sampleTitles: [String] = ["Buy groceries", "Finish project", "Call mom"]
    
    func populateContext() {
        sampleTodos.forEach { todo in context.insert(todo) }
    }
    
    var fetchedAll: [Todo] { try! context.fetch(Todo.all) }
    
    // MARK: - Setup handling
    
    override func setUpWithError() throws {
        do {
            container = try ModelContainer(for: Todo.self, configurations: config)
            context = ModelContext(container)
        } catch {
            throw error
        }
    }

    // MARK: - Tests
    
    func testInsert() throws {
        sampleTitles.forEach { title in
            TodoWriter.add(title, into: context)
        }

        let fetched = fetchedAll
        XCTAssertTrue(fetched.count == 3, "Ensure that 3 todos are inserted")
    }
    
    func testRemove() throws {
        populateContext()
        
        let firstFetch = fetchedAll
        XCTAssertTrue(firstFetch.count == 3, "Ensure that 3 exist")
        TodoWriter.delete(firstFetch.first!, in: context)
        
        let secondFetch = fetchedAll
        XCTAssertTrue(secondFetch.count == 2, "Ensure that 1 was deleted")
        
    }
    
    func testToggle() throws {
        populateContext()
        let firstElement = fetchedAll.first!
        firstElement.isCompleted = false
        TodoWriter.toggle(firstElement)
        XCTAssert(firstElement.isCompleted == true, "Ensure that element got toggled: not completed to completed")
    }
    
    func testEdit() throws {
        populateContext()
        let firstElement = fetchedAll.first!
        let newText = "Modified Text"
        TodoWriter.edit(text: newText, for: firstElement, in: context)
        
        let firstElementRefetch = fetchedAll.first!
        XCTAssert(firstElementRefetch.title == newText, "Ensure that element text/title got changed")
    }
    
}
