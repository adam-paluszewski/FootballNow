//
//  Teams.swift
//  Football
//
//  Created by Adam Paluszewski on 15/07/2022.
//

import Foundation

struct Teams: Codable {
    var response: [TeamsData]
    var results: Int
}






struct TeamsData: Codable {
    var team: TeamT
}



struct TeamT: Codable {
    var id: Int
    var name: String
    var code: String?
    var country: String?
    var founded: Int?
    var logo: String
}
