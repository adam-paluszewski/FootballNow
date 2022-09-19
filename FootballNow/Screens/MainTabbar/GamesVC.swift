//
//  GamesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class GamesVC: UIViewController {
    
    var tableView = UITableView()
    
    var observedLeagues: [LeaguesData] = []
    var gamesPerLeague: [[FixturesData]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        createObservers()
        checkObservedLeagues()
        configureViewController()
        configureTableView()
        fetchDataForGames()
    }
    
    
    func createObservers() {
        let leagues = Notification.Name(NotificationKeys.myLeaguesChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: leagues, object: nil)
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        observedLeagues = notification.object as! [LeaguesData]
        fetchDataForGames()
    }
    

    func configureViewController() {
        navigationItem.title = "Najbliższy tydzień"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zarządzaj", style: .plain, target: self, action: #selector(manageLeagues))
    }
    
    
    func configureTableView() {
        tableView.register(FNLeagueCell.self, forCellReuseIdentifier: FNLeagueCell.cellId)
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    @objc func manageLeagues() {
        let manageLeaguesVC = ManageLeaguesVC()
        manageLeaguesVC.observedLeagues = self.observedLeagues
        navigationController?.pushViewController(manageLeaguesVC, animated: true)
    }
    
    
    func checkObservedLeagues() {
        if let data = UserDefaults.standard.data(forKey: "myLeagues") {
            let decoder = JSONDecoder()
            
            if let observedLeagues = try? decoder.decode([LeaguesData].self, from: data) {
                self.observedLeagues = observedLeagues
            }
        }
        
        if observedLeagues.isEmpty {
            let selectLeagueVC = SelectLeagueVC()
            let navController = UINavigationController(rootViewController: selectLeagueVC)
            present(navController, animated: true)
        }
    }
    
    
    func fetchDataForGames() {
        gamesPerLeague.removeAll()
        let semaphore = DispatchSemaphore(value: 1)
        for i in observedLeagues {
            
            let leagueId = i.league.id
            
            guard let leagueId = leagueId else { return }
            NetworkManager.shared.getFixtures(parameters: "league=\(leagueId)&from=\(FNDateFormatting.getDateYYYYMMDD(for: .current))&to=\(FNDateFormatting.getDateYYYYMMDD(for: .oneWeekAhead))&season=2022&timezone=Europe/Warsaw") { [weak self] result in
                semaphore.wait()
                guard let self = self else { return }
                switch result {
                    case .success(let fixtures):
                        self.gamesPerLeague.append(fixtures.response)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        semaphore.signal()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

}


extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(gamesPerLeague[indexPath.row].count * 90 + 41 + 15)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !observedLeagues.isEmpty else { return 0}
        return gamesPerLeague.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNLeagueCell.cellId, for: indexPath) as! FNLeagueCell
        cell.games = gamesPerLeague[indexPath.row]
        cell.view.sectionTitleLabel.text = gamesPerLeague[indexPath.row][0].league.name
        return cell
    }

}
