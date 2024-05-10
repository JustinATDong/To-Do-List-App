//
//  To_Do_List_AppUITests.swift
//  To-Do List AppUITests
//
//  Created by Justin Dong on 4/27/24.
//

import XCTest
import SwiftUI
@testable import To_Do_List_App

class ToDoListAppUITests: XCTestCase {
    
    // Properties
    var arr: ContentView!
    var hostingController: UIHostingController<ContentView>!
    @State private var tasks: [Task] = []
    
    // Setup
    override func setUp() {
        super.setUp()
        arr = ContentView(tasks: tasks) // Initialize with an empty tasks array
        hostingController = UIHostingController(rootView: arr)
        _ = hostingController.view // Load the view hierarchy
    }
    
    override func tearDown() {
        arr = nil
        hostingController = nil
        super.tearDown()
    }
    
    // UI Tests
    func testAddTask() {
        let initialTaskCount = arr.tasks.count
        arr.newTaskName = "New Task"
        arr.addTask()
        
        XCTAssertEqual(arr.tasks.count, initialTaskCount + 1)
        XCTAssertEqual(arr.tasks.last?.name, "New Task")
    }
    
    func testTaskCompletionToggle() {
        // Given
        let task = Task(name: "Test Task", dueDate: Date())
        arr.tasks = [task]
        
        // When
        arr.toggleTaskCompletion(task)
        
        // Then
        XCTAssertTrue(task.isCompleted)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
