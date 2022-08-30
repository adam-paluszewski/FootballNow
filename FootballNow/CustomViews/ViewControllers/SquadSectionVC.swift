//
//  SquadSectionVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class SquadSectionVC: UIViewController {

    let sectionView = FNSectionView(title: "Skład drużyny", buttonText: "Więcej")
    var collectionView: UICollectionView!
    
    var squad: [SquadsData] = []
    
    
    init(squad: [SquadsData]) {
        super.init(nibName: nil, bundle: nil)
        self.squad = squad
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
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
    
    
    func configureViewController() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        view.addSubview(sectionView)
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: sectionView.bounds, collectionViewLayout: createFlowLayout(view: view))
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(FNCollectionPlayerCell.self, forCellWithReuseIdentifier: FNCollectionPlayerCell.cellId)
        
        sectionView.bodyView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
}

extension SquadSectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squad[0].players.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FNCollectionPlayerCell.cellId, for: indexPath) as! FNCollectionPlayerCell
        if !squad.isEmpty {
            cell.set(player: squad[0].players[indexPath.row])
        }
        return cell
    }
    
    
}
