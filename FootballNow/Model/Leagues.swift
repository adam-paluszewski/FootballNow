import Foundation

struct Leagues: Codable {
  var results: Int
  var response: [LeaguesResponse]
}

struct LeaguesResponse: Codable, Hashable {
  var league: League?
  var country: CountryL?
}

struct League: Codable, Hashable {
  var id: Int?
  var name: String?
  var type: String?
  var logo: String?
}

struct CountryL: Codable, Hashable {
  var name: String?
  var code: String?
  var flag: String?
}
