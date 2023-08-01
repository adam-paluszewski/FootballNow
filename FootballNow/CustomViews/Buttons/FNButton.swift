import UIKit

class FNButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    configuration = .filled()
    configuration?.baseForegroundColor = .label
    configuration?.cornerStyle = .medium
    configuration?.imagePlacement = .leading
    configuration?.imagePadding = 5

    configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = Fonts.body
      return outgoing
    }
  }

}
