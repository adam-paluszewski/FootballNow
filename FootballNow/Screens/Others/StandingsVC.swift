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
    var standings: [StandingsResponse] = []
    var leagueId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchDataForStandings()
        
    }
    
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNStandingsCell.self, forCellReuseIdentifier: FNStandingsCell.cellId)
        tableView.backgroundColor = FNColors.sectionColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    
    func fetchDataForStandings() {
        showLoadingView(in: view)
        guard leagueId != nil else { return }
        NetworkManager.shared.getStandings(parameters: "league=\(leagueId!)&season=2022") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    self.standings = standings
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.setNavigationItemTitle(from: standings)
                        self.dismissLoadingView(in: self.view)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func setNavigationItemTitle(from standings: [StandingsResponse]) {
        let leagueName = standings[0].league.name ?? ""
        let leagueLogo = standings[0].league.logo ?? ""
        navigationItem.titleView = FNTeamTitleView(image: leagueLogo, title: leagueName)
    }

}


extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.isEmpty ? 0 : standings[0].league.standings[0].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNStandingsCell.cellId, for: indexPath) as! FNStandingsCell
        cell.set(standing: standings[0].league.standings[0][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = standings[0].league.standings[0][indexPath.row].team
        let teamDetails = TeamDetails(id: team.id!, name: team.name!, logo: team.logo!)
        let teamsData = TeamsResponse(team: teamDetails)
        navigationController?.pushViewController(TeamDashboardVC(isMyTeamShowing: false, team: teamsData), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView
    }
    
    
}
