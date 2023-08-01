import UIKit

class FNStandingsCell: UITableViewCell {

  static let cellId = "StandingsCell"
  let positionLabel = FNBodyLabel(allingment: .right)
  let teamLogoImageView = UIImageView()
  let teamNameLabel = FNBodyLabel(allingment: .left)
  let gamesPlayedLabel = FNBodyLabel(allingment: .center)
  let gamesWonLabel = FNBodyLabel(allingment: .center)
  let gamesDrawLabel = FNBodyLabel(allingment: .center)
  let gamesLostLabel = FNBodyLabel(allingment: .center)
  let pointsLabel = FNBodyLabel(allingment: .center)
  let positionChangeImageView = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(standing: Standing) {
    positionLabel.text = "\(standing.rank ?? 0)"
    teamNameLabel.text = standing.team?.name
    gamesPlayedLabel.text = "\(standing.all?.played ?? 0)"
    gamesWonLabel.text = "\(standing.all?.win ?? 0)"
    gamesDrawLabel.text = "\(standing.all?.draw ?? 0)"
    gamesLostLabel.text = "\(standing.all?.lose ?? 0)"
    pointsLabel.text = "\(standing.points ?? 0)"
    NetworkManager.shared.downloadImage(from: standing.team?.logo ?? "") { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.teamLogoImageView.image = image
      }
    }
    positionChangeImageView.image = getPositionChangeImage(change: standing.status ?? "")
  }

  private func getPositionChangeImage(change: String) -> UIImage{
    var image = UIImage()
    let gradientScoreboard = CAGradientLayer()
    if change == "up" {
      image = UIImage(systemName: "arrow.up")!.withTintColor(.green, renderingMode: .alwaysOriginal)
      gradientScoreboard.colors = [UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.05).cgColor, UIColor.white.cgColor]
    } else if change == "down" {
      image = UIImage(systemName: "arrow.down")!.withTintColor(.red, renderingMode: .alwaysOriginal)
      gradientScoreboard.colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.05).cgColor, UIColor.white.cgColor]
    } else {
      image = UIImage(systemName: "minus")!.withTintColor(.gray, renderingMode: .alwaysOriginal)
      gradientScoreboard.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
    }
    return image
  }

  func configure() {
    backgroundColor = FNColors.sectionColor
    positionLabel.textColor = .secondaryLabel
    gamesPlayedLabel.textColor = .secondaryLabel
    gamesWonLabel.textColor = .secondaryLabel
    gamesDrawLabel.textColor = .secondaryLabel
    gamesLostLabel.textColor = .secondaryLabel
  }

  func addSubviews() {
    addSubview(positionLabel)
    addSubview(positionChangeImageView)
    addSubview(teamLogoImageView)
    addSubview(teamNameLabel)
    addSubview(gamesPlayedLabel)
    addSubview(gamesWonLabel)
    addSubview(gamesDrawLabel)
    addSubview(gamesLostLabel)
    addSubview(pointsLabel)

    teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    positionChangeImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      positionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      positionLabel.widthAnchor.constraint(equalToConstant: 17),

      positionChangeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      positionChangeImageView.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 3),
      positionChangeImageView.widthAnchor.constraint(equalToConstant: 12),
      positionChangeImageView.heightAnchor.constraint(equalToConstant: 12),

      teamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      teamLogoImageView.leadingAnchor.constraint(equalTo: positionChangeImageView.trailingAnchor, constant: 10),
      teamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
      teamLogoImageView.heightAnchor.constraint(equalToConstant: 25),

      pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      pointsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      pointsLabel.widthAnchor.constraint(equalToConstant: 25),

      gamesLostLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      gamesLostLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -20),
      gamesLostLabel.widthAnchor.constraint(equalToConstant: 17),

      gamesDrawLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      gamesDrawLabel.trailingAnchor.constraint(equalTo: gamesLostLabel.leadingAnchor, constant: -15),
      gamesDrawLabel.widthAnchor.constraint(equalToConstant: 17),

      gamesWonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      gamesWonLabel.trailingAnchor.constraint(equalTo: gamesDrawLabel.leadingAnchor, constant: -15),
      gamesWonLabel.widthAnchor.constraint(equalToConstant: 17),

      gamesPlayedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      gamesPlayedLabel.trailingAnchor.constraint(equalTo: gamesWonLabel.leadingAnchor, constant: -15),
      gamesPlayedLabel.widthAnchor.constraint(equalToConstant: 17),

      teamNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      teamNameLabel.leadingAnchor.constraint(equalTo: teamLogoImageView.trailingAnchor, constant: 5),
      teamNameLabel.trailingAnchor.constraint(equalTo: gamesPlayedLabel.leadingAnchor, constant: -5),
    ])
  }

}
