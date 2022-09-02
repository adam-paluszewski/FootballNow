//
//  GameStatisticsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameStatisticsVC: UIViewController {
    
    var statistics: [Statistics] = []
    
    let tableView = UITableView()
    let noStatisticsView = FNNoResultsView(text: "Brak statystyk dla tego meczu", image: UIImage(named: "FNStatistics")!, imagePosition: .top)
    
    init(statistics: [Statistics]?) {
        super.init(nibName: nil, bundle: nil)
        if let statistics = statistics {
            self.statistics = statistics
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureNoStatisticsView()
    }
    

    func configureViewController() {
        view.backgroundColor = UIColor(named: "FNSectionColor")
        
    }

    
    func configureTableView() {
        tableView.register(FNGameStatisticsCell.self, forCellReuseIdentifier: FNGameStatisticsCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func configureNoStatisticsView() {
        noStatisticsView.isHidden = true
        
        view.addSubview(noStatisticsView)
        NSLayoutConstraint.activate([
            noStatisticsView.topAnchor.constraint(equalTo: view.topAnchor),
            noStatisticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noStatisticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noStatisticsView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}


extension GameStatisticsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !statistics.isEmpty else {
            noStatisticsView.isHidden = false
            preferredContentSize = CGSize(width: 0.01, height: 0)
            return 0
        }
        noStatisticsView.isHidden = true
        preferredContentSize = CGSize(width: view.frame.width, height: Double(statistics[0].ckey!.count * 50))
        return statistics[0].ckey?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNGameStatisticsCell.cellId, for: indexPath) as! FNGameStatisticsCell
        cell.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        cell.set(homeStats: statistics[0].ckey?[indexPath.row], awayStats: (statistics[1].ckey?[indexPath.row]))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
