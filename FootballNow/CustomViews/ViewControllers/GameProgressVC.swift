//
//  GameProgressVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameProgressVC: UIViewController {
    
    let tableView = UITableView()
    
    var game: FixturesResponse!
    
    
    init(game: FixturesResponse) {
        super.init(nibName: nil, bundle: nil)
        self.game = game
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = tableView.contentSize
    }
    

    func configureViewController() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    func configureTableView() {
        tableView.register(FNGameEventCell.self, forCellReuseIdentifier: FNGameEventCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = FNColors.sectionColor
        tableView.prepareForDynamicHeight()
        tableView.isUserInteractionEnabled = false
    }
}


extension GameProgressVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = game.events else {
            preferredContentSize = CGSize(width: 0.01, height: 0)
            return 0
        }
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNGameEventCell.cellId, for: indexPath) as! FNGameEventCell
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        cell.set(game: game, indexPath: indexPath.row)
        return cell
    }
    
    
}
