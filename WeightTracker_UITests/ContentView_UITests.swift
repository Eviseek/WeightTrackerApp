//
//  ContentView_UITests.swift
//  WeightTracker_UITests
//
//  Created by Eva Chlpikova on 17.02.2024.
//

import XCTest
@testable import WeightTracker

// Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour

// Testing Structure: Given, When, Then

final class ContentView_UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Testing if goal dialog is shown and dismissed
    func test_ContentView_goalView_shouldDisplayAndDismissGoalDialog() {
        //Given
        let app = XCUIApplication()
        let goalButton = app.buttons["goalView"]
        
        //When
        let weightGoalDialogTitle = app.staticTexts["GoalDialogTitle"]
        goalButton.tap()
        
        XCTAssertTrue(weightGoalDialogTitle.exists)
        weightGoalDialogTitle.tap()
        
        let doneButton = app.buttons["GoalDialogDoneButton"]
        doneButton.tap()
        
        //Then
        XCTAssertFalse(weightGoalDialogTitle.exists)
    }

}
