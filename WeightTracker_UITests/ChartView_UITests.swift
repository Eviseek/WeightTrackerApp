//
//  ChartView_UITests.swift
//  WeightTracker_UITests
//
//  Created by Eva Chlpikova on 18.02.2024.
//

import XCTest
@testable import WeightTracker

final class ChartView_UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Testing if goal dialog is shown and dismissed
    func test_ChartView_weightChart_shouldNOTDisplayChart() {
        //Given
        let app = XCUIApplication()
        let weightDataHandler = WeightDataHandler()
        weightDataHandler.weightData = [WeightData]()
        
        //When
        let chartNoDataText = app.staticTexts["MonthChartNoDataText"]
        XCTAssertTrue(chartNoDataText.exists)
                
        
        let monthChartInfoButton = app.buttons["MonthChartInfoButton"]
        
        //Then
        XCTAssertFalse(monthChartInfoButton.exists)
    }

}
