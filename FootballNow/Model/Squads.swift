//
//  Squads.swift
//  Football
//
//  Created by Adam Paluszewski on 16/07/2022.
//

import Foundation

struct Squads: Codable {
    var response: [SquadsData]
    var results: Int
}






struct SquadsData: Codable {
    var players: [SquadsPlayer]
}


struct SquadsPlayer: Codable {
    var name: String
    var number: Int?
    var age: Int?
    var position: String?
    var photo: String?
}
