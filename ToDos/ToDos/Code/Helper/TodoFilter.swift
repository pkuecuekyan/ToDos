//
//  TodoFilter.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import SwiftUI

/// Filter values for picker in ListView
enum TodoFilter: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case notCompleted = "Not Completed"
    
    // Associated predicate for each filter option
    var predicate: Predicate<Todo>? {
        switch self {
        case .all:
            return nil // No filter, show all tasks
        case .completed:
            return #Predicate { $0.isCompleted == true }
        case .notCompleted:
            return #Predicate { $0.isCompleted == false }
        }
    }
}

