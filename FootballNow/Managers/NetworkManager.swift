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
}

