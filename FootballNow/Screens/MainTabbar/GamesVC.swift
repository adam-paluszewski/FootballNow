//
//  GamesVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit

class GamesVC: UIViewController {
    
    var collectionView: UICollectionView!
    
    var observedLeagues: [LeaguesData] = []
    var games: [[FixturesData]] = []
    var collectionViewItemHeight: CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        createObservers()
        checkObservedLeagues()
        
//        if observedLeagues.isEmpty {
//            let manageLeaguesVC = ManageLeaguesVC()
//            navigationController?.pushViewController(manageLeaguesVC, animated: true)
//        }
        
        
        configureViewController()
        configureCollectionView()
        fetchDataForGames()
    }
    
    
    func createObservers() {
        let leagues = Notification.Name(NotificationKeys.myLeaguesChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: leagues, object: nil)
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        observedLeagues = notification.object as! [LeaguesData]
        fetchDataForGames()
    }
    

    func configureViewController() {
        navigationItem.title = "Najbliższy tydzień"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zarządzaj", style: .plain, target: self, action: #selector(manageLeagues))
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout(view: view))
        collectionView.register(FNLeagueCell.self, forCellWithReuseIdentifier: FNLeagueCell.cellId)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    func createFlowLayout(view: UIView) -> UICollectionViewFlowLayout {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 15
//        flow.itemSize = CGSize(width: 0, height: 0)
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return flow
    }
    
    
    @objc func manageLeagues() {
        let manageLeaguesVC = ManageLeaguesVC()
        manageLeaguesVC.observedLeagues = self.observedLeagues
        navigationController?.pushViewController(manageLeaguesVC, animated: true)
    }
    
    
    func checkObservedLeagues() {
        if let data = UserDefaults.standard.data(forKey: "myLeagues") {
            let decoder = JSONDecoder()
            
            if let observedLeagues = try? decoder.decode([LeaguesData].self, from: data) {
                self.observedLeagues = observedLeagues
                
                for i in observedLeagues {
                    print(i.league.name)
                }
            }
        }
    }
    
    
    func getCurrentDate() {
        let currentDate = Date()
        let oneWeekAheadDate = Date(timeIntervalSinceNow: 518400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let oneWeekAheadDateString = dateFormatter.string(from: oneWeekAheadDate)
        let currentDateString = dateFormatter.string(from: currentDate)
    }
    
    
    func fetchDataForGames() {
        games.removeAll()
//        let semaphore = DispatchSemaphore(value: 1)
        for i in observedLeagues {
//            semaphore.wait()
            let leagueId = i.league.id
            
            guard let leagueId = leagueId else { return }
            NetworkManager.shared.getFixtures(parameters: "league=\(leagueId)&from=2022-09-06&to=2022-09-13&season=2022&timezone=Europe/Warsaw") { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let fixtures):
                        self.games.append(fixtures.response)
                        DispatchQueue.main.async { self.collectionView.reloadData() }
//                        semaphore.signal()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

}


extension GamesVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FNLeagueCell.cellId, for: indexPath) as! FNLeagueCell

        cell.games = games[indexPath.item]
        cell.view.sectionTitleLabel.text = games[indexPath.item][0].league.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(view.frame.width), height: games[indexPath.item].count * 90 + 41)
    }
    
}
