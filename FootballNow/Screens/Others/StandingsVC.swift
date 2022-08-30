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
    var standings: [StandingsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchDataForStandings()
        
    }
    
    
    func configureViewController() {
        
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNStandingsCell.self, forCellReuseIdentifier: FNStandingsCell.cellId)
        tableView.backgroundColor = UIColor(named: "FNSectionColor")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    
    func fetchDataForStandings() {
        NetworkManager.shared.getStandings(parameters: "league=106&season=2022") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    self.standings = standings.response
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.setNavigationItemTitle(from: standings.response)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func setNavigationItemTitle(from standings: [StandingsData]) {
        let leagueName = standings[0].league.name ?? ""
        let leagueLogo = standings[0].league.logo ?? ""
        navigationItem.titleView = FNNavigationBarTitleView(image: leagueLogo, title: leagueName)
    }

}


extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView
    }
    
    
}
