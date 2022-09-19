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
        checkForLastSearched()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    @objc func addToFavoritesPressed(sender: UIButton) {
        let teamIndex = sender.tag
                    
        if let index = Favorites.shared.favoritesTeams.firstIndex(where: {$0.team.name == lastSearched[teamIndex].team.name}) {
            Favorites.shared.favoritesTeams.remove(at: index)
            Favorites.shared.setFavoritesTeams("favoritesTeams", object: Favorites.shared.favoritesTeams)
        } else {
            Favorites.shared.favoritesTeams.append(lastSearched[teamIndex])
            Favorites.shared.setFavoritesTeams("favoritesTeams", object: Favorites.shared.favoritesTeams)
        }

        tableView.reloadData()
    }

    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = FNColors.backgroundColor
        navigationItem.title = "Szukaj klubu"
        navigationController?.navigationBar.prefersLargeTitles = true

        
    }
    
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNSearchResultCell.self, forCellReuseIdentifier: FNSearchResultCell.cellId)
        tableView.backgroundColor = FNColors.sectionColor
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func checkForLastSearched() {
        if let data = UserDefaults.standard.value(forKey: "LastSearched") as? Data {
            let decoder = JSONDecoder()
            if let lastSearched = try? decoder.decode([TeamsData].self, from: data) {
                self.lastSearched = lastSearched
                tableView.reloadData()
            }
        }
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
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: false, team: arrayToPick[indexPath.row])
        navigationController?.pushViewController(teamDashboardVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                        let encoder = JSONEncoder()
                        let data = try? encoder.encode(self.lastSearched)
                        UserDefaults.standard.set(data, forKey: "LastSearched")
                    }
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
