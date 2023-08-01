import Foundation

enum PersistanceActionType {
  case add, remove
}

struct PersistenceManager {

  enum Keys: String {
    case favorites = "favorites"
    case myTeam = "myteam"
    case lastSearched = "lastsearched"
    case myLeagues = "myleagues"
  }

  static let shared = PersistenceManager()
  private let defaults = UserDefaults.standard

  func save<T: Codable>(_ passed: T, for key: Keys) -> FNError? {
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(passed)
      defaults.set(encodedData, forKey: key.rawValue)
    }
    catch {
      return .unableToFavorites
    }
    return nil
  }

  func retrieveMyTeam(completionHandler: (Result<TeamDetails?,FNError>) -> Void) {
    guard let myTeamData = defaults.object(forKey: Keys.myTeam.rawValue) as? Data else {
      completionHandler(.success(nil))
      return
    }
    do {
      let decoder = JSONDecoder()
      let myTeam = try decoder.decode(TeamDetails.self, from: myTeamData)
      completionHandler(.success(myTeam))
    }
    catch {
      completionHandler(.failure(.invalidData))
    }
  }

  func retrieveFavorites(completionHandler: (Result<[TeamDetails],FNError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favorites.rawValue) as? Data else {
      completionHandler(.success([]))
      return
    }
    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([TeamDetails].self, from: favoritesData)
      completionHandler(.success(favorites))
    }
    catch {
      completionHandler(.failure(.unableToFavorites))
    }
  }

  func retrieveLastSearched(completionHandler: (Result<[TeamDetails],FNError>) -> Void) {
    guard let lastSearchedData = defaults.object(forKey: Keys.lastSearched.rawValue) as? Data else {
      completionHandler(.success([]))
      return
    }
    do {
      let decoder = JSONDecoder()
      let lastSearched = try decoder.decode([TeamDetails].self, from: lastSearchedData)
      completionHandler(.success(lastSearched))
    }
    catch {
      completionHandler(.failure(.invalidData))
    }
  }


  func retrieveMyLeagues(completionHandler: (Result<[LeaguesResponse],FNError>) -> Void) {
    guard let leaguesData = defaults.object(forKey: Keys.myLeagues.rawValue) as? Data else {
      completionHandler(.success([]))
      return
    }
    do {
      let decoder = JSONDecoder()
      let leagues = try decoder.decode([LeaguesResponse].self, from: leaguesData)
      completionHandler(.success(leagues))
    }
    catch {
      completionHandler(.failure(.unableToFavorites))
    }
  }

  func checkIfTeamIsInFavorites(teamId: Int?, completionHandler: (Bool) -> Void) {
    PersistenceManager.shared.retrieveFavorites { result in
      switch result {
        case .success(let favorites):
          let isTeamInFavorites = favorites.filter{$0.id == teamId}.count == 0 ? false : true
          completionHandler(isTeamInFavorites)
        case .failure(_):
          completionHandler(false)
      }
    }
  }

  func updateWith(favorite: TeamDetails, actionType: PersistanceActionType, completionHandler: (FNError?) -> Void) {
    retrieveFavorites { result in
      switch result {
        case .success(var favorites):
          switch actionType {
            case .add:
              guard !favorites.contains(favorite) else {
                completionHandler(.alreadyInFavorites)
                return
              }
              favorites.append(favorite)
            case .remove:
              favorites.removeAll {$0.id == favorite.id}
          }
          completionHandler(save(favorites, for: .favorites))
        case .failure(let error):
          completionHandler(error)
      }
    }
  }

  func updateWith(league: LeaguesResponse, actionType: PersistanceActionType, completionHandler: (FNError?) -> Void) {
    retrieveMyLeagues { result in
      switch result {
        case .success(var leagues):
          switch actionType {
            case .add:
              guard !leagues.contains(league) else {
                completionHandler(.alreadyInFavorites)
                return
              }
              leagues.append(league)
            case .remove:
              leagues.removeAll {$0.league?.id == league.league?.id}
          }
          completionHandler(save(leagues, for: .myLeagues))
        case .failure(let error):
          completionHandler(error)
      }
    }
  }

}
