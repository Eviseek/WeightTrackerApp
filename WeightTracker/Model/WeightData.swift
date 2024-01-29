//
//  WeightData.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import Foundation

struct WeightData: Identifiable, Codable {
    let date: String
    let weight: Double
    
    var id: String { return date }
}

extension WeightData {
    
    static var TEST_DATA: [WeightData] =
    [
        WeightData(date: "1.1.2023", weight: 68.1),
        WeightData(date: "2.1.2023", weight: 67.1),
        WeightData(date: "3.1.2023", weight: 69.1),
        WeightData(date: "4.1.2023", weight: 69.8),
        WeightData(date: "5.1.2023", weight: 68.8),
        WeightData(date: "6.1.2023", weight: 69.8),
        WeightData(date: "7.1.2023", weight: 67.8),
        WeightData(date: "8.1.2023", weight: 69.8),
        WeightData(date: "9.1.2023", weight: 68.3),
        WeightData(date: "10.1.2023", weight: 69.1),
        WeightData(date: "11.1.2023", weight: 68.9)
    ]

}
    
