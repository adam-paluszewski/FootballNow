//
//  PlayerVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 05/09/2022.
//

import UIKit

class PlayerVC: UIViewController {
    
    let scrollView = UIScrollView()
    let tableView = UITableView()
    
    let infoContainerView = FNPlayerDetailsView()
    let statisticsContainerView = FNSectionView(title: "Pokaż statystyki dla:", buttonText: "")
    
    var playerId: Int!
    var playerNumber: Int?
    var playerPosition: String?
    
    var player: [PlayersData] = []
    var leagueToShow = 0
    
    init(id: Int, number: Int?, position: String?) {
        super.init(nibName: nil, bundle: nil)
        self.playerId = id
        self.playerNumber = number
        self.playerPosition = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchDataforPlayerDetails()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(tableView.contentSize.height + statisticsContainerView.headerView.bounds.height)
        statisticsContainerView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height + statisticsContainerView.headerView.bounds.height).isActive = true
    }
    
    
    func fetchDataforPlayerDetails() {
        guard let playerId = playerId else { return }
        NetworkManager.shared.getPlayer(parameters: "id=\(playerId)&season=2022") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let player):
                    DispatchQueue.main.async {
                        self.statisticsContainerView.button.setTitle(player.response[0].statistics[0].league.name, for: .normal)
                        self.infoContainerView.set(player: player.response[0].player, number: self.playerNumber, position: self.playerPosition)
                        self.player = player.response
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    @objc func changeLeagueButtonPressed() {
        let ac = UIAlertController(title: "Wybierz ligę", message: nil, preferredStyle: .actionSheet)
        
        for i in player[0].statistics {
            ac.addAction(UIAlertAction(title: i.league.name, style: .default, handler: { action in
                self.statisticsContainerView.button.setTitle(i.league.name, for: .normal)
                
                if action == ac.actions[0] {
                    self.leagueToShow = 0
                } else if action == ac.actions[1] {
                    self.leagueToShow = 1
                } else if action == ac.actions[2] {
                    self.leagueToShow = 2
                } else if action == ac.actions[3] {
                    self.leagueToShow = 3
                } else if action == ac.actions[4] {
                    self.leagueToShow = 4
                } else if action == ac.actions[5] {
                    self.leagueToShow = 5
                } else if action == ac.actions[6] {
                    self.leagueToShow = 6
                }
                self.tableView.reloadData()
            }))
        }

        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
        present(ac, animated: true)
    }

  
    func configureViewController() {
        navigationItem.title = "Informacje o zawodniku"
        scrollView.delegate = self
        view.backgroundColor = FNColors.backgroundColor
        statisticsContainerView.separatorView.backgroundColor = .clear
        statisticsContainerView.button.addTarget(self, action: #selector(changeLeagueButtonPressed), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(infoContainerView)
        scrollView.addSubview(statisticsContainerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        statisticsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            infoContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            infoContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            infoContainerView.heightAnchor.constraint(equalToConstant: 465),
            
            statisticsContainerView.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor),
            statisticsContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            statisticsContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            statisticsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            statisticsContainerView.heightAnchor.constraint(equalToConstant: 1300)
        ])
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNPlayerStatisticCell.self, forCellReuseIdentifier: FNPlayerStatisticCell.cellId)
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = 0
        tableView.isUserInteractionEnabled = false
        tableView.prepareForDynamicHeight()
        
        statisticsContainerView.bodyView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: statisticsContainerView.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: statisticsContainerView.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: statisticsContainerView.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: statisticsContainerView.bodyView.bottomAnchor)
        ])
        
    }

}


extension PlayerVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard !player.isEmpty else { return 0 }
        return 11
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        55
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        FNPlayerStatisticsSupport.shared.getViewForHeaderInSection(for: section)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FNPlayerStatisticsSupport.shared.getNumberOfRowsInSection(for: section)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNPlayerStatisticCell.cellId, for: indexPath) as! FNPlayerStatisticCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.set(player: player[0].statistics[leagueToShow], indexPath: indexPath)

        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 170 {
            navigationItem.titleView = FNTeamTitleView(image: (player[0].player.photo ?? ""), title: (player[0].player.name ?? ""))
        } else {
            navigationItem.titleView = nil
        }
    }

}
