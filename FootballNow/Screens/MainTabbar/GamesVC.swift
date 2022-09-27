//
//  GamesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class GamesVC: UIViewController {
    
    let chipsView = UIView()
    var tableView = UITableView()
    
    var observedLeagues: [LeaguesResponse] = []
    var gamesPerLeague: [[FixturesResponse]] = []
    
    var startDate = FNDateFormatting.getDateYYYYMMDD(for: .current)
    var endDate = FNDateFormatting.getDateYYYYMMDD(for: .current)

    
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
        navigationItem.title = "Najbliższe mecze"
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
                        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(manageLeaguesTapped))
                    }
                case .failure(let error):
                    print()
            }
            tableView.reloadData()
        }
    }
    
    
    func fetchDataForGames() {
        gamesPerLeague.removeAll()
        let semaphore = DispatchSemaphore(value: 1)
        for i in observedLeagues {

            let leagueId = i.league?.id
            guard let leagueId = leagueId else { return }
            NetworkManager.shared.getFixtures(parameters: "league=\(leagueId)&from=\(startDate)&to=\(endDate)&season=2022&timezone=Europe/Warsaw") { [weak self] result in
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

    
    func layoutUI() {
        view.addSubview(chipsView)
        chipsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chipsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chipsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chipsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chipsView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: chipsView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension GamesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesPerLeague.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if gamesPerLeague[indexPath.row].count != 0 {
            return CGFloat(gamesPerLeague[indexPath.row].count * 90 + 41 + 15) //+sectionView height +item spacing
        } else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNLeagueCell.cellId, for: indexPath) as! FNLeagueCell
        cell.games = gamesPerLeague[indexPath.row]
        cell.view.sectionTitleLabel.text = observedLeagues[indexPath.row].league?.name?.uppercased()
        
        return cell
    }
}


extension GamesVC: DatesPassedDelegate {
    
    func datesPassed(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
        fetchDataForGames()
    }
}
