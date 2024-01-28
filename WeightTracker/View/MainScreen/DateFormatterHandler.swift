//
//  DateFormatter.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 28.01.2024.
//

import Foundation

class DateFormatterHandler {
    
    public let dateFormatter = DateFormatter()
    
    func convertDateToStr(date: Date) -> String {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
        
    }
    
    func convertStrToDate(string: String) -> Date {
        return Date()
    }
    
    
}
