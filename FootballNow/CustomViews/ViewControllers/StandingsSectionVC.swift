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
    var countryLeagueId: Int?
    
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
        fetchDataForStandingsSection()
    }
    
    
    func createObservers() {
        let team = Notification.Name(NotificationKeys.selectedTeam)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: team, object: nil)
    }
    
    
    func configureViewController() {
        showLoadingView(in: sectionView.bodyView)
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        layoutUI()
    }
    
    
    func fetchDataForStandingsSection() {
        guard let teamId = teamId else { return }
        NetworkManager.shared.getStandings(parameters: "season=2022&team=\(teamId)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    DispatchQueue.main.async {
                        self.dismissLoadingView(in: self.sectionView.bodyView)
                        self.fetchDataForLeagues(yourTeamStandings: standings.response)
                    }
                case .failure(let error):
                    self.preferredContentSizeOnMainThread(size: CGSize(width: 0.01, height: 0))
                    print(error)
            }
        }
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
    
    
    func fetchDataForLeagues(yourTeamStandings: [StandingsData]) {
        NetworkManager.shared.getLeagues(parameters: "season=2022&team=\(teamId!)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let leagues):
                    //Standings api returns [] of leagues w/o id
                    //We need id to fetch data for League Standings(next screen) and to know which league to show (this screen)
                    //Extra endpoint is needed, then we check which league is Country League and we show data from only this one
                    let leagues = leagues.response
                    let countryLeague = leagues.filter{$0.league.type == "League"}
                    
                    guard !countryLeague.isEmpty else {
                        self.preferredContentSizeOnMainThread(size: CGSize(width: 0.01, height: 0))
                        return
                    }
                    self.countryLeagueId = countryLeague[0].league.id
                    let countryLeagueStanding = yourTeamStandings.filter{$0.league.id == self.countryLeagueId}

                    
                    DispatchQueue.main.async {
                        self.standingsView.set(standing: countryLeagueStanding[0].league.standings[0][0])
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        let team = notification.object as? TeamsData
        teamId = team?.team.id
        fetchDataForStandingsSection()
    }
    
    
    func layoutUI() {
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
