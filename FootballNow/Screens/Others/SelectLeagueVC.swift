//
//  SelectLeagueVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class SelectLeagueVC: UIViewController {

    let tableView = UITableView()
    var leagues: [LeaguesData] = []
    var observedLeagues: [LeaguesData] = []
    var isCancelable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureSearchController()
        fetchDataForTeams(parameters: "season=2022")
    }
    

    func passSelectedLeague(leagueData: LeaguesData) {
        observedLeagues.append(leagueData)
        
        let leagues = Notification.Name(NotificationKeys.myLeaguesChanged)
        NotificationCenter.default.post(name: leagues, object: observedLeagues)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(observedLeagues) {
            UserDefaults.standard.set(data, forKey: "myLeagues")
        }
        
        

        dismiss(animated: true)
    }
  
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = FNColors.backgroundColor
        navigationItem.title = "Wybierz ligę"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "FNNavBarColor")
        
        if isCancelable {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(dismissVC))
        }
        
        
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func configureTableView() {
        tableView.register(FNSelectLeagueCell.self, forCellReuseIdentifier: FNSelectLeagueCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "FNSectionBackground")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchDataForTeams(parameters: String) {
            NetworkManager.shared.getLeagues(parameters: parameters) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let leagues):
                        self.leagues = leagues.response
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    case .failure(let error):
                        print(error)
                }
            }
    }
}


extension SelectLeagueVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSelectLeagueCell.cellId, for: indexPath) as! FNSelectLeagueCell
        cell.set(league: leagues[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passSelectedLeague(leagueData: leagues[indexPath.row])
    }
    
}


extension SelectLeagueVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searched = searchBar.text else { return }
        fetchDataForTeams(parameters: "search=\(searched)")
    }
}
