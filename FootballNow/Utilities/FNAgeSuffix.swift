import Foundation

class FNAgeSuffix {

  static let shared = FNAgeSuffix()

  func ageSuffix(age: Int?) -> String {
    guard let age = age else { return ""}
    switch age {
      case 10...21, 25...31, 35...41, 45...51:
        return "\(age) lat"
      case 22...24, 32...34, 42...44, 52...54:
        return "\(age) lata"
      default:
        return ""
    }
  }

}
