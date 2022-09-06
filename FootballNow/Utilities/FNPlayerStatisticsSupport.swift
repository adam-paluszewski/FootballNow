//
//  FNPlayerStatisticsSupport.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class FNPlayerStatisticsSupport {
    static let shared = FNPlayerStatisticsSupport()
    
    func getNumberOfRowsInSection(for section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 1:
                return 3
            case 2:
                return 2
            case 3:
                return 2
            case 4:
                return 3
            case 5:
                return 1
            case 6:
                return 2
            case 7:
                return 3
            case 8:
                return 2
            case 9:
                return 3
            case 10:
                return 2
            default:
                return 0
        }
    }
    
    
    func getViewForHeaderInSection(for section: Int) -> UIView {
        switch section {
            case 0:
                return FNFormationsHeaderView(title: "Mecze",allingment: .left)
            case 1:
                return FNFormationsHeaderView(title: "Zmiany",allingment: .left)
            case 2:
                return FNFormationsHeaderView(title: "Strzały",allingment: .left)
            case 3:
                return FNFormationsHeaderView(title: "Gole",allingment: .left)
            case 4:
                return FNFormationsHeaderView(title: "Podania",allingment: .left)
            case 5:
                return FNFormationsHeaderView(title: "Spalone",allingment: .left)
            case 6:
                return FNFormationsHeaderView(title: "Pojedynki",allingment: .left)
            case 7:
                return FNFormationsHeaderView(title: "Zwody",allingment: .left)
            case 8:
                return FNFormationsHeaderView(title: "Faule",allingment: .left)
            case 9:
                return FNFormationsHeaderView(title: "Kartki",allingment: .left)
            case 10:
                return FNFormationsHeaderView(title: "Rzuty karne",allingment: .left)
            default:
                return UIView()
        }
    }
}
