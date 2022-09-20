//
//  SquadListVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class SquadListVC: UIViewController {
    
    let tableView = UITableView()
    
    var players: [SquadsPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    

    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Skład drużyny"
    }
    
    
    func configureTableView() {
        tableView.register(FNTablePlayerCell.self, forCellReuseIdentifier: FNTablePlayerCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = FNColors.sectionColor
        
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


extension SquadListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNTablePlayerCell.cellId, for: indexPath) as! FNTablePlayerCell
        cell.set(player: players[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerId = players[indexPath.row].id
        let playerNumber = players[indexPath.row].number
        let playerPosition = players[indexPath.row].position
        
        let playerVC = PlayerVC(id: playerId, number: playerNumber, position: playerPosition)
        navigationController?.pushViewController(playerVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            print("poszlo")
        }
    }
    
}
