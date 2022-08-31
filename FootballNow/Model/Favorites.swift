//
//  Favorites.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import Foundation

class Favorites {
    static let shared = Favorites()
    
    var favoritesTeams: [TeamsData] = []
    
    
    
    //saving and loading (in appdelegate) Favorites data
    private let manager = UserDefaults.standard
    
    func get(_ key: String) {
        if let data = manager.data(forKey: key) {
            let decoder = JSONDecoder()
            
            if let favoritesTeams = try? decoder.decode([TeamsData].self, from: data) {
                self.favoritesTeams = favoritesTeams
            }
        }
    }
    
    
    func set(_ key: String, object: [TeamsData]) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        
        manager.set(data, forKey: key)
    }
    
    
    func isTeamInFavorites(id: Int) -> Bool {
        return favoritesTeams.filter{$0.team.id == id}.count == 0 ? false : true
    }
}
