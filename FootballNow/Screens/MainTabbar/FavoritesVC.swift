//
//  FavoritesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class FavoritesVC: UIViewController {

    let tableView = UITableView()
    
    var favoriteTeams: [TeamDetails] = [] {
        didSet {
            if favoriteTeams.isEmpty {
                showEmptyState(in: view, text: "Nie masz ulubionych drużyn", image: .favorite, axis: .vertical)
            } else {
                dismissEmptyState()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PersistenceManager.shared.retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    self.favoriteTeams = favorites
                    tableView.reloadDataOnMainThread()
                case .failure(let error):
                    presentAlertOnMainThread(title: "Błąd", message: error.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
        }
    }
    
    
    @objc func removeFromFavoritesPressed(sender: UIButton) {
        let teamIndex = sender.tag
        PersistenceManager.shared.updateWith(favorite: favoriteTeams[teamIndex], actionType: .remove) { error in
            if let _ = error {
                return
            }
            favoriteTeams.remove(at: teamIndex)
            tableView.deleteRows(at: [IndexPath(row: teamIndex, section: 0)], with: .left)
        }
        
    }
    

    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Ulubione drużyny"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNSearchResultCell.self, forCellReuseIdentifier: FNSearchResultCell.cellId)
        tableView.isScrollEnabled = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTeams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSearchResultCell.cellId, for: indexPath) as! FNSearchResultCell
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        cell.addToFavoritesButton.tag = indexPath.row
        cell.set(team: favoriteTeams[indexPath.row])
        cell.addToFavoritesButton.addTarget(self, action: #selector(removeFromFavoritesPressed), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: false, team: favoriteTeams[indexPath.row])
        navigationController?.pushViewController(teamDashboardVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favoriteTeams[indexPath.row]
        PersistenceManager.shared.updateWith(favorite: favorite, actionType: .remove) { error in
            guard let _ = error  else {
                favoriteTeams.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
        }
    }
}
