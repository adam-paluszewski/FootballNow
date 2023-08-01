import UIKit

class FNChipCell: UICollectionViewCell {

  static let cellId = "FNChipCell"
  let stackView = UIStackView()
  let thumbnailImage = UIImageView()
  let titleLabel = FNBodyLabel(allingment: .center)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    backgroundColor = FNColors.sectionColor
    layer.borderWidth = 1
    layer.borderColor = UIColor.label.cgColor
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    thumbnailImage.tintColor = .label
  }

  func addSubviews() {
    addSubview(stackView)
    stackView.addArrangedSubview(thumbnailImage)
    stackView.addArrangedSubview(titleLabel)
    stackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

      thumbnailImage.widthAnchor.constraint(equalToConstant: 25),
      thumbnailImage.heightAnchor.constraint(equalToConstant: 25),
    ])
  }

  func set(text: String, image: UIImage?) {
    titleLabel.text = text
    if image == nil {
      thumbnailImage.isHidden = true
    } else {
      thumbnailImage.isHidden = false
      thumbnailImage.image = image
    }
  }

  func selected() {
    backgroundColor = .tertiarySystemBackground
    layer.borderColor = UIColor(named: "FNNavigationTint")?.cgColor
    layer.borderWidth = 2
    thumbnailImage.tintColor = UIColor(named: "FNNavigationTint")
  }

  func deselected() {
    backgroundColor = FNColors.sectionColor
    titleLabel.textColor = .label
    layer.borderColor = UIColor.label.cgColor
    layer.borderWidth = 1
    thumbnailImage.tintColor = .label
  }

}
