//
//  StandingsSectionVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class StandingsSectionVC: UIViewController {

    let sectionView = FNSectionView(title: "Tabela ligowa", buttonText: "Więcej")
    let standingsView = FNMyTeamStandingsView()
    var yourTeamStandings: [StandingsData] = []
    var countryLeagueId: Int?
    
    init(yourTeamStandings: [StandingsData]) {
        super.init(nibName: nil, bundle: nil)
        self.yourTeamStandings = yourTeamStandings
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        fetchDataForLeagues()
    }
    
    
    @objc func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        } completion: { finished in
            sender.transform = .identity
            let leagueStandingsVC = StandingsVC()
            leagueStandingsVC.leagueId = self.countryLeagueId
            self.navigationController?.pushViewController(leagueStandingsVC, animated: true)
        }
    }
    
    
    func fetchDataForLeagues() {
        guard !yourTeamStandings.isEmpty else { return }
        let myTeamId = String(yourTeamStandings[0].league.standings[0][0].team.id ?? 0)
        NetworkManager.shared.getLeagues(parameters: "season=2022&team=\(myTeamId)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let leagues):
                    
                    //Standings api returns [] of leagues w/o id
                    //We need id to fetch data for League Standings(next screen) and to know which league to show (this screen)
                    //Extra endpoint is needed, then we check which league is Country League and we show data from only this one
                    let leagues = leagues.response
                    let countryLeague = leagues.filter{$0.league.type == "League"}
                    self.countryLeagueId = countryLeague[0].league.id
                    let countryLeagueStanding = self.yourTeamStandings.filter{$0.league.id == self.countryLeagueId}
                    
                    DispatchQueue.main.async {
                        self.standingsView.set(standing: countryLeagueStanding[0].league.standings[0][0])
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func configureViewController() {
        
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        view.addSubview(sectionView)
        sectionView.bodyView.addSubview(standingsView)
        
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
