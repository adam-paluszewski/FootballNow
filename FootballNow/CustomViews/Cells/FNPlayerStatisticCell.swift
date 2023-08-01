import UIKit

class FNPlayerStatisticCell: UITableViewCell {

  static let cellId = "PlayerStatisticCell"
  let statisticNameLabel = FNBodyLabel(allingment: .left)
  let statisticValueLabel = FNBodyLabel(allingment: .center)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    backgroundColor = FNColors.sectionColor
  }

  func addSubviews() {
    addSubview(statisticNameLabel)
    addSubview(statisticValueLabel)

    NSLayoutConstraint.activate([
      statisticNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      statisticNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),

      statisticValueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      statisticValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
    ])
  }

  func set(player: StatisticsP, indexPath: IndexPath) {
    let section = indexPath.section
    let row = indexPath.row
    var text: (String, String) = ("","")

    switch section {
      case 0:
        switch row {
          case 0:
            text = ("Występy", String(player.games?.appearences ?? 0))
          case 1:
            text = ("Rozegrane minuty", String(player.games?.minutes ?? 0))

          default:
            print("")
        }
      case 1:
        switch row {
          case 0:
            text = ("Wejścia na boisko", String(player.substitutes?.inNumber ?? 999))
          case 1:
            text = ("Zejścia z boiska", String(player.substitutes?.outNumber ?? 999))
          case 2:
            text = ("Na ławce", String(player.substitutes?.bench ?? 999))
          default:
            print("")
        }
      case 2:
        switch row {
          case 0:
            text = ("Wszystkie", String(player.shots?.total ?? 999))
          case 1:
            text = ("Celne", String(player.shots?.on ?? 999))
          default:
            print("")
        }
      case 3:
        switch row {
          case 0:
            text = ("Strzelone", String(player.goals?.total ?? 999))
          case 1:
            text = ("Asysty", String(player.goals?.assists ?? 999))
          default:
            print("")
        }
      case 4:
        switch row {
          case 0:
            text = ("Łącznie", String(player.passes?.total ?? 999))
          case 1:
            text = ("Kluczowe", String(player.passes?.key ?? 999))
          case 2:
            text = ("Celność podań (%)", String(player.shots?.total ?? 999))
          default:
            print("")
        }
      case 5:
        switch row {
          case 0:
            text = ("Odgwizdane spalone", String(player.tackles?.total ?? 999))
          default:
            print("")
        }
      case 6:
        switch row {
          case 0:
            text = ("Łącznie", String(player.duels?.total ?? 999))
          case 1:
            text = ("Wygrane", String(player.duels?.won ?? 999))
          default:
            print("")
        }
      case 7:
        switch row {
          case 0:
            text = ("Próby", String(player.dribbles?.attempts ?? 999))
          case 1:
            text = ("Udane", String(player.dribbles?.success ?? 999))
          default:
            print("")
        }
      case 8:
        switch row {
          case 0:
            text = ("Na sobie", String(player.fouls?.drawn ?? 999))
          case 1:
            text = ("Przewinienia", String(player.fouls?.committed ?? 999))
          default:
            print("")
        }
      case 9:
        switch row {
          case 0:
            text = ("Żółte", String(player.cards?.yellow ?? 999))
          case 1:
            text = ("Czerwone (za 2 żółte)", String(player.cards?.yellowred ?? 999))
          case 2:
            text = ("Czerwone", String(player.cards?.red ?? 999))
          default:
            print("")
        }
      case 10:
        switch row {
          case 0:
            text = ("Strzelone", String(player.penalty?.scored ?? 999))
          default:
            print("")
        }
      default:
        print("")
    }

    statisticNameLabel.text = text.0
    if text.1 == "999" {
      statisticValueLabel.text = "b/d"
    } else {
      statisticValueLabel.text = text.1
    }
  }

}
