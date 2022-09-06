//
//  DateFormatter.swift
//  Football
//
//  Created by Adam Paluszewski on 16/08/2022.
//

import Foundation

struct FNDateFormatting {
    
    static func getYYYYMMDD(timestamp: Double) -> String{
        let matchDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY"
            
        let dateString = dateFormatter.string(from: matchDate)
        
        return dateString
    }
    
    static func getDMMM(timestamp: Double) -> String{
        let matchDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM"
            
        let dateString = dateFormatter.string(from: matchDate)
        
        return dateString
    }
    
    
    
    static func getDDMM(timestamp: Double) -> String{
        let matchDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM"
            
        let dateString = dateFormatter.string(from: matchDate)
        
        return dateString
    }
    
    
    
    static func getHHMM(timestamp: Double) -> String{
        let matchDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
            
        let dateString = dateFormatter.string(from: matchDate)
        
        return dateString
    }
    
    
    
    
}
