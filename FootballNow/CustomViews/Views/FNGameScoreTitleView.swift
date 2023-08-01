import UIKit

class FNGameScoreTitleView: UIView {

  let homeTeamImageView = UIImageView()
  let awayTeamImageView = UIImageView()
  let scoreLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  init(fixtureData: FixturesResponse) {
    super.init(frame: .zero)
    NetworkManager.shared.downloadImage(from: fixtureData.teams?.home?.logo, completionHandler: { image in
      DispatchQueue.main.async {
        self.homeTeamImageView.image = image
      }
    })
    NetworkManager.shared.downloadImage(from: fixtureData.teams?.away?.logo, completionHandler: { image in
      DispatchQueue.main.async {
        self.awayTeamImageView.image = image
      }
    })
    let homeTeamGoals = fixtureData.goals?.home == nil ? "b/d" : String((fixtureData.goals?.home)!)
    let awayTeamGoals = fixtureData.goals?.away == nil ? "b/d" : String((fixtureData.goals?.away)!)
    scoreLabel.text = "\(homeTeamGoals) - \(awayTeamGoals)"
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    scoreLabel.textColor = .label
    scoreLabel.font = .systemFont(ofSize: 22, weight: .bold)
  }

  func addSubviews() {
    addSubview(homeTeamImageView)
    addSubview(awayTeamImageView)
    addSubview(scoreLabel)

    homeTeamImageView.translatesAutoresizingMaskIntoConstraints = false
    awayTeamImageView.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      scoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

      homeTeamImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      homeTeamImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      homeTeamImageView.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -7),
      homeTeamImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      homeTeamImageView.widthAnchor.constraint(equalTo: homeTeamImageView.heightAnchor),

      awayTeamImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      awayTeamImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      awayTeamImageView.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 7),
      awayTeamImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      awayTeamImageView.widthAnchor.constraint(equalTo: homeTeamImageView.heightAnchor),

    ])
  }

}
