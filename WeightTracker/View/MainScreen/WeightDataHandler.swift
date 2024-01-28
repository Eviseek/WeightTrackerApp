//
//  WeightDataHandler.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 27.01.2024.
//

import Foundation

class WeightDataHandler: ObservableObject {
    
    private let defaults = UserDefaults.standard
    private let dateFormatterHandler = DateFormatterHandler()
    var weightData = WeightData.TEST_DATA
    //@Published var weightData = [WeightData]()
    @Published var chartDomainRange = 50.0...55.0
    
    init() {
       // defaults.removeObject(forKey: "weightData")
       // weightData = getWeightData()
        setChartDomainRange()
    }
    
    private var minWeightData: Double? {
        weightData.max {$0.weight > $1.weight}?.weight
    }
    
    private var maxWeightData: Double? {
        weightData.min {$0.weight > $1.weight}?.weight
    }
    
    private func setChartDomainRange() {
        if let minWeightData = minWeightData, let maxWeightData = maxWeightData {
            let lowDomainValue = minWeightData - 0.7
            let highDomainValue = maxWeightData + 0.7
            let newDomainRange = lowDomainValue...highDomainValue
            chartDomainRange = newDomainRange
        }
    }
    
    func saveNewWeight(weight: String) {
        if let weight = Double(weight) {
            print("saving the weight")
            weightData.append(WeightData(date: dateFormatterHandler.convertDateToStr(date: Date()), weight: weight)) //TODO: change 1 to date
//            if let encodedData = try PropertyListEncoder().encode(realData) {
//                defaults.set(encodedData, forKey: "weightData")
//            } else {
//                print("!!!!!!!!!!! Something went wrong")
//            }
            setChartDomainRange()
            defaults.set(try! PropertyListEncoder().encode(weightData), forKey: "weightData")
            //defaults.setValue(realData, forKey: "weightData")
        }
    }
    
    private func getWeightData() -> [WeightData] {
        if let storedData: Data = defaults.object(forKey: "weightData") as? Data {
            print("stored data decoded")
            let weightData = (try? PropertyListDecoder().decode([WeightData].self, from: storedData)) ?? [WeightData]()
            print("weight data is \(weightData)")
            return weightData
        }
        return [WeightData]()
    }
    
}
