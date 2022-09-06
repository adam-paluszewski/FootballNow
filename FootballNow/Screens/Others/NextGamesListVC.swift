//
//  NextGamesListVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class NextGamesListVC: UIViewController {
    
    var nextGames: [FixturesData] = []
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    

 
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Kolejne mecze"
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNNextGameCell.self, forCellReuseIdentifier: FNNextGameCell.cellId)
        tableView.backgroundColor = FNColors.sectionColor
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = false
        
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


extension NextGamesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIElementsSizes.nextGameCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNNextGameCell.cellId, for: indexPath) as! FNNextGameCell
        cell.set(nextGame: nextGames[indexPath.row])
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        return cell
    }
    
}
