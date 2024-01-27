//
//  WeightDataHandler.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import Foundation

class WeightDataHandler {
    
    private let defaults = UserDefaults.standard
    var data = WeightData.TEST_DATA
    @Published var realData = [WeightData]()
    
    init() {
        realData = getWeightData()
    }
    
    var maxWeightData: Double? {
        data.max {$0.weight < $1.weight}?.weight
    }
    
    var minWeightData: Double? {
        data.min {$0.weight > $1.weight}?.weight
    }
    
    func saveNewWeight(weight: String) {
        if let weight = Double(weight) {
            realData.append(WeightData(date: Date().timeIntervalSince1970, weight: weight)) //TODO: change 1 to date
            defaults.setValue(realData, forKey: "weightData")
        }
    }
    
    private func getWeightData() -> [WeightData] {
        return defaults.object(forKey: "weightData") as? [WeightData] ?? [WeightData]()
    }
    
}
