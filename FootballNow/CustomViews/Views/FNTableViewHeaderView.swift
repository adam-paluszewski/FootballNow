import UIKit

class FNTableViewHeaderView: UIView {

  let titleLabel = FNBodyLabel(allingment: .left)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(text: String) {
    super.init(frame: .zero)
    titleLabel.text = text
    configure()
    addSubviews()
  }

  func configure() {
    backgroundColor = FNColors.backgroundColor
    titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
  }

  func addSubviews() {
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
    ])
  }

}
