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
    
    
    override func viewDidLayoutSubviews() {
        let size = max(tableView.contentSize.height, 500)
        preferredContentSize.height = size
    }
    

    func configureViewController() {
        layoutUI()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNFormationCell.self, forCellReuseIdentifier: FNFormationCell.cellId)
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = 0
        tableView.prepareForDynamicHeight()
        tableView.isUserInteractionEnabled = false
    }

    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


extension GameFormationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !squad.isEmpty else {
            showEmptyState(in: view, text: "Brak informacji o składach dla tego meczu", image: .formations, axis: .vertical)
            return 0
        }
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView()
        switch section {
            case 0:
                header = FNFormationsHeaderView(title: "FORMACJA", allingment: .center)
            case 1:
                header = FNFormationsHeaderView(title: "TRENER", allingment: .center)
            case 2:
                header = FNFormationsHeaderView(title: "WYJŚCIOWA JEDENSTKA", allingment: .center)
            case 3:
                header = FNFormationsHeaderView(title: "REZEROWI", allingment: .center)
            default:
                header = FNFormationsHeaderView(title: "", allingment: .center)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 41 : 56
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
        guard !squad.isEmpty else { return cell }
        
        switch indexPath.section {
            case 0:
                cell.setFormation(homeFormation: squad[0], awayFormation: squad[1])
            case 1:
                cell.setCoach(homeCoach: squad[0].coach, awayCoach: squad[1].coach)
            case 2:
                cell.setStartingXI(homeSquad: squad[0].startXI?[indexPath.row], awaySquad: squad[1].startXI?[indexPath.row])
            case 3:
                let homeSubstitutes: Substitutes?
                let awaySubstitutes: Substitutes?
                let homeSubstitutesCount = squad[0].substitutes?.count ?? 0
                let awaySubstitutesCount = squad[1].substitutes?.count ?? 0
                
                if homeSubstitutesCount > indexPath.row {
                    homeSubstitutes = squad[0].substitutes?[indexPath.row]
                } else {
                    homeSubstitutes = nil
                }
                
                if awaySubstitutesCount > indexPath.row {
                    awaySubstitutes = squad[1].substitutes?[indexPath.row]
                } else {
                    awaySubstitutes = nil
                }
                
                cell.setSubstitutes(homeSquad: homeSubstitutes, awaySquad: awaySubstitutes)
            default:
                print("error")
        }
        return cell
    }
    
}
