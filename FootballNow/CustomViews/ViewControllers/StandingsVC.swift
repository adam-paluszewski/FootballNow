//
//  StandingsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class StandingsVC: UIViewController {

    let sectionView = FNSectionView(title: "Tabela ligowa", buttonText: "Więcej")
    let standingsView = FNMyTeamStandingsView()
    var standings: [StandingsData] = []
    
    init(yourTeamStandings: [StandingsData]) {
        super.init(nibName: nil, bundle: nil)
        self.standings = yourTeamStandings
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
        print("standings")
    }
    
    
    func configure() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        standingsView.set(standing: standings[0].league.standings[0][0])
    }
    
    
    func addSubviews() {
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(standingsView)
    }
    
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            standingsView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            standingsView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            standingsView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            standingsView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
    



}
