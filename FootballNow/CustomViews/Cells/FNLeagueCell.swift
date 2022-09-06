//
//  FNLeagueCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class FNLeagueCell: UICollectionViewCell {
    
    static let cellId = "LeaguesCell"
    
    let view = FNSectionView(title: "")
    let tableView = UITableView()
    
    var games: [FixturesData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        backgroundColor = FNColors.sectionColor
        tableView.register(FNNextGameCell.self, forCellReuseIdentifier: FNNextGameCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }
    
    
    func addSubviews() {
        addSubview(view)
        view.bodyView.addSubview(tableView)
    }
    
    
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bodyView.bottomAnchor)
        ])

    }
}


extension FNLeagueCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNNextGameCell.cellId, for: indexPath) as! FNNextGameCell
        cell.set(nextGame: games[indexPath.row])
        return cell
    }
    
    
}
