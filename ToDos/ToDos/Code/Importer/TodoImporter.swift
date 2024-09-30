//
//  TodoImporter.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Combine
import SwiftData
import SwiftUI

/// Facilitates getting, parsing, and transforming fetched remote to-dos
final class TodoImporter: ObservableObject {
    
    // MARK: - Properties
    
    @Published var state: LoadState = .idle
    
    @AppStorage("didImport") private var didImport: Bool = false            // track that first import occurred

    private var url = URL(string: "https://jsonplaceholder.typicode.com/todos")
    
    private var shouldLimitImportToFirstLoad: Bool = true                   // limit import to first load

    private var sendable = Set<AnyCancellable>()
    
    // MARK: - Import method (public)
    
    func importToDos(forUserWithID userId: Int, into context: ModelContext, maxCount: Int = 5) {
        
        guard let url else { return }
        guard let currentCount = try? Todo.importCount(in: context), (maxCount - currentCount > 0) else { return }
        if shouldLimitImportToFirstLoad && didImport { return }
        
        let limit = maxCount - currentCount
                
        state = .loading
        
        TransformFetcher<TodoRemote, Todo>(
            url: url,
            shouldInclude: {
                
                // criteria:
                // * imported todo matches userId and
                // * todo does not exist
                
                $0.userId == userId && Todo.doesIdExist($0.id, context: context) == false
            },
            transform: { remoteTodo in
                Todo(id: remoteTodo.id, 
                     title: remoteTodo.title,
                     isCompleted: remoteTodo.isCompleted,
                     isImported: true
                )
            }, limit: limit
        ).publish()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        TodoLogger.shared.logger.notice("Todos successfully fetched")
                    case .failure(let error):
                        self.state = .failure(error)
                        TodoLogger.shared.logger.error("Todos fetching failed with \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] items in
                    guard let self else { return }
                    items.forEach { item in
                        context.insert(item)
                    }
                    do { 
                        try context.save()
                        self.state = .success(items.count)
                        self.didImport = true
                    } catch {
                        TodoLogger.shared.logger.error("Todo import save failed with \(error.localizedDescription)")
                    }
                    
                }
            ).store(in: &sendable)
    }
 
    // MARK: - Helper methods (public)
    
    func updateImportUrl(to url: URL) {
        self.url = url
    }
    
    func updateFirstImportRequirement(to shouldUpdateTo: Bool) {
        self.shouldLimitImportToFirstLoad = shouldUpdateTo
    }
    
}
