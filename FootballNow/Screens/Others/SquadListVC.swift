//
//  SquadListVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class SquadListVC: UIViewController {
    
    let tableView = UITableView()
    
    var playersByPosition: [[PlayerSq]] = []
    let sectionNames = ["BRAMKARZE", "OBROŃCY", "POMOCNICY", "NAPASTNICY"]
    
    
    init(players: [PlayerSq]) {
        super.init(nibName: nil, bundle: nil)
        let goalkeepers = players.filter {$0.position == "Goalkeeper"}
        let defenders = players.filter {$0.position == "Defender"}
        let midfielders = players.filter {$0.position == "Midfielder"}
        let attackers = players.filter {$0.position == "Attacker"}
        self.playersByPosition = [goalkeepers, defenders, midfielders, attackers]
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    

    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Zawodnicy"
        
        layoutUI()
    }
    
    
    func configureTableView() {
        tableView.register(FNTablePlayerCell.self, forCellReuseIdentifier: FNTablePlayerCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    }
    
    
    func layoutUI() {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        playersByPosition.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FNTableViewHeaderView(text: sectionNames[section])
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersByPosition[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNTablePlayerCell.cellId, for: indexPath) as! FNTablePlayerCell
        cell.set(player: playersByPosition[indexPath.section][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerId = playersByPosition[indexPath.section][indexPath.row].id
        let playerNumber = playersByPosition[indexPath.section][indexPath.row].number
        let playerPosition = playersByPosition[indexPath.section][indexPath.row].position

        let playerVC = PlayerVC(id: playerId, number: playerNumber, position: playerPosition)
        navigationController?.pushViewController(playerVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
