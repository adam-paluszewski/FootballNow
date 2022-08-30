//
//  Scoreboard.swift
//  Football
//
//  Created by Adam Paluszewski on 19/07/2022.
//

import Foundation



struct Standings: Codable {
    var response: [StandingsData]
    var results: Int
}


struct StandingsData: Codable {
    var league: League
}

struct League: Codable {
    var id: Int?
    var name: String?
    var country: String?
    var logo: String?
    var flag: String?
    var standings: [[Standing]]
    var season: Int?
}

struct Standing: Codable {
    var rank: Int?
    var points: Int?
    var goalsDiff: Int?
    var description: String?
    var team: StandingTeam
    var status: String?
    var all: All
}

struct StandingTeam: Codable {
    var name: String?
    var logo: String?
    var id: Int?
}

struct All: Codable {
    var played: Int?
    var win: Int?
    var draw: Int?
    var lose: Int?
    var goals: GoalsStandings
}

struct GoalsStandings: Codable {
    var ckey: Int?
    var against: Int?
            
    enum CodingKeys: String, CodingKey {
        case ckey = "for"
        case against
    }
}
