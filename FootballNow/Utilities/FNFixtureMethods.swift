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

}
