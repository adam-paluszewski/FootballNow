//
//  LastGame.swift
//  Football
//
//  Created by Adam Paluszewski on 17/07/2022.
//

import Foundation

struct Fixtures: Codable {
    var response: [FixturesData]
    var results: Int
}





struct FixturesData: Codable {
    var fixture: Fixture
    var teams: GameTeams
    var goals: Goals
    var events: [Events]?
}

struct Fixture: Codable {
    var timestamp: Double
    var status: Status
    var id: Int
}

struct GameTeams: Codable {
    var home: Home
    var away: Away
}

struct Home: Codable {
    var name: String
    var logo: String
    var id: Int
}

struct Away: Codable {
    var name: String
    var logo: String
    var id: Int
}

struct Goals: Codable {
    var home: Int?
    var away: Int?
}

struct Status: Codable {
    var long: String
    var short: String
    var elapsed: Int?
}

struct Events: Codable {
    var time: Time
    var player: Player
    var assist: Assist
    var type: String?
    var detail: String?
    var team: Team
}

struct Time: Codable {
    var elapsed: Int
    var extra: Int?
}

struct Player: Codable {
    var id: Int?
    var name: String
}

struct Assist: Codable {
    var id: Int?
    var name: String?
}

struct Team: Codable {
    var id: Int
    var name: String
}



