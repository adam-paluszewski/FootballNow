import UIKit

struct FNAttributedStrings {

  static func getAttributedDate(for dateString: String) -> NSMutableAttributedString {
    var attributedString: NSMutableAttributedString
    attributedString = NSMutableAttributedString(string: dateString, attributes: nil)
    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: 2))
    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 2, length: 3))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: 2, length: 3))
    return attributedString
  }
}
