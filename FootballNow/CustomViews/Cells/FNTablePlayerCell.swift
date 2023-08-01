import UIKit

class FNTablePlayerCell: UITableViewCell {

  static let cellId = "TablePlayerCell"
  let cache = NetworkManager.shared.cache
  let photoImageView = UIImageView()
  let nameLabel = FNBodyLabel(allingment: .left)
  let ageLabel = FNBodyLabel(allingment: .left)
  let numberLabel = FNBodyLabel(allingment: .center)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(player: PlayerSq) {
    nameLabel.text = player.name
    ageLabel.text = FNAgeSuffix.shared.ageSuffix(age: player.age)
    if let photo = player.photo {
      NetworkManager.shared.downloadImage(from: photo) { [weak self] image in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.photoImageView.image = image
        }
      }
    }
  }

  func configure() {
    backgroundColor = FNColors.sectionColor
    accessoryType = .disclosureIndicator
    photoImageView.clipsToBounds = true
    photoImageView.layer.cornerRadius = 30
    ageLabel.textColor = .secondaryLabel
  }

  func addSubviews() {
    addSubview(photoImageView)
    addSubview(numberLabel)
    addSubview(nameLabel)
    addSubview(ageLabel)
    photoImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      photoImageView.widthAnchor.constraint(equalToConstant: 60),
      photoImageView.heightAnchor.constraint(equalToConstant: 60),

      nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
      nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),

      ageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
      ageLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
      ageLabel.widthAnchor.constraint(equalToConstant: 100),
    ])
  }

}
