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
    var lastSearched: [TeamsData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureTableView()
    }
    
    
    @objc func addToFavoritesPressed(sender: UIButton) {
        let teamIndex = sender.tag
                    
        if let index = Favorites.shared.favoritesTeams.firstIndex(where: {$0.team.name == lastSearched[teamIndex].team.name}) {
            Favorites.shared.favoritesTeams.remove(at: index)
            Favorites.shared.set("favoritesTeams", object: Favorites.shared.favoritesTeams)
        } else {
            Favorites.shared.favoritesTeams.append(lastSearched[teamIndex])
            Favorites.shared.set("favoritesTeams", object: Favorites.shared.favoritesTeams)
        }

        tableView.reloadData()
    }

    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
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
        return searchedTeams.isEmpty ? lastSearched.count : searchedTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSearchResultCell.cellId, for: indexPath) as! FNSearchResultCell
        cell.addToFavoritesButton.tag = indexPath.row
        searchedTeams.isEmpty ? cell.set(teams: lastSearched[indexPath.row]) : cell.set(teams: searchedTeams[indexPath.row])
        
        cell.addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesPressed), for: .touchUpInside)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrayToPick = searchedTeams.isEmpty ? lastSearched : searchedTeams
        
        let selectedTeam = arrayToPick[indexPath.row].team
        let teamId = String(selectedTeam.id)
        let teamLogo = selectedTeam.logo
        let teamName = selectedTeam.name
        
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: false, team: [teamId, teamLogo, teamName])
        navigationController?.pushViewController(teamDashboardVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchedTeams.isEmpty && !lastSearched.isEmpty ? "Ostatnio wyszukiwane" : nil
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
                    self.lastSearched = self.searchedTeams
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedTeams = []
        tableView.reloadData()
    }
}
