import UIKit

class FNMyTeamStandingsView: UIView {

  let descriptionView = UIView()
  let standingsView = UIView()
  let positionDescLabel = FNTinyLabel(allingment: .left)
  let winDescLabel = FNTinyLabel(allingment: .center)
  let drawDescLabel = FNTinyLabel(allingment: .center)
  let lostDescLabel = FNTinyLabel(allingment: .center)
  let pointsDescLabel = FNTinyLabel(allingment: .center)
  let positionLabel = FNLargeTitleLabel(allingment: .center)
  let winLabel = FNBodyLabel(allingment: .center)
  let drawLabel = FNBodyLabel(allingment: .center)
  let lostLabel = FNBodyLabel(allingment: .center)
  let pointsLabel = FNBodyLabel(allingment: .center)
  let teamLogoImageView = UIImageView()
  let teamNameLabel = FNBodyLabel(allingment: .left)
  let gradientIndicator = CAGradientLayer()
  let positionChangeImageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(standing: Standing) {
    positionDescLabel.text = "Pozycja"
    winDescLabel.text = "Z"
    drawDescLabel.text = "R"
    lostDescLabel.text = "P"
    pointsDescLabel.text = "Punkty"
    positionLabel.text = "\(standing.rank ?? 0)"
    teamNameLabel.text = standing.team?.name ?? "b/d"
    winLabel.text = "\(standing.all?.win ?? 0)"
    drawLabel.text = "\(standing.all?.draw ?? 0)"
    lostLabel.text = "\(standing.all?.lose ?? 0)"
    pointsLabel.text = "\(standing.points ?? 0)"
    positionChangeImageView.image = getPositionChangeImage(change: standing.status ?? "")

    NetworkManager.shared.downloadImage(from: standing.team?.logo ?? "") { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.teamLogoImageView.image = image
      }
    }
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

  func addSubviews() {
    addSubview(descriptionView)
    addSubview(standingsView)

    descriptionView.addSubview(positionDescLabel)
    descriptionView.addSubview(winDescLabel)
    descriptionView.addSubview(drawDescLabel)
    descriptionView.addSubview(lostDescLabel)
    descriptionView.addSubview(pointsDescLabel)

    standingsView.addSubview(positionLabel)
    standingsView.addSubview(positionChangeImageView)
    standingsView.addSubview(winLabel)
    standingsView.addSubview(drawLabel)
    standingsView.addSubview(lostLabel)
    standingsView.addSubview(pointsLabel)
    standingsView.addSubview(teamLogoImageView)
    standingsView.addSubview(teamNameLabel)

    self.translatesAutoresizingMaskIntoConstraints = false
    descriptionView.translatesAutoresizingMaskIntoConstraints = false
    standingsView.translatesAutoresizingMaskIntoConstraints = false
    teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    positionChangeImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      descriptionView.topAnchor.constraint(equalTo: self.topAnchor),
      descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      descriptionView.heightAnchor.constraint(equalToConstant: 20),

      standingsView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      standingsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      standingsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      standingsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      positionDescLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      positionDescLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 15),
      positionDescLabel.widthAnchor.constraint(equalToConstant: 40),

      pointsDescLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      pointsDescLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -15),
      pointsDescLabel.widthAnchor.constraint(equalToConstant: 35),

      lostDescLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      lostDescLabel.trailingAnchor.constraint(equalTo: pointsDescLabel.leadingAnchor, constant: -10),
      lostDescLabel.widthAnchor.constraint(equalToConstant: 15),

      drawDescLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      drawDescLabel.trailingAnchor.constraint(equalTo: lostDescLabel.leadingAnchor, constant: -10),
      drawDescLabel.widthAnchor.constraint(equalToConstant: 15),

      winDescLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      winDescLabel.trailingAnchor.constraint(equalTo: drawDescLabel.leadingAnchor, constant: -10),
      winDescLabel.widthAnchor.constraint(equalToConstant: 15),

      positionLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      positionLabel.leadingAnchor.constraint(equalTo: standingsView.leadingAnchor, constant: 15),
      positionLabel.heightAnchor.constraint(equalToConstant: 30),
      positionLabel.widthAnchor.constraint(equalToConstant: 27),

      positionChangeImageView.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      positionChangeImageView.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 0),
      positionChangeImageView.widthAnchor.constraint(equalToConstant: 15),
      positionChangeImageView.heightAnchor.constraint(equalToConstant: 20),

      teamLogoImageView.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      teamLogoImageView.leadingAnchor.constraint(equalTo: positionChangeImageView.trailingAnchor, constant: 15),
      teamLogoImageView.heightAnchor.constraint(equalToConstant: 30),
      teamLogoImageView.widthAnchor.constraint(equalToConstant: 30),

      teamNameLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      teamNameLabel.leadingAnchor.constraint(equalTo: teamLogoImageView.trailingAnchor, constant: 3),
      teamNameLabel.heightAnchor.constraint(equalToConstant: 30),

      pointsLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      pointsLabel.trailingAnchor.constraint(equalTo: standingsView.trailingAnchor, constant: -15),
      pointsLabel.widthAnchor.constraint(equalToConstant: 35),

      lostLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      lostLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -10),
      lostLabel.widthAnchor.constraint(equalToConstant: 15),

      drawLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      drawLabel.trailingAnchor.constraint(equalTo: lostLabel.leadingAnchor, constant: -10),
      drawLabel.widthAnchor.constraint(equalToConstant: 15),

      winLabel.centerYAnchor.constraint(equalTo: standingsView.centerYAnchor),
      winLabel.trailingAnchor.constraint(equalTo: drawLabel.leadingAnchor, constant: -10),
      winLabel.widthAnchor.constraint(equalToConstant: 15),
    ])
  }

}
