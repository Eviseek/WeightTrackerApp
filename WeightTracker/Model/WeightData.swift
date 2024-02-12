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
        WeightData(date: "11.1.2023", weight: 69.9),
        WeightData(date: "12.1.2023", weight: 69.9),
        WeightData(date: "13.1.2023", weight: 67.9),
        WeightData(date: "14.1.2023", weight: 68.6),
        WeightData(date: "15.1.2023", weight: 68.5),
        WeightData(date: "16.1.2023", weight: 68.1),
        WeightData(date: "17.1.2023", weight: 66.1),
        WeightData(date: "18.1.2023", weight: 66.9),
        WeightData(date: "19.1.2023", weight: 68.4),
        WeightData(date: "20.1.2023", weight: 68.5),
        WeightData(date: "9.11.2023", weight: 67.5),
        WeightData(date: "10.11.2023", weight: 67.9),
        WeightData(date: "19.11.2023", weight: 67.1),
        WeightData(date: "21.11.2023", weight: 68.1),
        WeightData(date: "22.11.2023", weight: 66.9),
        WeightData(date: "23.11.2023", weight: 68.7),
        WeightData(date: "24.11.2023", weight: 68.1),
        WeightData(date: "25.11.2023", weight: 68.0),
        WeightData(date: "26.11.2023", weight: 68.7),
        WeightData(date: "27.11.2023", weight: 69.9),
        WeightData(date: "28.11.2023", weight: 67.9),
        WeightData(date: "27.12.2023", weight: 69.5),
        WeightData(date: "28.12.2023", weight: 69.1),
        WeightData(date: "29.12.2023", weight: 69.9),
        WeightData(date: "27.1.2024", weight: 69.9),
        WeightData(date: "28.1.2024", weight: 70.9),
        WeightData(date: "29.1.2024", weight: 70.5),
        WeightData(date: "30.1.2024", weight: 70.4),
        WeightData(date: "31.1.2024", weight: 70.3),
        WeightData(date: "1.2.2024", weight: 69.8),
        WeightData(date: "3.2.2024", weight: 68.8)
    ]

}
    
