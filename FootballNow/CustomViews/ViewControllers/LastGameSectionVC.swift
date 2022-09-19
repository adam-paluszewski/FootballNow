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
    var teamId: Int!
    
    init(teamId: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.teamId = teamId
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configureViewController()
        fetchDataForLastGameSection()
    }
    
    
    func createObservers() {
        let team = Notification.Name(NotificationKeys.selectedTeam)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: team, object: nil)
    }
    
    
    func configureViewController() {
        showLoadingView(in: sectionView.bodyView)
        sectionView.button.addTarget(self, action: #selector(showAllButtonPressed), for: .touchUpInside)
        gameDetailsButton.addTarget(self, action: #selector(gameDetailsButtonPressed), for: .touchUpInside)
        
        layoutUI()
    }
    
    
    func fetchDataForLastGameSection() {
        guard let teamId = teamId else { return }
        NetworkManager.shared.getFixtures(parameters: "team=\(teamId)&season=2022&last=10&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.dismissLoadingView(in: self.sectionView.bodyView)
                        self.lastGames = fixtures.response
                        DispatchQueue.main.async {
                            self.gameOverviewView.set(game: fixtures.response[0])
                        }
                    }
                case .failure(let error):
                    self.preferredContentSizeOnMainThread(size: CGSize(width: 0.01, height: 0))
                    print(error)
            }
        }
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
    
    
    @objc func fireObserver(notification: NSNotification) {
        let team = notification.object as? TeamsData
        teamId = team?.team.id
        fetchDataForLastGameSection()
    }

    
    func layoutUI() {
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

