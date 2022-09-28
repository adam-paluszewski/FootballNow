//
//  ManageLeaguesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class ManageLeaguesVC: UIViewController {
    
    let tableView = UITableView()
    var observedLeagues: [LeaguesResponse] = [] {
        didSet {
            if observedLeagues.isEmpty {
                showEmptyState(in: view, text: "Nie obserwujesz żadnych rozgrywek. Wybierz swoje ulubione ligi i nie przegap żadnego meczu.", image: .noMyLeagues, axis: .vertical)
            } else {
                dismissEmptyState(in: view)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getObservedLeagues()
    }
    
    
    func configureViewController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Zarządzaj ligami"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLeaguePressed))
        
        
        
        layoutUI()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNManageLeaguesCell.self, forCellReuseIdentifier: FNManageLeaguesCell.cellId)
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.sectionHeaderHeight = 40
        tableView.rowHeight = 60
    }
    
    
    func getObservedLeagues() {
        PersistenceManager.shared.retrieveMyLeagues { result in
            switch result {
                case .success(let leagues):
                    self.observedLeagues = leagues
                    self.tableView.reloadDataOnMainThread()
                case .failure(let error):
                    presentAlertOnMainThread(title: "Błąd", message: error.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
        }
    }


    @objc func addLeaguePressed() {
        let selectLeagueVC = SelectLeagueVC()
        selectLeagueVC.VCDismissed = { [weak self] in
            self?.getObservedLeagues()
        }
        let navController = UINavigationController(rootViewController: selectLeagueVC)
        present(navController, animated: true)
    }
    
    
    @objc func removeFromLeaguesButtonPressed(sender: UIButton) {
        PersistenceManager.shared.updateWith(league: observedLeagues[sender.tag], actionType: .remove) { error in
            observedLeagues.remove(at: sender.tag)
            tableView.reloadData()
        }
    }

    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension ManageLeaguesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return FNFormationsHeaderView(title: "OBSERWOWANE LIGI", allingment: .left)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
