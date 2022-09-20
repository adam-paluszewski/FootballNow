//
//  FNNextGames.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class FNNextGamesVC: UIViewController {

    let sectionView = FNSectionView(title: "Kolejne mecze")
    var nextGames: [FixturesResponse] = []
    let tableView = UITableView()
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
        configureTableView()
        fetchDataForNextGamesSection()
    }

    
    @objc func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        } completion: { finished in
            sender.transform = .identity
            let nextGamesListVC = NextGamesListVC()
            nextGamesListVC.nextGames = self.nextGames
            self.navigationController?.pushViewController(nextGamesListVC, animated: true)
        }
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
    
    
    func configureTableView() {
        tableView.register(FNNextGameCell.self, forCellReuseIdentifier: FNNextGameCell.cellId)
        tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }

    
    func fetchDataForNextGamesSection() {
        guard let teamId = teamId else { return }
        NetworkManager.shared.getFixtures(parameters: "team=\(teamId)&season=2022&next=15&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        guard !fixtures.isEmpty else {
                            self.showEmptyState(in: self.sectionView.bodyView)
                            return
                        }
                        self.nextGames = fixtures
                        self.sectionView.button.setTitle("Zobacz więcej", for: .normal)
                        self.tableView.reloadData()
                        
                        
                    }
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Błąd", message: error.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
            self.dismissLoadingView(in: self.sectionView.bodyView)
        }
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        let team = notification.object as? TeamsResponse
        teamId = team?.team.id
        fetchDataForNextGamesSection()
    }
    
    
    func layoutUI() {
        view.addSubview(sectionView)
        
        sectionView.bodyView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
}


extension FNNextGamesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIElementsSizes.nextGameCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextGames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNNextGameCell.cellId, for: indexPath) as! FNNextGameCell
        
        if !nextGames.isEmpty {
            cell.set(nextGame: nextGames[indexPath.row])
        }

        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
