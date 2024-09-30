//
//  TransformFetcher.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import Combine
import Foundation

/// Loader/transformer that facilitates input streams
struct TransformFetcher<Input: Decodable, Output> {
    let url: URL
    let shouldInclude: (Input) -> Bool
    let transform: (Input) -> Output
    let limit: Int
    
    init(
        url: URL,
        shouldInclude: @escaping (Input) -> Bool,
        transform: @escaping (Input) -> Output,
        limit: Int = 5) {
        self.url = url
        self.shouldInclude = shouldInclude
        self.transform = transform
        self.limit = limit
    }
    
    func publish() -> AnyPublisher<[Output], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Input].self, decoder: JSONDecoder())
            .map { items in
                return items
                    .filter(self.shouldInclude)
                    .prefix(self.limit)
                    .map(self.transform)
            }
            .map { Array($0.prefix(self.limit)) }
            .eraseToAnyPublisher()
    }
}
