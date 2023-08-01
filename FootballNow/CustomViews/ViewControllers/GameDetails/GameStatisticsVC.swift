import UIKit

class GameStatisticsVC: UIViewController {

  var statistics: [Statistics] = []
  let tableView = UITableView()

  init(statistics: [Statistics]?) {
    super.init(nibName: nil, bundle: nil)
    if let statistics = statistics {
      self.statistics = statistics
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
  }

  override func viewDidLayoutSubviews() {
    let size = max(tableView.contentSize.height, 500)
    preferredContentSize.height = size
  }

  func configureViewController() {
    view.backgroundColor = FNColors.sectionColor
    layoutUI()
  }

  func configureTableView() {
    tableView.register(FNGameStatisticsCell.self, forCellReuseIdentifier: FNGameStatisticsCell.cellId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prepareForDynamicHeight()
    tableView.isUserInteractionEnabled = false
  }

  func layoutUI() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

}

extension GameStatisticsVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard !statistics.isEmpty else {
      showEmptyState(in: view, text: "Brak statystyk dla tego meczu", image: .statistics, axis: .vertical)
      return 0
    }
    return statistics[0].ckey?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FNGameStatisticsCell.cellId, for: indexPath) as! FNGameStatisticsCell
    cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    cell.set(homeStats: statistics[0].ckey?[indexPath.row], awayStats: (statistics[1].ckey?[indexPath.row]))
    return cell
  }

}
