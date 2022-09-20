//
//  Players.swift
//  Football
//
//  Created by Adam Paluszewski on 09/08/2022.
//

import Foundation

struct Players: Codable {
    var results: Int
    var response: [PlayersResponse]
}

struct PlayersResponse: Codable {
    var player: PlayersPlayer
    var statistics: [PlayerStatistics]
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

struct PlayerStatistics: Codable {
    var team: TeamDetails
    var league: LeaguesLeague
    var games: PlayerGames
    var substitutes: PlayerSubstitutes
    var shots: PlayerShots
    var goals: PlayerGoals
    var passes: PlayerPasses
    var tackles: PlayerTackles
    var duels: PlayerDuels
    var dribbles: PlayerDribbles
    var fouls: PlayerFouls
    var cards: PlayerCards
    var penalty: PlayerPenalty
}

struct PlayerGames: Codable {
    var appearences: Int?
    var lineups: Int?
    var minutes: Int?
    var number: Int?
    var position: String?
    var rating: String?
    var captain: Bool?
}

struct PlayerSubstitutes: Codable {
    var inNumber: Int?
    var outNumber: Int?
    var bench: Int?
    
    enum CodingKeys: String, CodingKey {
        case inNumber = "in"
        case outNumber = "out"
        case bench
    }
}

struct PlayerShots: Codable {
    var total: Int?
    var on: Int?
}

struct PlayerGoals: Codable {
    var total: Int?
    var conceded: Int?
    var assists: Int?
    var saves: Int?
}

struct PlayerPasses: Codable {
    var total: Int?
    var key: Int?
    var accuracy: Int?
}

struct PlayerTackles: Codable {
    var total: Int?
}

struct PlayerDuels: Codable {
    var total: Int?
    var won: Int?
}

struct PlayerDribbles: Codable {
    var attempts: Int?
    var success: Int?
    var past: Int?
}

struct PlayerFouls: Codable {
    var drawn: Int?
    var committed: Int?
}

struct PlayerCards: Codable {
    var yellow: Int?
    var yellowred: Int?
    var red: Int?
}

struct PlayerPenalty: Codable {
    var won: Int?
    var committed: Int?
    var scored: Int?
    var missed: Int?
    var saved: Int?
}
