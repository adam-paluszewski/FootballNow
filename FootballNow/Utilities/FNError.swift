//
//  FNError.swift
//  Football
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import Foundation

enum FNError: String, Error {
    case invalidUsername = "This username created invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from server. Please try again"
    case invalidData = "Data received from server was invalid. Please try again."
    case cantGetMyTeam = "d"
    case unableToFavorites = "sdsd"
    case unableToMyTeam = "vv"
    case alreadyInFavorites = " ffdfd"
    
    case unableAddToFavorites = "Nie udało się dodać drużyny do ulubionych. Spróbuj ponownie"
    case unableRemoveFromFavorites = "Nie udało się usunąć drużyny z ulubionych. Spróbuj ponownie"
}
