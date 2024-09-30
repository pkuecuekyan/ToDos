//
//  ToDosUITests.swift
//  ToDosUITests
//
//  Created by Philipp Kuecuekyan on 9/28/24.
//

import XCTest

final class ToDosUITests: XCTestCase {

    var app: XCUIApplication!
    
    let shouldRunPerformanceMetrics: Bool = false
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [UI_TESTING_FLAG, DO_NOT_IMPORT_TODOS]
    }

    func testUIFunctionality() throws {
        
        /// Flow:
        /// * make sure buttons and lists exist
        /// * enter a new to-do
        /// * delete the new to-do
        /// * ensure new to-do is no longer there
        /// 
        app.launch()

        let editButton = app.buttons["toDoEditButton"]
        XCTAssertTrue(editButton.exists, "Ensure that the edit button is shown")
        
        
        let newEntryField = app.textViews["newToDoField"]
        XCTAssertTrue(newEntryField.exists, "Make sure that an enter a new to-do field exists")

        newEntryField.tap()                                     // tap on field
        newEntryField.typeText("Complete a new to-do")          // enter a new todo
        XCTAssertEqual(newEntryField.value as! String, "Complete a new to-do")      // ensure entry matches field
        
        let addButton = app.buttons["addToDoButton"]
        XCTAssertTrue(addButton.exists, "Make sure the add button exists")
        addButton.tap()             // tap on it to add the new to-do
        
        let list = app.collectionViews["toDoList"]
        XCTAssertTrue(list.exists, "Ensure the to-do list exists")
        
        let firstCell = list.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "There should be a new cell")
        
       
        firstCell.swipeLeft()        // swipe left to delete
                
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Make sure the delete button exists")
        deleteButton.tap()              // Tap the delete button
        
        XCTAssertTrue(list.cells.count == 1, "Ensure that only one cell (Add new todo) exists in list")
        
    }

    func testLaunchPerformance() throws {
        guard shouldRunPerformanceMetrics == true else { return }                       // disabled in most test scenarios
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
