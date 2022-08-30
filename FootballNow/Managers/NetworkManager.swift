//
//  NetworkManager.swift
//  Football
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://v3.football.api-sports.io/"
    let cache = NSCache<NSString, UIImage>()
    
    func getFixtures(parameters: String, completionHandler: @escaping (Result<Fixtures, FNError>) -> Void) {
        let endpoint = baseURL + "fixtures/?\(parameters)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("b1472209bfea9fee33f555e21eac2b9e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let fixtures = try decoder.decode(Fixtures.self, from: data)
                completionHandler(.success(fixtures))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getStandings(parameters: String, completionHandler: @escaping (Result<Standings, FNError>) -> Void) {
        let endpoint = baseURL + "standings/?\(parameters)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("b1472209bfea9fee33f555e21eac2b9e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let standings = try decoder.decode(Standings.self, from: data)
                completionHandler(.success(standings))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getSquads(parameters: String, completionHandler: @escaping (Result<Squads, FNError>) -> Void) {
        let endpoint = baseURL + "players/squads/?\(parameters)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("b1472209bfea9fee33f555e21eac2b9e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let squads = try decoder.decode(Squads.self, from: data)
                completionHandler(.success(squads))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getTeams(parameters: String, completionHandler: @escaping (Result<Teams, FNError>) -> Void) {
        let endpoint = baseURL + "teams/?\(parameters)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("b1472209bfea9fee33f555e21eac2b9e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let teams = try decoder.decode(Teams.self, from: data)
                completionHandler(.success(teams))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getLeagues(parameters: String, completionHandler: @escaping (Result<Leagues, FNError>) -> Void) {
        let endpoint = baseURL + "leagues/?\(parameters)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("b1472209bfea9fee33f555e21eac2b9e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("v3.football.api-sports.io", forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let leagues = try decoder.decode(Leagues.self, from: data)
                completionHandler(.success(leagues))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completionHandler: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completionHandler(image)
        }
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            
            completionHandler(image)
        }
        task.resume()
    }
}

