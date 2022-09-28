//
//  SearchVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 27/08/2022.
//

import UIKit

class SearchVC: UIViewController {
    
    let searchController = UISearchController()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let lastSearchedTitleView = FNLastSearchedTitleView()
    
    var searchedTeams: [TeamDetails] = []
    var lastSearched: [TeamDetails] = []
    
    var shouldShowLastSearched = true

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @objc func addToFavoritesPressed(sender: UIButton) {
        let teamIndex = sender.tag
        let activeArray = shouldShowLastSearched ? lastSearched : searchedTeams
        
        PersistenceManager.shared.checkIfTeamIsInFavorites(teamId: activeArray[teamIndex].id) { isInFavorites in
            switch isInFavorites {
                case true:
                    PersistenceManager.shared.updateWith(favorite: activeArray[teamIndex], actionType: .remove) { error in
                        
                    }
                    sender.setImage(UIImage(systemName: "heart"), for: .normal)
                case false:
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    PersistenceManager.shared.updateWith(favorite: activeArray[teamIndex], actionType: .add) { error in
                        
                    }
            }
        }
        tableView.reloadData()
    }

    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = FNColors.backgroundColor
        navigationItem.title = "Szukaj klubu"
        navigationController?.navigationBar.prefersLargeTitles = true
        lastSearchedTitleView.removeAllButton.addTarget(self, action: #selector(removeAllButtontapped), for: .touchUpInside)
        
        layoutUI()
    }
    
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureTableView() {
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNSearchResultCell.self, forCellReuseIdentifier: FNSearchResultCell.cellId)
        tableView.sectionHeaderTopPadding = 0
    }
    
    
    func checkForLastSearched() {
        PersistenceManager.shared.retrieveLastSearched { result in
            switch result {
                case .success(let lastSearched):
                    self.lastSearched = lastSearched
                    tableView.reloadData()
                    
                    if lastSearched.isEmpty {
                        lastSearchedTitleView.removeAllButton.isHidden = true
                        showEmptyState(in: view, text: "Brak ostatnio wyszukiwanych drużyn", image: .noSearchResults, axis: .vertical)
                    }
                case .failure(let error):
                    presentAlertOnMainThread(title: "Błąd", message: error.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
        }
    }
    
    
    @objc func removeAllButtontapped() {
        lastSearched = []
        shouldShowLastSearched = false
        showEmptyState(in: view, text: "Brak ostatnio wyszukiwanych drużyn", image: .noSearchResults, axis: .vertical)
        tableView.reloadData()
    }
    
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}



extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowLastSearched ? lastSearched.count : searchedTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSearchResultCell.cellId, for: indexPath) as! FNSearchResultCell
        cell.addToFavoritesButton.tag = indexPath.row
        shouldShowLastSearched ? cell.set(team: lastSearched[indexPath.row]) : cell.set(team: searchedTeams[indexPath.row])
        cell.addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesPressed), for: .touchUpInside)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray = shouldShowLastSearched ? lastSearched : searchedTeams
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: false, team: activeArray[indexPath.row])
        navigationController?.pushViewController(teamDashboardVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = shouldShowLastSearched ? 40 : 0
        return height
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = shouldShowLastSearched ? lastSearchedTitleView : nil
        return titleView
    }
}


extension SearchVC: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searched = searchBar.text else { return }
        dismissEmptyState(in: view)
        lastSearchedTitleView.removeAllButton.isHidden = false
        NetworkManager.shared.getTeams(parameters: "search=\(searched)") { [weak self] result in
            guard let self = self else { return }
            self.shouldShowLastSearched = false
            switch result {
                case .success(let teams):
                    self.searchedTeams.removeAll()
                    for i in teams {
                        self.searchedTeams.append(i.team)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        PersistenceManager.shared.save(self.searchedTeams, for: .lastSearched)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        lastSearched = searchedTeams
        searchedTeams = []
        shouldShowLastSearched = true
        tableView.reloadData()
    }
}
