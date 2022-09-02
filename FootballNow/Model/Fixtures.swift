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
    var league: FixturesLeague
    var statistics: [Statistics]?
    var lineups: [Lineups]?
}

struct Lineups: Codable {
    var formation: String?
    var startXI: [StartXI]?
    var substitutes: [Substitutes]?
    var coach: Coach?
}

struct StartXI: Codable {
    var player: FixturesPlayer?
}

struct FixturesPlayer: Codable {
    var id: Int?
    var name: String?
    var number: Int?
    var pos: String?
    var grid: String?
}

struct Substitutes: Codable {
    var player: FixturesPlayer?
}

struct Coach: Codable {
    var id: Int?
    var name: String?
    var photo: String?
}

struct Fixture: Codable {
    var timestamp: Double
    var status: Status
    var id: Int
}

struct Statistics: Codable {
    var ckey: [FixtureStatistics]?
    
    enum CodingKeys: String, CodingKey {
        case ckey = "statistics"
    }
}

struct FixtureStatistics: Codable {
    var type: String?
    var value: MetadataType?
}

struct FixturesLeague: Codable {
    var name: String
    var logo: String
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
    var elapsed: Int?
    var extra: Int?
}

struct Player: Codable {
    var id: Int?
    var name: String?
}

struct Assist: Codable {
    var id: Int?
    var name: String?
}

struct Team: Codable {
    var id: Int?
    var name: String?
}




//statistics returns Int or String type
enum MetadataType: Codable {
  case int(Int)
  case string(String)
    

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = try .int(container.decode(Int.self))
    } catch DecodingError.typeMismatch {
      do {
        self = try .string(container.decode(String.self))
      } catch DecodingError.typeMismatch {
        throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .int(let int):
      try container.encode(int)
    case .string(let string):
      try container.encode(string)
    }
  }
}
