//
//  StandingsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class StandingsVC: UIViewController {

    let tableView = UITableView()
    let tableViewHeaderView = FNStandingsHeaderView()
    
    var currentLeagueStandings: [[Standing]] = []
    var allLeaguesStandings: [StandingsResponse] = []
    var leagueId: Int?
    var teamId: Int!
    var teamGroup = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchDataForStandings()
        
    }
    
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        let leagueButton = UIBarButtonItem(title: "ZMIEŃ", style: .plain, target: self, action: #selector(changeLeagueButtonPressed))
        navigationItem.rightBarButtonItem = leagueButton
        
        layoutUI()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNStandingsCell.self, forCellReuseIdentifier: FNStandingsCell.cellId)
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
    }

    
    func fetchDataForStandings() {
        showLoadingView(in: view)
        guard leagueId != nil else { return }
        NetworkManager.shared.getStandings(parameters: "league=\(leagueId!)&season=2022") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    self.currentLeagueStandings = standings[0].league?.standings ?? []
                    self.checkInWhichGroupIsTeam()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.setNavigationItemTitle(from: standings[0].league)
                        self.dismissLoadingView(in: self.view)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func checkInWhichGroupIsTeam() {
        let groupsCount = currentLeagueStandings.count
        guard groupsCount > 0 else { return }
        for group in 0...groupsCount-1 {
            if !currentLeagueStandings[group].filter({$0.team?.id == teamId}).isEmpty {
                teamGroup = group
            }
        }
    }
    
    
    @objc func changeLeagueButtonPressed() {
        let ac = UIAlertController(title: "Wybierz ligę", message: nil, preferredStyle: .actionSheet)
        for (index, league) in allLeaguesStandings.enumerated() {
            ac.addAction(UIAlertAction(title: allLeaguesStandings[index].league?.name, style: .default, handler: { action in
                self.leagueId = league.league?.id
                self.fetchDataForStandings()
            }))
        }

        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func setNavigationItemTitle(from standings: LeagueS?) {
        let leagueName = standings?.name ?? ""
        let leagueLogo = standings?.logo ?? ""
        navigationItem.titleView = FNTeamTitleView(image: leagueLogo, title: leagueName)
    }
    
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}


extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !currentLeagueStandings.isEmpty else { return 0 }
        return currentLeagueStandings[teamGroup].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNStandingsCell.cellId, for: indexPath) as! FNStandingsCell
        cell.set(standing: currentLeagueStandings[teamGroup][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = currentLeagueStandings[teamGroup][indexPath.row].team
        let teamData = TeamDetails(id: team?.id, name: team?.name, logo: team?.logo)
        navigationController?.pushViewController(TeamDashboardVC(isMyTeamShowing: false, team: teamData), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView
    }
    
    
}
