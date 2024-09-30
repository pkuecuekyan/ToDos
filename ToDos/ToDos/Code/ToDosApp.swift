//
//  ToDosApp.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import SwiftUI
import SwiftData

@main
struct ToDosApp: App {
    
    // MARK: - Properties
    
    let container: ModelContainer
    
    @State private var shouldImportContent: Bool = false
    
    // MARK: - Initializers
    
    init() {
        if CommandLine.arguments.contains(UI_TESTING_FLAG) == true {
            self.shouldImportContent = CommandLine.arguments.contains(DO_NOT_IMPORT_TODOS)
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)         // Create in-memory store for testing
                self.container = try ModelContainer(for: Todo.self, configurations: config)
            } catch {
                fatalError("Failed to create in-memory container: \(error)")
            }
        } else {
            self.shouldImportContent = true
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: false)
                self.container = try ModelContainer(for: Todo.self, configurations: config)
            } catch {
                fatalError("Failed to create container: \(error)")
            }
        }
    }
    
    // MARK: - Main scene
    
    var body: some Scene {
        WindowGroup {
            TodoView()
                .environment(\.shouldImportContent, shouldImportContent)
        }
        .modelContainer(container)
    }
    
}
