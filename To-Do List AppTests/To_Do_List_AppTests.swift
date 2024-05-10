//
//  To_Do_List_AppTests.swift
//  To-Do List AppTests
//
//  Created by Justin Dong on 4/27/24.
//

import XCTest
@testable import To_Do_List_App

class ToDoListAppTests: XCTestCase {
    
    // Properties
    var contentView: ContentView!
    
    // Setup
    override func setUp() {
        super.setUp()
        contentView = ContentView()
    }
    
    override func tearDown() {
        contentView = nil
        super.tearDown()
    }
    
    // Tests
    func testCreateTask() {
        let initialTaskCount = contentView.tasks.count
        let taskName = "Test Task"
        let dueDate = Date()
        
        contentView.newTaskName = taskName
        contentView.newTaskDueDateTime = dueDate
        
        contentView.addTask()
        
        XCTAssertEqual(contentView.tasks.count, initialTaskCount + 1)
        XCTAssertEqual(contentView.tasks.last?.name, taskName)
        XCTAssertEqual(contentView.tasks.last?.dueDate, dueDate)
    }
    
    func testToggleTaskCompletion() {
        let task = Task(name: "Test Task", dueDate: Date())
        contentView.tasks.append(task)
        
        let initialCompletedState = task.isCompleted
        contentView.toggleTaskCompletion(task)
        
        XCTAssertEqual(task.isCompleted, !initialCompletedState)
    }
    
    func testDeleteTask() {
        let task = Task(name: "Test Task", dueDate: Date())
        contentView.tasks.append(task)
        
        let initialTaskCount = contentView.tasks.count
        contentView.toggleTaskCompletion(task)
        
        XCTAssertEqual(contentView.tasks.count, initialTaskCount - 1)
    }
}
