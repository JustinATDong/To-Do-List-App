//
//  To_Do_List_AppUITestsLaunchTests.swift
//  To-Do List AppUITests
//
//  Created by Justin Dong on 4/27/24.
//

import XCTest

class To_Do_List_AppUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
