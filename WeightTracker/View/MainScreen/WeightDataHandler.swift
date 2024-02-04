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
    @Published var weightGoal = "0.0"
    @Published var weightToGoal = "0.0"
    @Published var selectedWeight = "0.0"
    
    @Published var lastMonthWeightData = [WeightData]()
    @Published var last3MonthWeightData = [WeightData]()
    @Published var customDurationWeightData = [WeightData]()
    
    @Published var toDateCustomDuration: String? = nil
    @Published var fromDateCustomDuration: String? = nil
    
    init() {
        setUpCustomDuration()
        
        lastMonthWeightData = getLastXMonthsData(numberOfMonths: 1).reversed()
        last3MonthWeightData = getLastXMonthsData(numberOfMonths: 3).reversed()
        // defaults.removeObject(forKey: "weightData")
        // weightData = getWeightData()
        weightGoal = getWeightGoal()
        updateWeightToGoal(latestWeight: nil)
    }
    
    private var minWeightData: Double? {
        weightData.max {$0.weight > $1.weight}?.weight
    }
    
    private var maxWeightData: Double? {
        weightData.min {$0.weight > $1.weight}?.weight
    }
    
    private func setChartDomainRange(_ myWeightData: [WeightData]) {
        
        //show minimum of 4 values
        //stride for 4 values = 0,7
        //stride for 5 values = 0,7
        //stride for more values = 1
        
//        if let minWeightData = myWeightData.max(by: {$0.weight > $1.weight})?.weight, let maxWeightData = myWeightData.min(by: {$0.weight > $1.weight})?.weight {
//            
//            let upperBound = Int(minWeightData)
//            let lowerBound = Int(maxWeightData)
//            var newDomainRange = lowerBound...upperBound
//            
//            if newDomainRange.count > 3 {
//                chartDomainRange = (Double(newDomainRange.lowerBound) - 0.3)...(Double(newDomainRange.upperBound) + 0.3)
//            } else {
//                let difference: Double = (Double(newDomainRange.count) / 2)
//                var upperBound = Double(upperBound) + difference
//                var lowerBound = Double(lowerBound) - difference
//                chartDomainRange = lowerBound...upperBound
//                
//            }
//        }
        
    }
    
    private func updateWeightToGoal(latestWeight: Double?) {
        
        var myLatestWeight = 0.0
        
        if latestWeight == nil {
            myLatestWeight = weightData[weightData.count-1].weight
        } else {
            myLatestWeight = latestWeight!
        }
        
        if let weightGoal = Double(weightGoal) {
            let weightLeft = myLatestWeight - weightGoal
            weightToGoal = String(format: "%.2f", abs(weightLeft)) // absolute value to string
        }
        
    }
    
    func saveNewGoal(goal: String) {
        
        weightGoal = goal
        defaults.set(goal, forKey: "weightGoal")
        updateWeightToGoal(latestWeight: nil)
        
    }
    
    func saveNewWeight(_ weight: String) {
        
        if let weight = Double(weight) {
            print("saving the weight")
            weightData.append(WeightData(date: Date().convertToString(), weight: weight))
            setChartDomainRange(weightData)
            defaults.set(try! PropertyListEncoder().encode(weightData), forKey: "weightData")
            updateWeightToGoal(latestWeight: weight)
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
    
    private func getWeightGoal() -> String {
        return defaults.object(forKey: "weightGoal") as? String ?? "0.0"
        
    }
    
    func getLastXMonthsData(numberOfMonths: Int) -> [WeightData] {
        
        var data = [WeightData]()
        let today = Date()
        
        if let xMonthsAgo = (Calendar.current.date(byAdding: .day, value: (numberOfMonths * (-30)), to: today)) {
            var date = today
            while date >= xMonthsAgo {
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                if let weightData = weightData.first(where: { $0.date == date.convertToString() }) {
                    data.append(weightData)
                }
            }
        }
        print("showing \(numberOfMonths) month data.")
        return data
        
    }
    
    func saveCustomDuration(from: Date, to: Date) {
        
        print("setting the custom duration")
        setDataForCustomDuration(from, to)
        
        let fromDateString = from.convertToString()
        let toDateString = to.convertToString()
        
        defaults.setValue(fromDateString, forKey: "fromDuration")
        defaults.setValue(toDateString, forKey: "toDuration")
        
        fromDateCustomDuration = fromDateString
        toDateCustomDuration = toDateString
        
    }
    
    private func setUpCustomDuration() {
        
        print("getting the custom duration")
        
        fromDateCustomDuration = defaults.value(forKey: "fromDuration") as? String ?? nil
        toDateCustomDuration = defaults.value(forKey: "toDuration") as? String ?? nil
        
        print("!!!! from \(fromDateCustomDuration)")
        print("!!! to \(toDateCustomDuration)")
        
        if let from = fromDateCustomDuration?.convertToDate(), let to = toDateCustomDuration?.convertToDate() {
            setDataForCustomDuration(from, to)
        }
        
    }
    
    private func setDataForCustomDuration(_ from: Date, _ to: Date) {
        
        var toDate = to
        var data = [WeightData]()
        
        while toDate >= from {
            toDate = Calendar.current.date(byAdding: .day, value: -1, to: toDate)!
            if let weightData = weightData.first(where: { $0.date == toDate.convertToString()}) {
                data.append(weightData)
            }
        }
        customDurationWeightData = data.reversed()
        
    }
    
}
