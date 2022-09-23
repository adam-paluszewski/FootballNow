//
//  PlayerVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 05/09/2022.
//

import UIKit

class PlayerVC: UIViewController {
    
    let scrollView = UIScrollView()
    let detailsContainerView = UIView()
    let statisticsContainerView = UIView()
    
    var playerId: Int!
    var playerNumber: Int?
    var playerPosition: String?
    var details: PlayerP?
    
    
    init(id: Int?, number: Int?, position: String?) {
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
        fetchDataforPlayerDetails()
    }
    

    func configureViewController() {
        navigationItem.title = "Informacje o zawodniku"
        scrollView.delegate = self
        view.backgroundColor = FNColors.backgroundColor

        layoutUI()
    }
    
    
    func fetchDataforPlayerDetails() {
        guard let playerId = playerId else { return }
        NetworkManager.shared.getPlayer(parameters: "id=\(playerId)&season=2022") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let player):
                    guard !player.isEmpty else {
                        DispatchQueue.main.async {
                            self.showEmptyState(in: self.view, text: "Brak szczegółowych informacji o tym zawodniku", image: .defaultImage, axis: .vertical)
                        }
                        return
                    }
                    self.details = player[0].player
                    let statistics = player[0].statistics
                    DispatchQueue.main.async { [self] in
                        self.add(childVC: FNPlayerDetailsVC(details: self.details, number: self.playerNumber, position: self.playerPosition), to: self.detailsContainerView)
                        self.add(childVC: FNPlayerStatisticsVC(statistics: statistics), to: self.statisticsContainerView)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        let height = container.preferredContentSize.height
        if container as? FNPlayerDetailsVC != nil {
            detailsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        } else if container as? FNPlayerStatisticsVC != nil {
            statisticsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    func layoutUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(detailsContainerView)
        scrollView.addSubview(statisticsContainerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        detailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        statisticsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            detailsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            detailsContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            detailsContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            detailsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    
            statisticsContainerView.topAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: 30),
            statisticsContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            statisticsContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            statisticsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

}


extension PlayerVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard details != nil else { return }
        let offset = scrollView.contentOffset.y
        if offset > 170 {
            navigationItem.title = nil
            navigationItem.titleView = FNPlayerTitleView(image: (details?.photo ?? ""), title: (details?.name ?? ""))
        } else {
            navigationItem.titleView = nil
            navigationItem.title = "Informacje o zawodniku"
        }
    }

}
