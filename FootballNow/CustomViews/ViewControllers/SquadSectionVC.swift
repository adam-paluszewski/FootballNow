//
//  SquadSectionVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class SquadSectionVC: UIViewController {

    let sectionView = FNSectionView(title: "Zawodnicy", buttonText: "Więcej")
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var squad: [SquadsData] = []
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
        configureCollectionView()
        fetchDataforSquadSection()
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

    
    @objc func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        } completion: { finished in
            sender.transform = .identity
            let squadListVC = SquadListVC()
            squadListVC.squad = self.squad
            self.navigationController?.pushViewController(squadListVC, animated: true)
        }
    }
    
    
    func createFlowLayout(view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width

        let padding: CGFloat = 15
        let minimumItemSpacing: CGFloat = 10
        let availableWIdth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWIdth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: UIElementsSizes.teamDashboardPlayerCellHeight)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }

    
    func fetchDataforSquadSection() {
        guard let teamId = teamId else { return }
        NetworkManager.shared.getSquads(parameters: "team=\(teamId)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let squad):
                    DispatchQueue.main.async {
                        self.squad = squad.response
                        self.collectionView.reloadData()
                        self.dismissLoadingView(in: self.sectionView.bodyView)
                    }
                case .failure(let error):
                    self.preferredContentSizeOnMainThread(size: CGSize(width: 0.01, height: 0))
                    print(error)
            }
        }
    }
    
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = createFlowLayout(view: view)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(FNCollectionPlayerCell.self, forCellWithReuseIdentifier: FNCollectionPlayerCell.cellId)
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        let team = notification.object as? TeamsData
        teamId = team?.team.id
        fetchDataforSquadSection()
    }
    
    
    func layoutUI() {
        view.addSubview(sectionView)
        
        sectionView.bodyView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            collectionView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
}


extension SquadSectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !squad.isEmpty else { return 0 }
        return squad[0].players.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FNCollectionPlayerCell.cellId, for: indexPath) as! FNCollectionPlayerCell
        if !squad.isEmpty {
            cell.set(player: squad[0].players[indexPath.item])
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerId = squad[0].players[indexPath.item].id
        let playerNumber = squad[0].players[indexPath.item].number
        let playerPosition = squad[0].players[indexPath.item].position
        
        let playerVC = PlayerVC(id: playerId, number: playerNumber, position: playerPosition)
        navigationController?.pushViewController(playerVC, animated: true)
    }
    
    
}
