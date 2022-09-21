//
//  Leagues.swift
//  Football
//
//  Created by Adam Paluszewski on 09/08/2022.
//

import Foundation

struct Leagues: Codable {
    var results: Int
    var response: [LeaguesResponse]
}

struct LeaguesResponse: Codable {
    var league: League?
    var country: CountryL?
}

struct League: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var logo: String?
}

struct CountryL: Codable {
    var name: String?
    var code: String?
    var flag: String?
}
