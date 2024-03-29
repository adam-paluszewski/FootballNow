import UIKit

class FNSearchResultCell: UITableViewCell {

  static let cellId = "SearchResultCell"
  let teamLogoImageView = UIImageView()
  let teamNameLabel = FNBodyLabel(allingment: .left)
  let addToFavoritesButton = UIButton()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    self.backgroundColor = FNColors.sectionColor
    addToFavoritesButton.tintColor = .systemRed
  }

  func addSubviews() {
    addSubview(teamLogoImageView)
    addSubview(teamNameLabel)
    contentView.addSubview(addToFavoritesButton)

    teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      teamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      teamLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      teamLogoImageView.widthAnchor.constraint(equalToConstant: 40),
      teamLogoImageView.heightAnchor.constraint(equalToConstant: 40),

      teamNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      teamNameLabel.leadingAnchor.constraint(equalTo: teamLogoImageView.trailingAnchor, constant: 10),
      teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

      addToFavoritesButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      addToFavoritesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      addToFavoritesButton.widthAnchor.constraint(equalToConstant: 50),
      addToFavoritesButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }

  func set(team: TeamDetails) {
    teamNameLabel.text = team.name
    PersistenceManager.shared.checkIfTeamIsInFavorites(teamId: team.id) { isInFavorites in
      switch isInFavorites {
        case true:
          addToFavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        case false:
          addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
      }
    }
    NetworkManager.shared.downloadImage(from: team.logo) { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.teamLogoImageView.image = image
      }
    }
  }

}
