//
//  GamesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class GamesVC: UIViewController {
    
    var tableView = UITableView()
    
    var observedLeagues: [LeaguesResponse] = []
    var gamesPerLeague: [[FixturesResponse]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        configureViewController()
        configureTableView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkObservedLeagues()
        fetchDataForGames()
    }
    

    func configureViewController() {
        navigationItem.title = "Twoje ligi"
    }
    
    
    func configureTableView() {
        tableView.register(FNLeagueCell.self, forCellReuseIdentifier: FNLeagueCell.cellId)
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prepareForDynamicHeight()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        gamesPerLeague.removeAll()
        PersistenceManager.shared.retrieveMyLeagues { result in
            switch result {
                case .success(let leagues):
                    self.observedLeagues = leagues
                    if leagues.isEmpty {
                        showEmptyState(in: view, text: "Nie obserwujesz żadnych rozgrywek. Wybierz swoje ulubione ligi i nie przegap żadnego meczu.", image: .noMyLeagues, axis: .vertical)
                        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLeaguesTapped))

                    } else {
                        self.dismissEmptyState()
                        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EDYTUJ", style: .plain, target: self, action: #selector(manageLeaguesTapped))
                    }
                case .failure(let error):
                    print()
            }
            tableView.reloadData()
        }
    }
    
    
    func fetchDataForGames() {
        let semaphore = DispatchSemaphore(value: 1)
        for i in observedLeagues {

            let leagueId = i.league?.id

            guard let leagueId = leagueId else { return }
            NetworkManager.shared.getFixtures(parameters: "league=\(leagueId)&from=\(FNDateFormatting.getDateYYYYMMDD(for: .current))&to=\(FNDateFormatting.getDateYYYYMMDD(for: .oneWeekAhead))&season=2022&timezone=Europe/Warsaw") { [weak self] result in
                semaphore.wait()
                guard let self = self else { return }
                switch result {
                    case .success(let fixtures):
                        self.gamesPerLeague.append(fixtures)
                        self.tableView.reloadDataOnMainThread()
                        semaphore.signal()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

}


extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesPerLeague.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(gamesPerLeague[indexPath.row].count * 90 + 41 + 15) //+sectionView height +item spacing
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNLeagueCell.cellId, for: indexPath) as! FNLeagueCell
        cell.games = gamesPerLeague[indexPath.row]
        cell.view.sectionTitleLabel.text = gamesPerLeague[indexPath.row][0].league.name?.uppercased()
        return cell
    }
}
