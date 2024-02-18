//
//  HealthManager_Tests.swift
//  WeightTracker_Tests
//
//  Created by Eva Chlpikova on 17.02.2024.
//

import XCTest
@testable import WeightTracker

final class HealthManager_Tests: XCTestCase {
    
    // Naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour

    // Testing Structure: Given, When, Then

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Testing if authorizationStatus is false when HKHealthStore is nil
    func test_HealthManager_getAuthorizationStatus_shouldReturnFalse() {
        //Given
        let healthManager = HealthManager()
        
        //When
        healthManager.healthStore = nil
        
        //Then
        XCTAssertFalse(healthManager.getAuthorizationStatus())
    }

}
