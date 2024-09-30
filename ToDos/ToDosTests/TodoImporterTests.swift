//
//  TodoImporterTests.swift
//  ToDosTests
//
//  Created by Philipp Kuecuekyan on 9/28/24.
//

import Combine
import SwiftData
import XCTest

/// Unit tests to evaluate importing to-dos from a bundled sample
final class TodoImporterTests: XCTestCase {

    // MARK: - Properties
    
    var config = ModelConfiguration(isStoredInMemoryOnly: true)
    var container: ModelContainer!
    var context: ModelContext!

    var importer = TodoImporter()
    
    var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup handling
    
    override func setUpWithError() throws {
        do {
            container = try ModelContainer(for: Todo.self, configurations: config)
            context = ModelContext(container)
            importer.updateImportUrl(to: Bundle(for: type(of: self)).url(forResource: "ios_sample", withExtension: "json")!)
            importer.updateFirstImportRequirement(to: false)
        } catch {
            throw error
        }
    }

    func testImportNoMax() throws {

        let expectation = XCTestExpectation(description: "Waiting to remote todos to be imported")

        importer.importToDos(forUserWithID: 3, into: context, maxCount: Int.max)
                
        importer.$state
            .dropFirst()
            .sink { newValue in
                if case let .success(count) = newValue {
                    XCTAssert(count == 20, "Should have imported 20 items")
                    expectation.fulfill()
                } else {
                    XCTFail("Import failed")
                }
            }
            .store(in: &cancellables)
    }
    
    
    func testImportFive() throws {

        let expectation = XCTestExpectation(description: "Waiting to remote todos to be imported, 5 max.")
        importer.importToDos(forUserWithID: 3, into: context)
                
        importer.$state
            .dropFirst()
            .sink { newValue in
                if case let .success(count) = newValue {
                    XCTAssert(count == 5, "Should have imported 5 items")
                    expectation.fulfill()
                } else {
                    XCTFail("Import failed")
                }
            }
            .store(in: &cancellables)
    }
    
    func testImportFiveCheckLimit() throws {

        let expectation1 = XCTestExpectation(description: "Waiting to remote todos to be imported, 5 max.")

        importer.importToDos(forUserWithID: 3, into: context)
        importer.updateFirstImportRequirement(to: false)

        importer.$state
            .dropFirst()
            .sink { newValue in
                if case let .success(count) = newValue {
                    XCTAssert(count == 5, "Should have imported 5 items")
                    expectation1.fulfill()
                } else {
                    XCTFail("Import failed")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation1], timeout: 1.0)
        
        let expectation2 = XCTestExpectation(description: "Waiting to remote todos to be imported, no more imported.")

        importer.importToDos(forUserWithID: 3, into: context)
                
        importer.$state
            .dropFirst()
            .sink { newValue in
                if case let .success(count) = newValue {
                    XCTAssert(count == 0, "Should not have imported any more")
                    expectation2.fulfill()
                } else {
                    XCTFail("Import failed")
                }
            }
            .store(in: &cancellables)

    }
}
