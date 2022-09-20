//
//  LastGamesListVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class LastGamesListVC: UIViewController {

    var lastGames: [FixturesResponse] = []
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    

 
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Ostatnie mecze"
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNLastGameCell.self, forCellReuseIdentifier: FNLastGameCell.cellId)
        tableView.backgroundColor = FNColors.sectionColor
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension LastGamesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIElementsSizes.lastGameCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastGames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNLastGameCell.cellId, for: indexPath) as! FNLastGameCell
        cell.set(lastGame: lastGames[indexPath.row])
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameId = lastGames[indexPath.row].fixture.id
        navigationController?.pushViewController(GameDetailsVC(gameId: gameId), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
