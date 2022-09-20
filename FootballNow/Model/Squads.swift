//
//  Squads.swift
//  Football
//
//  Created by Adam Paluszewski on 16/07/2022.
//

import Foundation

struct Squads: Codable {
    var response: [SquadsResponse]
    var results: Int
}






struct SquadsResponse: Codable {
    var team: SquadsTeam
    var players: [SquadsPlayer]
}


struct SquadsTeam: Codable {
    var name: String?
    var logo: String
}


struct SquadsPlayer: Codable {
    var id: Int
    var name: String
    var number: Int?
    var age: Int?
    var position: String?
    var photo: String?
}
