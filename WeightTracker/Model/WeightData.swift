//
//  WeightData.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import Foundation

struct WeightData: Identifiable {
    let date: TimeInterval
    let weight: Double
    
    var id: Double { return date }
}

extension WeightData {
    
    static var TEST_DATA: [WeightData] =
    [
        WeightData(date: 1, weight: 68.1),
        WeightData(date: 2, weight: 67.1),
        WeightData(date: 3, weight: 69.1),
        WeightData(date: 4, weight: 69.8),
        WeightData(date: 5, weight: 68.8)
    ]

}
    
