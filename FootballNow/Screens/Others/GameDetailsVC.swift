//
//  GameDetailsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameDetailsVC: UIViewController {
    
    let scrollView = UIScrollView()
    let headerView = FNGameOverviewView()
    let segmentedControl = UISegmentedControl(items: ["Przebieg", "Statystyki", "Składy"])
    let stackView = UIStackView()
    let progressView = UIView()
    let statisticsView = UIView()
    let formationsView = UIView()
    
    var gameId: Int!
    var game: [FixturesData] = []
    
    init(gameId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.gameId = gameId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationItem()
        configureSegmentedControl()
        fetchDataForGame()
    }
    
    @objc func segmentedControlValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                progressView.isHidden = false
                statisticsView.isHidden = true
                formationsView.isHidden = true
            case 1:
                progressView.isHidden = true
                statisticsView.isHidden = false
                formationsView.isHidden = true
            case 2:
                progressView.isHidden = true
                statisticsView.isHidden = true
                formationsView.isHidden = false
            default:
                print("error")
        }
        
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        childVC.didMove(toParent: self)
    }
    
    
    func fetchDataForGame() {
        NetworkManager.shared.getFixtures(parameters: "id=\(self.gameId!)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixture):
                    DispatchQueue.main.async {
                        self.game = fixture.response
                        self.headerView.set(game: fixture.response[0])
                        
                        self.add(childVC: GameProgressVC(game: fixture.response[0]), to: self.progressView)
                        self.progressView.heightAnchor.constraint(equalToConstant: CGFloat(fixture.response[0].events!.count*40)).isActive = true
                        
                        self.add(childVC: GameStatisticsVC(statistics: fixture.response[0].statistics), to: self.statisticsView)
                        
                        self.add(childVC: GameFormationsVC(squad: fixture.response[0].lineups), to: self.formationsView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func configureNavigationItem() {
        
    }
    
    
//    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
//        if container as? GameProgressVC != nil {
//            let containerHeight = container.preferredContentSize.height
//            stackView.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
//        }
//    }
 
    
    func configureViewController() {
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(segmentedControl)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(statisticsView)
        stackView.addArrangedSubview(formationsView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            headerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 0)
        ])

    }
    
    
    func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControlValueChanged()
    }
}


extension GameDetailsVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let screenHeight = view.bounds.size.height
//        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y

        if offsetY > 68 {
            navigationItem.titleView = FNGameScoreTitleView(fixtureData: game[0])
        } else {
            navigationItem.titleView = nil
            navigationItem.title = "Podsumowanie meczu"
        }
    }
}