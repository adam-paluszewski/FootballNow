//
//  FNConstants.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 27/08/2022.
//

import UIKit

struct SectionHeight {
    //40 stands for header height and 1 stands for separator height in section
    static let teamDashboardLastGameHeight: Double = 40+1+103
    static let teamDashboardStandingsHeight: Double = 40+1+80
    static let teamDashboardNextGamesHeight: Double = 40+1+(3*UIElementsSizes.nextGameCellHeight)-0.5 //-0.5 to hides last cell separator
    static let teamDashboardSquadHeight: Double = 40+1+210
}

struct UIElementsSizes {
    static let teamDashboardPlayerCellHeight: Double = SectionHeight.teamDashboardSquadHeight - 70
    static let nextGameCellHeight: Double = 90
    static let lastGameCellHeight: Double = nextGameCellHeight
    static let standardTableViewSeparatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
}


struct NotificationKeys {
    static let selectedTeam = "com.adamp.selectedteam"
    static let myLeaguesChanged = "com.adamp.myleagueschanged"
}


struct FNColors {
    static let backgroundColor = UIColor(named: "FNBackgroundColor")
    static let separatorColor = UIColor(named: "FNSeparatorColor")
    static let sectionColor = UIColor(named: "FNSectionColor")
}


struct SFSymbols {
    static let settings = UIImage(systemName: "gearshape")
    static let followers = UIImage(systemName: "person.2")!
    static let following = UIImage(systemName: "heart")!
    static let error = UIImage(systemName: "x.circle")!
    static let success = UIImage(systemName: "checkmark.circle")!
    static let search = UIImage(systemName: "magnifyingglass.circle.fill")!
    static let person = UIImage(systemName: "person")!
    static let person2 = UIImage(systemName: "person.2")!
}


struct Fonts {
    static let body = UIFont.systemFont(ofSize: 14, weight: .regular)
    
}


enum EmptyStateImages: String {
    case defaultImage = "FNDefault"
    case statistics = "FNStatistics"
    case formations = "FNTeam"
    case progress = "FNProgress"
    case favorite = "FNFavorite"
    case noSearchResults = "FNNoSearchResults"
}


enum EmptyStateSizes {
    case big, medium, small
}
