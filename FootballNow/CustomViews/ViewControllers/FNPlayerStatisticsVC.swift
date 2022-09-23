//
//  FNPlayerStatisticsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 23/09/2022.
//

import UIKit

class FNPlayerStatisticsVC: UIViewController {
    
    let containerView = FNSectionView(title: "Pokaż statystyki dla:")
    let tableView = UITableView()
    
    let numberOfRowsInSection = [2, 3, 2, 2, 3, 1, 2, 2, 2, 3, 1]
    let titleForHeaderInSection = ["MECZE", "ZMIANY", "STRZAŁY", "GOLE", "PODANIA", "SPALONE", "POJEDYNKI", "ZWODY", "FAULE", "KARTKI", "RZUTY KARNE"]

    var statistics: [StatisticsP] = []
    var leagueToShow = 0


    init(statistics: [StatisticsP]) {
        super.init(nibName: nil, bundle: nil)
        self.statistics = statistics
        containerView.button.setTitle(statistics[0].league?.name, for: .normal)
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
        super.viewDidLayoutSubviews()
        preferredContentSize.height = tableView.contentSize.height + 41
    }
    
    
    func configureViewController() {
        containerView.button.addTarget(self, action: #selector(changeLeagueButtonPressed), for: .touchUpInside)
        layoutUI()
    }


    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FNPlayerStatisticCell.self, forCellReuseIdentifier: FNPlayerStatisticCell.cellId)
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = FNColors.backgroundColor
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        tableView.prepareForDynamicHeight()
    }


    func layoutUI() {
        view.addSubview(containerView)
        containerView.bodyView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: containerView.bodyView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bodyView.bottomAnchor),
        ])
    }



    @objc func changeLeagueButtonPressed() {
        let ac = UIAlertController(title: "Wybierz ligę", message: nil, preferredStyle: .actionSheet)
        for (index, league) in statistics.enumerated() {
            ac.addAction(UIAlertAction(title: statistics[index].league?.name, style: .default, handler: { action in
                self.containerView.button.setTitle(league.league?.name, for: .normal)
                self.leagueToShow = index
                self.tableView.reloadData()
            }))
        }

        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
        present(ac, animated: true)
    }
}


extension FNPlayerStatisticsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !statistics.isEmpty else { return 0 }
        return numberOfRowsInSection.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FNTableViewHeaderView(text: titleForHeaderInSection[section])
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSection[section]
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNPlayerStatisticCell.cellId, for: indexPath) as! FNPlayerStatisticCell
        cell.set(player: statistics[leagueToShow], indexPath: indexPath)

        return cell
    }
}
