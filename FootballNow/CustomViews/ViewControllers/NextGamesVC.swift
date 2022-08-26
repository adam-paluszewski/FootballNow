//
//  NextGamesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class NextGamesVC: UIViewController {

    let sectionView = FNSectionView(title: "Kolejne mecze", buttonText: "Rozwiń")
    var nextGames: [FixturesData] = []
    let tableView = UITableView()
    
    init(nextGames: [FixturesData]) {
        super.init(nibName: nil, bundle: nil)
        self.nextGames = nextGames
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        addConstraints()
    }

    
    @objc func buttonPressed() {
        
    }

    
    func configure() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        tableView.register(FNNextGameCell.self, forCellReuseIdentifier: FNNextGameCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
    
    
    func addSubviews() {
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(tableView)
    }
    
    
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
}


extension NextGamesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNNextGameCell.cellId, for: indexPath) as! FNNextGameCell
        
        cell.set(nextGame: nextGames[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
