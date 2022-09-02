//
//  GameFormationsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameFormationsVC: UIViewController {
    
    let tableView = UITableView()
    
    var squad: [Lineups] = []
    
    
    init(squad: [Lineups]?) {
        super.init(nibName: nil, bundle: nil)
        if let squad = squad {
            self.squad = squad
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        var tableViewHeight = tableView.contentSize + tableView.contentInset.bottom + tableView.contentInset.top + tableView.numberOfSections * tableView.sectionHeaderHeight
        preferredContentSize = CGSize(width: view.frame.width, height: tableViewHeight)
    }
    

    func configureViewController() {
        
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNFormationCell.self, forCellReuseIdentifier: FNFormationCell.cellId)
        tableView.isScrollEnabled = false
        
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


extension GameFormationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView()
        switch section {
            case 0:
                header = FNFormationsHeaderView(title: "Formacja")
            case 1:
                header = FNFormationsHeaderView(title: "Trener")
            case 2:
                header = FNFormationsHeaderView(title: "Wyjściowa jedenastka")
            case 3:
                header = FNFormationsHeaderView(title: "Rezerwowi")
            default:
                header = FNFormationsHeaderView(title: "")
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return squad[0].startXI?.count ?? 0
            case 3:
                return squad[0].substitutes?.count ?? 0
            default:
                return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNFormationCell.cellId, for: indexPath) as! FNFormationCell
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        
        switch indexPath.section {
            case 0:
                cell.setFormation(homeFormation: squad[0], awayFormation: squad[1])
            case 1:
                cell.setCoach(homeCoach: squad[0].coach, awayCoach: squad[1].coach)
            case 2:
                cell.setStartingXI(homeSquad: squad[0].startXI?[indexPath.row], awaySquad: squad[1].startXI?[indexPath.row])
            case 3:
                cell.setSubstitutes(homeSquad: squad[0].substitutes?[indexPath.row], awaySquad: squad[1].substitutes?[indexPath.row])
            default:
                print("error")
        }
        return cell
    }
    
}
