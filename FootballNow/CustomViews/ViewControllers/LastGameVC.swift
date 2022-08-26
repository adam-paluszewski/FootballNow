//
//  LastGameVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class LastGameVC: UIViewController {
    
    let sectionView = FNSectionView(title: "Ostatni mecz", buttonText: "Więcej")
    let gameOverviewView = FNGameOverviewView()
    
    var lastGame: [FixturesData] = []
    
    
    init(lastGame: [FixturesData]) {
        super.init(nibName: nil, bundle: nil)
        self.lastGame = lastGame
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
        print("last")
    }
    
    
    func configure() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        gameOverviewView.set(game: lastGame[0])
    }
    
    
    func addSubviews() {
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(gameOverviewView)
    }
    
    
    func addConstraints() {
        gameOverviewView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            gameOverviewView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            gameOverviewView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            gameOverviewView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
            gameOverviewView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
}

