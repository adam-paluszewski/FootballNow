//
//  Players.swift
//  Football
//
//  Created by Adam Paluszewski on 09/08/2022.
//

import Foundation

struct Players: Codable {
    var results: Int
    var response: [PlayersData]
}

struct PlayersData: Codable {
    var player: PlayersPlayer
}

struct PlayersPlayer: Codable {
    var id: Int
    var name: String?
    var firstname: String?
    var lastname: String?
    var age: Int?
    var nationality: String?
    var height: String?
    var weight: String?
    var injured: Bool?
    var photo: String?
    var birth: PlayersBirth
}

struct PlayersBirth: Codable {
    var date: String?
    var place: String?
    var country: String?
}
