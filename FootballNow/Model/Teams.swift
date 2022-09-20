//
//  Teams.swift
//  Football
//
//  Created by Adam Paluszewski on 15/07/2022.
//

import Foundation

struct Teams: Codable {
    var response: [TeamsResponse]
    var results: Int
}






struct TeamsResponse: Codable, Hashable {
    var team: TeamDetails
}



struct TeamDetails: Codable, Hashable {
    var id: Int
    var name: String
    var code: String?
    var country: String?
    var founded: Int?
    var logo: String
}
