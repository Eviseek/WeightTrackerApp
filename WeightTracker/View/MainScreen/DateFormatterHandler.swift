//
//  DateFormatter.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 28.01.2024.
//

import Foundation

class DateFormatterHandler {
    
    func convertDateToStr(date: Date) -> String {
        
        Date.myFormatter.dateFormat = "d.M.yyyy"
        return Date.myFormatter.string(from: date)
    }
    
    func convertStrToDate(string: String) -> Date {
        
        if let date = Date.myFormatter.date(from: string) {
            return date
        }
        return Date()
    }
    
}

extension Date {
    
   static var myFormatter: DateFormatter = {
       
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       return formatter
   }()
    
    func convertToString() -> String {
        
        Date.myFormatter.dateFormat = "d.M.yyyy"
        return Date.myFormatter.string(from: self)
    }
    
}

extension String {
    
    func convertToDate() -> Date {
        
        if let date = Date.myFormatter.date(from: self) {
            return date
        }
        return Date()
    }
    
}
    
