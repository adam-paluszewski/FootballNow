
import Foundation

struct FNFixtureMethods {
    
    static func getGameStartTime(timestamp: Double?, gameStatus: String?) -> String? {
        
        switch gameStatus {
            case "TBD":
                return nil
            case "PST":
                return nil
            case "CANC":
                return nil
                
            default:
                return FNDateFormatting.getHHMM(timestamp: timestamp)
        }

    }
    
    
    
    static func getGameStatus(for status: String?) -> String {
        
        switch status {
            case "TBD": // time to be defined
                return "Godzina do ustalenia"
            case "NS": // not started
                return "Nie rozpoczął się"
            case "1H": // first half
                return "1. połowa"
            case "HT": // halftime
                return "Przerwa"
            case "2H": // second half
                return "2. połowa"
            case "ET": // extra time
                return "Dogrywka"
            case "P": // penalties
                return "Rzuty karne"
            case "FT": // match finished
                return "Zakończony"
            case "AET": // match finished after extra time
                return "Zakończony"
            case "PEN": // match finished after penalties
                return "Zakończony"
            case "BT": // break time in extra time
                return "Przerwa"
            case "SUSP": // match suspended
                return "Zawieszony"
            case "INT": // match interrupted
                return "Przerwany"
            case "PST": // match postponed
                return "Przełożony"
            case "CANC": // match canceled
                return "Anulowany"
            case "ABD": // match abandoned
                return "Porzucony"
            case "AWD": // technical loss
                return "Porażka techniczna"
            case "WO": // walkover
                return "Walkover"
            case "Live": // in progress
                return "W trakcie"
                
            default:
                return "aaa"
        }
        
    }
    
    
    static func getElapsedTime(elapsed: Int?, gameStatus: String?) -> String {
        guard let elapsed = elapsed else { return ""}
        
        switch elapsed {
            case 1...200:
                if gameStatus == "1H", gameStatus == "2H", gameStatus == "ET" {
                    return "\(elapsed)'"
                }
                else {
                    return ""
                }
                
            default:
                return ""
        }
    }
    
    
 
}
