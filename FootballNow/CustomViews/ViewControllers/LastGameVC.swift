//
//  LastGameVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class LastGameVC: UIViewController {
    
    let section = FNSectionView(title: "Ostatni mecz", buttonText: "Więcej")
    let tableView = UITableView()
    
    var lastGame: [GameData] = []
    
    
    init(lastGame: [GameData]) {
        super.init(nibName: nil, bundle: nil)
        self.lastGame = lastGame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 225/255, green: 242/255, blue: 251/255, alpha: 1)
        layoutUI()
        tableView.register(GameOverviewCell.self, forCellReuseIdentifier: GameOverviewCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        section.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    
    
    
    
    func layoutUI() {
        view.addSubview(section)
        section.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            section.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            section.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            section.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            section.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: section.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: section.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: section.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: section.bodyView.bottomAnchor)
        ])
    }

    
    @objc func buttonPressed() {
        print("last")
    }
}


extension LastGameVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameOverviewCell.cellId, for: indexPath) as! GameOverviewCell
        cell.set(game: lastGame[0])
        
        return cell
    }
    
    
}
