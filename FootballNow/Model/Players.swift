import Foundation

struct Players: Codable {
  var results: Int
  var response: [PlayersResponse]
}

struct PlayersResponse: Codable {
  var player: PlayerP
  var statistics: [StatisticsP]
}

struct PlayerP: Codable {
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
  var birth: BirthP?
}

struct BirthP: Codable {
  var date: String?
  var place: String?
  var country: String?
}

struct StatisticsP: Codable {
  var team: TeamDetails?
  var league: League?
  var games: GamesP?
  var substitutes: SubstitutesP?
  var shots: ShotsP?
  var goals: GoalsP?
  var passes: PassesP?
  var tackles: TacklesP?
  var duels: DuelsP?
  var dribbles: DribblesP?
  var fouls: FoulsP?
  var cards: CardsP?
  var penalty: PenaltyP?
}

struct GamesP: Codable {
  var appearences: Int?
  var lineups: Int?
  var minutes: Int?
  var number: Int?
  var position: String?
  var rating: String?
  var captain: Bool?
}

struct SubstitutesP: Codable {
  var inNumber: Int?
  var outNumber: Int?
  var bench: Int?

  enum CodingKeys: String, CodingKey {
    case inNumber = "in"
    case outNumber = "out"
    case bench
  }
}

struct ShotsP: Codable {
  var total: Int?
  var on: Int?
}

struct GoalsP: Codable {
  var total: Int?
  var conceded: Int?
  var assists: Int?
  var saves: Int?
}

struct PassesP: Codable {
  var total: Int?
  var key: Int?
  var accuracy: Int?
}

struct TacklesP: Codable {
  var total: Int?
}

struct DuelsP: Codable {
  var total: Int?
  var won: Int?
}

struct DribblesP: Codable {
  var attempts: Int?
  var success: Int?
  var past: Int?
}

struct FoulsP: Codable {
  var drawn: Int?
  var committed: Int?
}

struct CardsP: Codable {
  var yellow: Int?
  var yellowred: Int?
  var red: Int?
}

struct PenaltyP: Codable {
  var won: Int?
  var committed: Int?
  var scored: Int?
  var missed: Int?
  var saved: Int?
}
