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
    let gameDetailsButton = UIButton()
    
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
    
    
    @objc func gameDetailsButtonPressed() {
        let gameDetailsVC = GameDetailsVC(gameId: lastGames[0].fixture.id)
        navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
    
    
    @objc func showAllButtonPressed(_ sender: UIButton) {
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
        sectionView.button.addTarget(self, action: #selector(showAllButtonPressed), for: .touchUpInside)
        gameDetailsButton.addTarget(self, action: #selector(gameDetailsButtonPressed), for: .touchUpInside)
        
        if !lastGames.isEmpty {
            gameOverviewView.set(game: lastGames[0])
        }

        
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(gameOverviewView)
        sectionView.bodyView.addSubview(gameDetailsButton)
        
        gameOverviewView.translatesAutoresizingMaskIntoConstraints = false
        gameDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            gameOverviewView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            gameOverviewView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            gameOverviewView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
            gameOverviewView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor),
            
            gameDetailsButton.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor, constant: 0),
            gameDetailsButton.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor, constant: 0),
            gameDetailsButton.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor, constant: 0),
            gameDetailsButton.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor, constant: 0),
        ])
    }
}

