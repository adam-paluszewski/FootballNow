//
//  FNTranslateToPolish.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import Foundation

class FNTranslateToPolish {
    static let shared = FNTranslateToPolish()
    
    func translatePlayerPosition(from position: String?) -> String {
        guard let position = position else { return ""}
        
        switch position {
            case "Goalkeeper":
                return "bramkarz"
            case "Defender":
                return "obrońca"
            case "Midfielder":
                return "pomocnik"
            case "Attacker":
                return "napastnik"
            default:
                return "N/A"
        }
    }
}
