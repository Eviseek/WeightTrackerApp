//
//  CustomDurationChart_UITests.swift
//  WeightTracker_UITests
//
//  Created by Eva Chlpikova on 17.02.2024.
//

import XCTest
@testable import WeightTracker

// Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour

// Testing Structure: Given, When, Then

final class CustomDurationChart_UITests: XCTestCase {
    
    private let defaults = UserDefaults.standard

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_CustomDurationChartView_durationDialog_shouldDisplayDurationDialogAndDisplayUpdateButton() {
        //Given
        let app = XCUIApplication()
        
        let customDurationView = app/*@START_MENU_TOKEN@*/.buttons["Custom"]/*[[".segmentedControls.buttons[\"Custom\"]",".buttons[\"Custom\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*///TODO: add accessbility identifier
        customDurationView.tap()
        
        //When
        let selectDurationButton = app.buttons["SelectDurationButton"]
        XCTAssertTrue(selectDurationButton.exists)
        selectDurationButton.tap()
        
        let durationDialogDoneButton = app.buttons["CustomDurationDoneButton"]
        XCTAssertTrue(durationDialogDoneButton.exists)
        durationDialogDoneButton.tap()
        
        let durationText = app.staticTexts["DurationText"]
        XCTAssertTrue(durationText.exists)
        
        let updateDurationButton = app.buttons["CustomDurationUpdateDurationButton"]
        XCTAssertTrue(updateDurationButton.exists)
                
    }

}
