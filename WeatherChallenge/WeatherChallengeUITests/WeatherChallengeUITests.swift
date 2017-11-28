//
//  WeatherChallengeUITests.swift
//  WeatherChallengeUITests
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import XCTest

class WeatherChallengeUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDelete() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        tablesQuery.searchFields["Enter City Name"].tap()
        app.searchFields["Enter City Name"].typeText("Los Angeles")
        app.typeText("\r")
        
        let table = app.tables["tableView"]
        table.swipeDown()

        let count1 = table.cells.count
        let cell = table.cells.element(boundBy: 0)
        cell.buttons["button_delete"].tap()

        let count2 = table.cells.count
        
        XCTAssert(count1 - 1 == count2 , "Cell should have been removed from tableView.")
    }
    
}
