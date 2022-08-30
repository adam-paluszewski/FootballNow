//
//  Leagues.swift
//  Football
//
//  Created by Adam Paluszewski on 09/08/2022.
//

import Foundation

struct Leagues: Codable {
    var results: Int
    var response: [LeaguesData]
}

struct LeaguesData: Codable {
    var league: LeaguesLeague
    var country: LeaguesCountry
}

struct LeaguesLeague: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var logo: String?
}

struct LeaguesCountry: Codable {
    var name: String?
    var code: String?
    var flag: String?
}
