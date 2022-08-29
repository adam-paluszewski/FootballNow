//
//  FNConstants.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 27/08/2022.
//

import UIKit

struct SectionHeight {
    //40 stands for header height and 1 stands for separator height in section
    static let teamDashboardLastGameHeight: Double = 40+1+100
    static let teamDashboardStandingsHeight: Double = 40+1+80
    static let teamDashboardNextGamesHeight: Double = 40+1+(3*UIElementsSizes.nextGameCellHeight)-0.5 //-0.5 to hides last cell separator
    static let teamDashboardSquadHeight: Double = 40+1+210
}

struct UIElementsSizes {
    static let teamDashboardPlayerCellHeight: Double = SectionHeight.teamDashboardSquadHeight - 70
    static let nextGameCellHeight: Double = 100
    static let lastGameCellHeight: Double = nextGameCellHeight
    static let standardTableViewSeparatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
}


struct NotificationKeys {
    static let teamIsSelectedNotificationKey = "com.adamp.temIsSelected"
}
