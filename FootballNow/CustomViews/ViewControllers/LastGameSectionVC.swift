//
//  LastGameSectionVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class LastGameSectionVC: UIViewController {
    
    let sectionView = FNSectionView(title: "Ostatni mecz", buttonText: "Więcej")
    let gameOverviewView = FNGameOverviewView()
    
    var lastGames: [FixturesData] = []
    
    
    init(lastGame: [FixturesData]) {
        super.init(nibName: nil, bundle: nil)
        self.lastGames = lastGame
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    @objc func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        } completion: { finished in
            sender.transform = .identity
            let lastGamesListVC = LastGamesListVC()
            lastGamesListVC.lastGames = self.lastGames
            self.navigationController?.pushViewController(lastGamesListVC, animated: true)
        }
    }
    
    
    func configureViewController() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        if !lastGames.isEmpty {
            gameOverviewView.set(game: lastGames[0])
        }

        
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(gameOverviewView)
        
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

