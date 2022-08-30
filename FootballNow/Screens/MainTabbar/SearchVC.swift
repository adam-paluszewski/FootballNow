//
//  SearchVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 27/08/2022.
//

import UIKit

class SearchVC: UIViewController {
    
    let searchController = UISearchController()
    let tableView = UITableView()
    
    var searchedTeams: [TeamsData] = []
//    var lastSearched: [TeamsData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureTableView()
    }

    
    func configureViewController() {
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        navigationItem.title = "Szukaj klubu"

        
    }
    
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNSearchResultCell.self, forCellReuseIdentifier: FNSearchResultCell.cellId)
        tableView.backgroundColor = UIColor(named: "FNSectionColor")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}



extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSearchResultCell.cellId, for: indexPath) as! FNSearchResultCell
        cell.tag = indexPath.row
        cell.set(teams: searchedTeams[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = searchedTeams[indexPath.row].team
        let teamId = String(selectedTeam.id)
        let teamLogo = selectedTeam.logo
        let teamName = selectedTeam.name
        
        let teamDashboardVC = TeamDashboardVC()
        teamDashboardVC.myTeam = [teamId, teamLogo, teamName]
        navigationController?.pushViewController(teamDashboardVC, animated: true)
    }
}


extension SearchVC: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searched = searchBar.text else { return }
        
        NetworkManager.shared.getTeams(parameters: "search=\(searched)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let teams):
                    self.searchedTeams = teams.response
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchedTeams = []
//        tableView.reloadData()
    }
}
