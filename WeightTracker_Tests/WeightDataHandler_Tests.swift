//
//  WeightDataHandler_Tests.swift
//  WeightTracker_Tests
//
//  Created by Eva Chlpikova on 16.02.2024.
//

import XCTest
@testable import WeightTracker

// Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour

// Testing Structure: Given, When, Then

final class WeightDataHandler_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Testing that weight is not saved if INVALID
    func test_WeightDataHandler_saveNewWeight_shouldNotSave() {
        //Given
        let weightHandler = WeightDataHandler()
        let weightDataCount = weightHandler.weightData.count
        let healthManager = HealthManager()
        
        //When
        let weight = UUID().uuidString
        weightHandler.saveNewWeight(weight, withHealth: healthManager)
        
        //Then
        XCTAssertEqual(weightDataCount, weightHandler.weightData.count)
    }
    
    //Testing that the weight is rewritten if saving on the same day
    func test_WeightDataHandler_saveNewWeight_shouldRewrite() {
        //Given
        let weightHandler = WeightDataHandler()
        let weightData = weightHandler.weightData
        let weightDataCount = weightData.count
        let healthManager = HealthManager()
        
        //When
        let weight = "55.0"
        weightHandler.saveNewWeight(weight, withHealth: healthManager)
        
        let secondWeight = "56.0"
        weightHandler.saveNewWeight(secondWeight, withHealth: healthManager)
        
        //Then
        XCTAssertEqual(weightHandler.weightData[weightData.count-1].weight, Double(secondWeight)) //check if the last element is the second added weight
    }
    
    //Testing if user enters INVALID goal, it DOESN'T get saved
    func test_WeightDataHandler_saveNewGoal_shouldNotSave() {
        //Given
        let weightHandler = WeightDataHandler()
        let healthManager = HealthManager()
        
        //When
        let newGoal = UUID().uuidString
        weightHandler.saveNewGoal(goal: newGoal)
    
        //Then
        XCTAssertNotEqual(weightHandler.weightGoal, newGoal) //check that the new invalid goal wasn't saved
    }
    
    //Testing if user enters valid goal, it gets saved
    func test_WeightDataHandler_saveNewGoal_shouldSave() {
        //Given
        let weightHandler = WeightDataHandler()
        let healthManager = HealthManager()
        
        //When
        let newGoal = String(Double.random(in: 1.0...100.0))
        weightHandler.saveNewGoal(goal: newGoal)
    
        //Then
        XCTAssertEqual(weightHandler.weightGoal, newGoal) //check that the new invalid goal wasn't saved
    }
    
    //Testing if the duration is saved to UserDefaults
    func test_WeightDataHandler_saveCustomDuration_shouldSave() {
        //Given
        let weightHandler = WeightDataHandler()
        let healthManager = HealthManager()
        let defaults = UserDefaults.standard
        
        //When
        let from = Calendar.current.date(byAdding: .day, value: Int.random(in: (-20)...(-1)), to: Date())!
        let to = Date()
        weightHandler.saveCustomDuration(from: from, to: to)
        
        let getFrom = defaults.object(forKey: "fromDuration") as? String
        let getTo = defaults.object(forKey: "toDuration") as? String
    
        //Then
        XCTAssertEqual(from.convertToString(), getFrom)
        XCTAssertEqual(to.convertToString(), getTo)
    }
    
    //Testing that the getLastXMonthsData returns values
    func test_WeightDataHandler_getLastXMonthsData_shouldGetData() {
        //Given
        let weightHandler = WeightDataHandler()
        let healthManager = HealthManager()
        let defaults = UserDefaults.standard
        
        let newWeight = Double.random(in: 1000...2000)
        weightHandler.saveNewWeight(String(newWeight), withHealth: healthManager)
        
        //When
        let weightData = weightHandler.getLastXMonthsData(numberOfMonths: 1)
    
        //Then
        XCTAssertTrue(weightData.count > 0) //check that there's at least one value
        XCTAssertTrue(weightData.contains(where: { $0.weight == newWeight })) //check that it found our saved weight
    }
    
    
    
}
