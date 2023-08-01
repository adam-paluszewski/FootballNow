import UIKit

class GamesVC: UIViewController {

  let scrollView = UIScrollView()
  let chipsView = UIView()
  var tableView = UITableView()
  var observedLeagues: [LeaguesResponse] = []
  var gamesPerLeague: [[FixturesResponse]] = []
  var startDate = FNDateFormatting.getDateYYYYMMDD(for: .current)
  var endDate = FNDateFormatting.getDateYYYYMMDD(for: .current)
  var tableViewHeight: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkObservedLeagues()
    fetchDataForGames()
  }

  func configureViewController() {
    navigationItem.backBarButtonItem = UIBarButtonItem()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Rozgrywki"
    let child = FNGamesChipsVC()
    child.delegate = self
    add(childVC: child, to: chipsView)
    layoutUI()
  }

  func configureTableView() {
    tableView.register(FNLeagueCell.self, forCellReuseIdentifier: FNLeagueCell.cellId)
    tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    tableView.backgroundColor = FNColors.backgroundColor
    tableView.delegate = self
    tableView.dataSource = self
    tableView.sectionHeaderTopPadding = 0
    tableView.isScrollEnabled = false
    tableView.prepareForDynamicHeight()
  }

  @objc func manageLeaguesTapped() {
    let manageLeaguesVC = ManageLeaguesVC()
    navigationController?.pushViewController(manageLeaguesVC, animated: true)
  }

  @objc func addLeaguesTapped() {
    let selectLeagueVC = SelectLeagueVC()
    selectLeagueVC.VCDismissed = { [weak self] in
      self?.checkObservedLeagues()
      self?.fetchDataForGames()
    }
    let navController = UINavigationController(rootViewController: selectLeagueVC)
    present(navController, animated: true)
  }

  func checkObservedLeagues() {
    PersistenceManager.shared.retrieveMyLeagues { result in
      switch result {
        case .success(let leagues):
          self.observedLeagues = leagues
          if leagues.isEmpty {
            showEmptyState(in: view, text: "Nie obserwujesz żadnych rozgrywek. Wybierz swoje ulubione ligi i nie przegap żadnego meczu.", image: .noMyLeagues, axis: .vertical)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLeaguesTapped))
          } else {
            dismissEmptyState(in: view)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(manageLeaguesTapped))
          }
        case .failure(let error):
          print(error)
      }
    }
  }

  func fetchDataForGames() {
    gamesPerLeague.removeAll()
    tableView.reloadData()
    let semaphore = DispatchSemaphore(value: 1)

    for i in observedLeagues {
      let leagueId = i.league?.id
      guard let leagueId = leagueId else { return }
      NetworkManager.shared.getFixtures(parameters: "league=\(leagueId)&from=\(startDate)&to=\(endDate)&season=2023&timezone=Europe/Warsaw") { [weak self] result in
        semaphore.wait()
        guard let self = self else { return }
        switch result {
          case .success(let fixtures):
            if !fixtures.isEmpty {
              self.gamesPerLeague.append(fixtures)
            }
            self.tableView.reloadDataOnMainThread()
            self.updateTableViewHeight()
          case .failure(let error):
            print(error)
        }
        semaphore.signal()
      }
    }
  }

  func updateTableViewHeight() {
    DispatchQueue.main.async {
      self.tableViewHeight?.isActive = false
      self.tableViewHeight = self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height)
      self.tableViewHeight?.isActive = true
    }
  }

  func layoutUI() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    scrollView.addSubview(chipsView)
    chipsView.translatesAutoresizingMaskIntoConstraints = false

    scrollView.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      chipsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      chipsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      chipsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      chipsView.heightAnchor.constraint(equalToConstant: 55),
      chipsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      tableView.topAnchor.constraint(equalTo: chipsView.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    ])
  }
}

extension GamesVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return gamesPerLeague.isEmpty ? 0 : 55
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return FNFormationsHeaderView(title: gamesPerLeague[section][0].league.name?.uppercased(), allingment: .left)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    guard !gamesPerLeague.isEmpty else {
      if !observedLeagues.isEmpty {
        showEmptyState(in: self.view, text: "Brak spotkań w wybranym terminie", image: .noGames, axis: .vertical)
      }
      return 0
    }
    dismissEmptyState(in: view)
    return gamesPerLeague.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(gamesPerLeague[indexPath.section].count * 90)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FNLeagueCell.cellId, for: indexPath) as! FNLeagueCell
    cell.games = gamesPerLeague[indexPath.section]
    return cell
  }

}

extension GamesVC: DatesPassedDelegate {

  func datesPassed(startDate: String, endDate: String) {
    self.startDate = startDate
    self.endDate = endDate
    NetworkManager.shared.stopTasks()
    fetchDataForGames()
  }

}
