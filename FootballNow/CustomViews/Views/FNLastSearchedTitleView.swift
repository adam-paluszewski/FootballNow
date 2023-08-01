import UIKit

class FNLastSearchedTitleView: UIView {

  let titleLabel = FNBodyLabel(allingment: .left)
  let removeAllButton = FNButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    backgroundColor = FNColors.backgroundColor
    titleLabel.text = "Ostatnio wyszukiwane"
    titleLabel.textColor = .secondaryLabel
    removeAllButton.configuration = .plain()
    removeAllButton.setTitle("WYCZYŚĆ", for: .normal)
    removeAllButton.configuration?.image = nil
    removeAllButton.contentHorizontalAlignment = .trailing
    removeAllButton.tintColor = UIColor(named: "FNNavigationTint")
  }

  func addSubviews() {
    addSubview(titleLabel)
    addSubview(removeAllButton)

    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),

      removeAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      removeAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      removeAllButton.widthAnchor.constraint(equalToConstant: 110)
    ])
  }

}
