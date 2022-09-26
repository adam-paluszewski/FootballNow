//
//  SelectLeagueVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class SelectLeagueVC: UIViewController {

    let tableView = UITableView()
    var leagues: [LeaguesResponse] = []
    var isCancelable = false
    
    var VCDismissed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureSearchController()
        fetchDataForLeagues(parameters: "season=2022")
    }
    

    func passSelectedLeague(leagueData: LeaguesResponse) {
        PersistenceManager.shared.updateWith(league: leagueData, actionType: .add) { error in
            
        }
        view.window?.rootViewController?.dismiss(animated: true, completion: VCDismissed)
    }
  
    
    func configureViewController() {
        navigationItem.title = "Wybierz ligę"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(dismissVC))
        view.backgroundColor = FNColors.backgroundColor
        navigationItem.title = "Wybierz ligę"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "FNNavBarColor")
        
        if isCancelable {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(dismissVC))
        }
        
        layoutUI()
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
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    }
    
    
    func fetchDataForLeagues(parameters: String) {
        NetworkManager.shared.getLeagues(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let leagues):
                    self.leagues = leagues
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension SelectLeagueVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        fetchDataForLeagues(parameters: "search=\(searched)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchDataForLeagues(parameters: "season=2022")
    }
}
