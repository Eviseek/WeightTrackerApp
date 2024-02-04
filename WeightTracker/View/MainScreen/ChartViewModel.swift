//
//  ChartViewModel.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 04.02.2024.
//

import Foundation

class ChartViewModel: ObservableObject {
    
    private var weightData: [WeightData]
    
    @Published var chartDomainRange = 50.0...55.0
    
    init(weightData: [WeightData]) {
        self.weightData = weightData
        setChartDomainRange(weightData)
    }
    
    private func setChartDomainRange(_ myWeightData: [WeightData]) {
        
        //show minimum of 4 values
        //stride for 4 values = 0,7
        //stride for 5 values = 0,7
        //stride for more values = 1
        
        if let minWeightData = myWeightData.max(by: {$0.weight > $1.weight})?.weight, let maxWeightData = myWeightData.min(by: {$0.weight > $1.weight})?.weight {

            let upperBound = Int(minWeightData)
            let lowerBound = Int(maxWeightData)
            let newDomainRange = lowerBound...upperBound

            if newDomainRange.count > 3 {
                chartDomainRange = (Double(newDomainRange.lowerBound) - 0.3)...(Double(newDomainRange.upperBound) + 0.3)
            } else {
                let difference: Double = (Double(newDomainRange.count) / 2)
                let upperBound = Double(upperBound) + difference
                let lowerBound = Double(lowerBound) - difference
                chartDomainRange = lowerBound...upperBound

            }
        }
        
    }
    
}
