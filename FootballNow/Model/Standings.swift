//
//  Scoreboard.swift
//  Football
//
//  Created by Adam Paluszewski on 19/07/2022.
//

import Foundation



struct Standings: Codable {
    var response: [StandingsResponse]
    var results: Int
}


struct StandingsResponse: Codable {
    var league: LeagueS?
}

struct LeagueS: Codable {
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
    var team: TeamSt?
    var status: String?
    var all: All?
}

struct TeamSt: Codable {
    var name: String?
    var logo: String?
    var id: Int?
}

struct All: Codable {
    var played: Int?
    var win: Int?
    var draw: Int?
    var lose: Int?
    var goals: GoalsS?
}

struct GoalsS: Codable {
    var ckey: Int?
    var against: Int?
            
    enum CodingKeys: String, CodingKey {
        case ckey = "for"
        case against
    }
}
