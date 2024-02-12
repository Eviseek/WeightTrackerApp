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
    @Published var weightGoal = "0.0"
    @Published var weightToGoal = "0.0"
    @Published var selectedWeight = "0.0"

    @Published var customDurationWeightData = [WeightData]()
    @Published var customDurationChartData = ChartData()
    
    @Published var lastMonthWeightData = [WeightData]()
    @Published var lastMonthChartData = ChartData()
    
    
    @Published var last3MonthsWeightData = [WeightData]()
    @Published var last3MonthsChartData = ChartData()
    
    @Published var toDateCustomDuration: String? = nil
    @Published var fromDateCustomDuration: String? = nil
    
    init() {
    
      //  weightData = getWeightData()
        
        updateCharts()
        
      // defaults.removeObject(forKey: "weightData")

        weightGoal = getWeightGoal()
        updateWeightToGoal(latestWeight: nil)
    }
    
    private func updateCharts() {
        lastMonthWeightData = getLastXMonthsData(numberOfMonths: 1).reversed()
        lastMonthChartData = getChartDataFor(lastMonthWeightData)
        
        last3MonthsWeightData = getLastXMonthsData(numberOfMonths: 3).reversed()
        last3MonthsChartData = getChartDataFor(last3MonthsWeightData)
        
        setUpCustomDuration()
        customDurationChartData = getChartDataFor(customDurationWeightData)
    }
    
    // MARK: Weight functionality
    
    func saveNewWeight(_ weight: String) {
        
        if let weight = Double(weight) {
            print("saving the weight \(weight)")
            
            if weightData.count > 0 && weightData[weightData.count-1].date == Date().convertToString() { //if user already saved today's weight, delete it and save the new one (one date = one weight)
                weightData.remove(at: weightData.count-1)
            }
            
            weightData.append(WeightData(date: Date().convertToString(), weight: weight))
            defaults.set(try! PropertyListEncoder().encode(weightData), forKey: "weightData")
            updateWeightToGoal(latestWeight: weight)
            print("weight data \(weightData)")
            updateCharts()
        }
    }
    
    private func getWeightData() -> [WeightData] {
        
        if let storedData: Data = defaults.object(forKey: "weightData") as? Data {
            let weightData = (try? PropertyListDecoder().decode([WeightData].self, from: storedData)) ?? [WeightData]()
            return weightData
        }
        return [WeightData]()
    }
    

    
    func getLastXMonthsData(numberOfMonths: Int) -> [WeightData] {
        
        var newData = [WeightData]()
        let today = Date()
        
        if let xMonthsAgo = (Calendar.current.date(byAdding: .day, value: (numberOfMonths * (-30)), to: today)) {
            var date = today
            while date >= xMonthsAgo {
                if let weightData = weightData.first(where: { $0.date == date.convertToString() }) {
                    newData.append(weightData)
                }
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)! //needs to be after if let otherwise it will be counting from -1 day (from yesterday)
            }
        }
        return newData
    }
    
    // MARK: Goal functionality
    
    private func updateWeightToGoal(latestWeight: Double?) {
        
        var myLatestWeight = 0.0
        
        if latestWeight == nil {
            if weightData.count > 0 {
                myLatestWeight = weightData[weightData.count-1].weight
            }
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
    
    private func getWeightGoal() -> String {
        
        return defaults.object(forKey: "weightGoal") as? String ?? "0.0"
    }
    
    // MARK: Chart Data functionality
    
    private func getChartDataFor(_ myWeightData: [WeightData]) -> ChartData {
        
        //show minimum of 4 values
        //stride for 4 values = 0,7
        //stride for 5 values = 0,7
        //stride for more values = 1
        
        var stride = 0.5
        
        if myWeightData.count < 1 {
            return ChartData()
        }
        
        if let minWeightData = myWeightData.max(by: {$0.weight > $1.weight})?.weight, let maxWeightData = myWeightData.min(by: {$0.weight > $1.weight})?.weight {

            let lowerBound = minWeightData
            let upperBound = maxWeightData
            let intDomainRange = (Int(lowerBound.rounded(.down))...Int(upperBound.rounded(.up)))
            
            var newRange = 50.0...55.0
            
            if intDomainRange.count > 3 { //if there's more than three numbers between min and max then return range as is
                if intDomainRange.count > 5 {
                    stride = 1
                }
                newRange = (lowerBound.rounded(.down))...(upperBound.rounded(.up))
            } else {
                let difference: Double = (Double(intDomainRange.count) / 2)
                let upperBound = ((upperBound + difference).rounded(.up))
                let lowerBound = ((lowerBound - difference).rounded(.down))
                newRange = lowerBound...upperBound
            }
            return ChartData(stride: stride, range: newRange)
        } else {
            print("!!!!!!! SOMETHING WENT WRONG")
        }
        return ChartData()
    }
    
//MARK: Duration algorithms
    
    func saveCustomDuration(from: Date, to: Date) {
        
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

        
        if let from = fromDateCustomDuration?.convertToDate(), let to = toDateCustomDuration?.convertToDate() {
            setDataForCustomDuration(from, to)
        }
    }
    
    private func setDataForCustomDuration(_ from: Date, _ to: Date) {
        
        var toDate = to
        var data = [WeightData]()
        
        while toDate >= from {
            if let weightData = weightData.first(where: { $0.date == toDate.convertToString()}) {
                data.append(weightData)
            }
            toDate = Calendar.current.date(byAdding: .day, value: -1, to: toDate)!
        }
        customDurationWeightData = data.reversed()
    }
    
}
