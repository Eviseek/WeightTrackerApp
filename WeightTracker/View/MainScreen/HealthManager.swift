//
//  HealthManager.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 16.02.2024.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    
    var healthStore: HKHealthStore?
    let myWeight = WeightData.TEST_DATA
    
    @Published var isAuthorized = false
    @Published var shouldSync = true 
    
    init() {
        if HKHealthStore.isHealthDataAvailable() { //check if healthKit is available on the platform
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
        }
        
        print("class init")
        isAuthorized = getAuthorizationStatus()
        print("isAuthorized \(isAuthorized)")
        
    }
    
    func askForAuthorization() async {
        
        print("ask for auth")
        DispatchQueue.main.async {
            self.isAuthorized = self.getAuthorizationStatus()
        }
        if isAuthorized { return } //if I am already authorized, there's no need to continue
        guard let healthStore = healthStore else { return }
        
        let weight = HKQuantityType(.bodyMass)
        let healthTypes: Set = [weight]
            
        healthStore.requestAuthorization(toShare: healthTypes, read: nil) { [weak self] success, error in
            guard let self = self else { return }
            print("request auth")
            if success { //doesn't mean that user granted permission, but that they were shown the dialog successfully
                DispatchQueue.main.async {
                    self.isAuthorized = self.getAuthorizationStatus()
                }
            } else {
                DispatchQueue.main.async {
                    self.isAuthorized = false
                }
                print("!!!!!!!!! HealthKit -- something went wrong")
            }
        }
    }
    
    func getAuthorizationStatus() -> Bool {
        guard let healthStore = healthStore else { return false }
        if (healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!) == .sharingAuthorized) {
            return true
        } else {
            return false
        }
    }
    
    func saveNewData(weight: Double) {
        
        if !shouldSync || !isAuthorized { return }
        
        guard let healthStore = healthStore else { return }
        
        print("saving data")
        
        let weightType = HKQuantityType(.bodyMass)
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight) //representing value and unit
        
        let sample = HKQuantitySample(type: weightType, quantity: weightQuantity, start: Date(), end: Date()) //always saving right after user adds a new data
        
        healthStore.save(sample) { success, error in
            if success {
                print("!!!! healthkit - SAVED")
            } else {
                print("!!!!!!!!!! \(String(describing: error))")
            }
        }
        
    }
    
    
}
