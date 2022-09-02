//
//  SelectTeamVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class SelectTeamVC: UIViewController {

    let tableView = UITableView()
    var teams: [TeamsData] = []
    var isCancelable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchDataForTeams()
    }
    

    func passSelectedTeam(teamData: TeamsData) {
        let team = Notification.Name(NotificationKeys.selectedTeam)
        NotificationCenter.default.post(name: team, object: teamData)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(teamData) {
            UserDefaults.standard.set(data, forKey: "myTeam")
        }
        
        dismiss(animated: true)
    }
  
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        navigationItem.title = "Wybierz swoją drużynę"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "FNNavBarColor")
        
        if isCancelable {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(dismissVC))
        }
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func configureTableView() {
        tableView.register(FNSelectTeamCell.self, forCellReuseIdentifier: FNSelectTeamCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "FNSectionBackground")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchDataForTeams() {
            NetworkManager.shared.getTeams(parameters: "league=106&season=2022") { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let teams):
                        self.teams = teams.response
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    case .failure(let error):
                        print(error)
                }
            }
    }
}


extension SelectTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSelectTeamCell.cellId, for: indexPath) as! FNSelectTeamCell
        cell.set(teams: teams[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passSelectedTeam(teamData: teams[indexPath.row])
    }
    
}
