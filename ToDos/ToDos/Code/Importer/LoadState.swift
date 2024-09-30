//
//  LoadState.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Foundation

/// Track the load state of the fetcher/transformer/importer
enum LoadState {
    case loading
    case success(Int)
    case failure(Error)
    case idle
}
