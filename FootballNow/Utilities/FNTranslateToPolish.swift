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
    
    
    func translateGameStatistics(from statistic: String?) -> String {
        guard let statistic = statistic else { return ""}
        
        switch statistic {
            case "Shots on Goal":
                return "Strzały celne"
            case "Shots off Goal":
                return "Strzały niecelne"
            case "Total Shots":
                return "Strzały"
            case "Blocked Shots":
                return "Strzały obronione"
            case "Shots insidebox":
                return "Shots insidebox"
            case "Shots outsidebox":
                return "Shots outsidebox"
            case "Fouls":
                return "Faule"
            case "Corner Kicks":
                return "Rzuty rożne"
            case "Offsides":
                return "Spalone"
            case "Ball Possession":
                return "Posiadanie piłki"
            case "Yellow Cards":
                return "Źółte kartki"
            case "Red Cards":
                return "Czerwone kartki"
            case "Goalkeeper Saves":
                return "Obrony bramkarza"
            case "Total passes":
                return "Podania"
            case "Passes accurate":
                return "Podania celne"
            case "Passes %":
                return "Podania celne"

            default:
                return "N/A"
        }
    }
}
