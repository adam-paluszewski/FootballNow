//
//  ManageLeaguesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class ManageLeaguesVC: UIViewController {
    
    let tableView = UITableView()
    var observedLeagues: [LeaguesData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configureViewController()
        configureTableView()
        print("Observed leagues: \(observedLeagues.count)")
    }
    
    
    func createObservers() {
        let leagues = Notification.Name(NotificationKeys.myLeaguesChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: leagues, object: nil)
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        observedLeagues = notification.object as! [LeaguesData]
        tableView.reloadData()
    }
    

    @objc func addLeaguePressed() {
        let selectLeagueVC = SelectLeagueVC()
        selectLeagueVC.observedLeagues = self.observedLeagues
        let navController = UINavigationController(rootViewController: selectLeagueVC)
        present(navController, animated: true)
    }
    
    
    @objc func removeFromLeaguesButtonPressed(sender: UIButton) {
        observedLeagues.remove(at: sender.tag)
        tableView.reloadData()
        
        let leagues = Notification.Name(NotificationKeys.myLeaguesChanged)
        NotificationCenter.default.post(name: leagues, object: observedLeagues)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(observedLeagues) {
            UserDefaults.standard.set(data, forKey: "myLeagues")
        }
    }

    
    func configureViewController() {
        navigationItem.title = "Zarządzaj ligami"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLeaguePressed))
        
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNManageLeaguesCell.self, forCellReuseIdentifier: FNManageLeaguesCell.cellId)
        tableView.backgroundColor = FNColors.backgroundColor
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension ManageLeaguesVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        observedLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNManageLeaguesCell.cellId, for: indexPath) as! FNManageLeaguesCell
        cell.removeFromLeaguesButton.tag = indexPath.row
        cell.set(league: observedLeagues[indexPath.row])
        cell.removeFromLeaguesButton.addTarget(self, action: #selector(removeFromLeaguesButtonPressed), for: .touchUpInside)
        return cell
    }
    
    
}
