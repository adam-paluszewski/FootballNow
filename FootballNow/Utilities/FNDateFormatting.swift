import Foundation

struct FNDateFormatting {

  static func getYYYYMMDD(timestamp: Double?) -> String{
    guard let timestamp = timestamp else {
      return ""
    }
    let matchDate = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM YYYY"
    let dateString = dateFormatter.string(from: matchDate)
    return dateString
  }

  static func getDMMM(timestamp: Double?) -> String{
    guard let timestamp = timestamp else {
      return ""
    }
    let matchDate = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E d MMM"
    let dateString = dateFormatter.string(from: matchDate)
    return dateString
  }

  static func getDDMM(timestamp: Double?) -> String{
    guard let timestamp = timestamp else {
      return ""
    }
    let matchDate = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM"
    let dateString = dateFormatter.string(from: matchDate)
    return dateString
  }

  static func getHHMM(timestamp: Double?) -> String{
    guard let timestamp = timestamp else {
      return ""
    }
    let matchDate = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let dateString = dateFormatter.string(from: matchDate)
    return dateString
  }

  enum DatePossibilities {
    case current, oneWeekAhead
  }

  static func getDateYYYYMMDD(for date: DatePossibilities) -> String {
    let currentDate = Date()
    let oneWeekAheadDate = Date(timeIntervalSinceNow: 518400)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    switch date {
      case .current:
        return dateFormatter.string(from: currentDate)
      case .oneWeekAhead:
        return dateFormatter.string(from: oneWeekAheadDate)
    }
  }

}
