import UIKit

class FNAlertContainerView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground
    layer.borderWidth = 2
    layer.borderColor = UIColor.secondaryLabel.cgColor
  }

}
