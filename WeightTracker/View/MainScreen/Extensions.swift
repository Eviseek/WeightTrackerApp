//
//  Extensions.swift
//  WeightTracker
//
//  Created by Eva Chlpikova on 17.02.2024.
//

import Foundation

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
