import UIKit

class GameDetailsVC: UIViewController {

  let scrollView = UIScrollView()
  let headerView = FNGameOverviewView()
  let segmentedControl = UISegmentedControl(items: ["Przebieg", "Statystyki", "Składy"])
  let stackView = UIStackView()
  let progressView = UIView()
  let statisticsView = UIView()
  let formationsView = UIView()
  var gameId: Int!
  var game: [FixturesResponse] = []

  init(gameId: Int?) {
    super.init(nibName: nil, bundle: nil)
    guard let gameId = gameId else {
      presentAlertOnMainThread(title: "Błąd", message: "Brak inforamcji dotyczących tego meczu", buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
      return
    }
    self.gameId = gameId
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSegmentedControl()
    fetchDataForGame()
  }

  func configureViewController() {
    showLoadingView(in: self.view)

    navigationItem.backBarButtonItem = UIBarButtonItem()
    view.backgroundColor = FNColors.backgroundColor

    stackView.axis = .vertical
    stackView.distribution = .fillProportionally

    scrollView.delegate = self
    scrollView.refreshControl = UIRefreshControl()
    scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

    headerView.homeTeamButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
    headerView.awayTeamButton.addTarget(self, action: #selector(awayButtonPressed), for: .touchUpInside)

    layoutUI()
  }

  func configureSegmentedControl() {
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    segmentedControlValueChanged()
  }

  func fetchDataForGame() {
    NetworkManager.shared.getFixtures(parameters: "id=\(self.gameId!)") { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let fixture):
          DispatchQueue.main.async {
            self.game = fixture
            self.headerView.set(game: fixture[0])
            self.add(childVC: GameProgressVC(game: fixture[0]), to: self.progressView)
            self.add(childVC: GameStatisticsVC(statistics: fixture[0].statistics), to: self.statisticsView)
            self.add(childVC: GameFormationsVC(squad: fixture[0].lineups), to: self.formationsView)
          }
        case .failure(let error):
          self.presentAlertOnMainThread(title: "Błąd", message: error.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
      }
      DispatchQueue.main.async { self.dismissLoadingView(in: self.view) }
    }
  }

  @objc func handleRefreshControl() {
    remove(childrenVC: children)
    showLoadingView(in: view)
    fetchDataForGame()
    scrollView.refreshControl?.endRefreshing()
  }

  @objc func segmentedControlValueChanged() {
    let haptic = UISelectionFeedbackGenerator()
    haptic.selectionChanged()
    switch segmentedControl.selectedSegmentIndex {
      case 0:
        progressView.isHidden = false
        statisticsView.isHidden = true
        formationsView.isHidden = true
      case 1:
        progressView.isHidden = true
        statisticsView.isHidden = false
        formationsView.isHidden = true
      case 2:
        progressView.isHidden = true
        statisticsView.isHidden = true
        formationsView.isHidden = false
      default:
        print("error")
    }
  }

  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    super.preferredContentSizeDidChange(forChildContentContainer: container)
    if container as? GameProgressVC != nil {
      progressView.heightAnchor.constraint(equalToConstant: container.preferredContentSize.height).isActive = true
    } else if container as? GameStatisticsVC != nil {
      statisticsView.heightAnchor.constraint(equalToConstant: container.preferredContentSize.height).isActive = true
    } else if container as? GameFormationsVC != nil {
      formationsView.heightAnchor.constraint(equalToConstant: container.preferredContentSize.height).isActive = true
    }
  }

  @objc func homeButtonPressed() {
    let team = TeamDetails(id: game[0].teams?.home?.id, name: game[0].teams?.home?.name, logo: game[0].teams?.home?.logo)
    navigationController?.pushViewController(TeamDashboardVC(isMyTeamShowing: false, team: team), animated: true)
  }

  @objc func awayButtonPressed() {
    let team = TeamDetails(id: game[0].teams?.away?.id, name: game[0].teams?.away?.name, logo: game[0].teams?.away?.logo)
    navigationController?.pushViewController(TeamDashboardVC(isMyTeamShowing: false, team: team), animated: true)
  }

  func layoutUI() {
    view.addSubview(scrollView)
    scrollView.addSubview(headerView)
    scrollView.addSubview(segmentedControl)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(progressView)
    stackView.addArrangedSubview(statisticsView)
    stackView.addArrangedSubview(formationsView)

    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      headerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
      headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      headerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      headerView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardLastGameHeight-41),

      segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
      segmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
      segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
      segmentedControl.heightAnchor.constraint(equalToConstant: 40),

      stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    ])
  }

}


extension GameDetailsVC: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    if offsetY > -88 + 68 {
      navigationItem.titleView = FNGameScoreTitleView(fixtureData: game[0])
      navigationItem.title = nil
    } else {
      navigationItem.titleView = nil
      navigationItem.title = "Podsumowanie meczu"
    }
  }

}
