//
//  TodoRemote.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Foundation

// MARK: - Todo (Remote Model)

/// Remote ToDo entity that helps decode fetched tasks
struct TodoRemote: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let isCompleted: Bool
}

extension TodoRemote {
    enum CodingKeys: String, CodingKey {
        case userId, title, id
        case isCompleted = "completed"
    }
}
