//
//  SquadVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class SquadVC: UIViewController {

    let sectionView = FNSectionView(title: "Skład drużyny", buttonText: "Więcej")
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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

    
    @objc func buttonPressed() {
        print("squad")
    }
    
    
    func createFlowLayout(view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        print(view.bounds.height)
        print(view.bounds.width)
        let padding: CGFloat = 15
        let minimumItemSpacing: CGFloat = 10
        let availableWIdth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWIdth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: 190)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    
    func configureViewController() {
        sectionView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        addSubviews()
        addConstraints()
    }
    
    
    func configureCollectionView() {
        sectionView.bodyView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.collectionViewLayout = createFlowLayout(view: view)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(FNPlayerCell.self, forCellWithReuseIdentifier: FNPlayerCell.cellId)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sectionView.bodyView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sectionView.bodyView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sectionView.bodyView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sectionView.bodyView.bottomAnchor)
        ])
    }
    
    
    func addSubviews() {
        view.addSubview(sectionView)
    }
    
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}

extension SquadVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squad[0].players.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FNPlayerCell.cellId, for: indexPath) as! FNPlayerCell

        cell.set(player: squad[0].players[indexPath.row])
        
        return cell
    }
    
    
}
