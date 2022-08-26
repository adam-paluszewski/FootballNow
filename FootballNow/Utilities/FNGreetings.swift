//
//  Greetings.swift
//  Football
//
//  Created by Adam Paluszewski on 27/07/2022.
//

import Foundation


struct FNGreetings {
    
    
    
    static func getGreetings(teamId: Int) -> String {
        
        switch teamId {
        case 3491:
            return "kibicu Rakowa!"
        case 341:
            return "kibicu Wisły!"
        case 350:
            return "kibicu Cracovi!"
        case 3493:
            return "kibicu Stali!"
        case 339:
            return "kibicu Legii!"
        case 337:
            return "kibicu Śląska!"
        case 6962:
            return "kibicu Widzewa!"
        case 348:
            return "kibicu Pogoni!"
        case 336:
            return "kibicu Jagielloni!"
        case 4248:
            return "kibicu Radomiaka!"
        case 335:
            return "kibicu Miedzi!"
        case 346:
            return "kibicu Korony!"
        case 345:
            return "kibicu Zagłębia!"
        case 340:
            return "kibicu Górnika!"
        case 349:
            return "kibicu Piasta!"
        case 347:
            return "kibicu Lecha!"
        case 343:
            return "kibicu Lechii!"
        case 3496:
            return "kibicu Warty!"
            
        default:
            return "error"
        }
        
    }
    
}
