//
//  FavoritesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class FavoritesVC: UIViewController {

    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @objc func addToFavoritesPressed(sender: UIButton) {
        let teamIndex = sender.tag
                    
        Favorites.shared.favoritesTeams.remove(at: teamIndex)
        Favorites.shared.setFavoritesTeams("favoritesTeams", object: Favorites.shared.favoritesTeams)
        tableView.deleteRows(at: [IndexPath(row: teamIndex, section: 0)], with: .left)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { self.tableView.reloadData() }
        
    }
    

    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Ulubione drużyny"
        
        
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNSearchResultCell.self, forCellReuseIdentifier: FNSearchResultCell.cellId)
        tableView.isScrollEnabled = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorites.shared.favoritesTeams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSearchResultCell.cellId, for: indexPath) as! FNSearchResultCell
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        cell.addToFavoritesButton.tag = indexPath.row
        cell.set(teams: Favorites.shared.favoritesTeams[indexPath.row])
        cell.addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesPressed), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: false, team: Favorites.shared.favoritesTeams[indexPath.row])
        navigationController?.pushViewController(teamDashboardVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
