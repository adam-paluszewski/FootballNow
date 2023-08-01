import UIKit

class FNLeagueCell: UITableViewCell {

  static let cellId = "LeaguesCell"
  let tableView = UITableView()

  var games: [FixturesResponse] = [] {
    didSet {
      games.sort {$0.fixture?.timestamp ?? 0 < $1.fixture?.timestamp ?? 0}
      tableView.reloadData()
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  func configure() {
    tableView.register(FNNextGameCell.self, forCellReuseIdentifier: FNNextGameCell.cellId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isScrollEnabled = false
    tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    tableView.prepareForDynamicHeight()
  }

  func addSubviews() {
    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

extension FNLeagueCell: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return games.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FNNextGameCell.cellId, for: indexPath) as! FNNextGameCell
    cell.set(nextGame: games[indexPath.row])
    return cell
  }

}
