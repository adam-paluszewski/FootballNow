//
//  ViewController.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let lastGameSectionView = UIView()
    let standingsSectionView = UIView()
    let nextGamesSectionView = UIView()
    let squadSectionView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewController()
        layoutUI()
        fetchDataForLastGameSection()
        fetchDataForStandingsSection()
        fetchDataForNextGamesSection()
        fetchDataforSquadSection()
        
        
    }
    
    
    func configureViewController() {
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        scrollView.showsVerticalScrollIndicator = false
    }
    
    
    func configureNavigationBar() {
        setNavBarAppearance()
        setTitleForNavBar()
        setRightNavBarItem()
    }
    
    
    func setTitleForNavBar() {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = .systemFont(ofSize: 18)
        label.text = "Dzień dobry, kibicu Rakowa!"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    
    func setRightNavBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "hammer"), style: .plain, target: self, action: #selector(openSettings))
    }
    
    
    func setNavBarAppearance() { //move somewhere else later
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .tertiarySystemBackground
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    
    @objc func openSettings() {
        let ac = UIAlertController(title: "Wybierz pownownie drużynę", message: "Możesz zmieniać ją w dowolnej chwili", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Zmień", style: .destructive, handler: {_ in
            self.performSegue(withIdentifier: "goToSelectTeam", sender: self)
        }))
        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel))
        present(ac, animated: true)
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
    
    
    func fetchDataForLastGameSection() {
        NetworkManager.shared.getFixtures(parameters: "team=3491&season=2022&last=1&timezone=Europe/Warsaw") { result in
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: LastGameVC(lastGame: fixtures.response), to: self.lastGameSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataForStandingsSection() {
        NetworkManager.shared.getStandings(parameters: "season=2022&team=3491") { result in
            switch result {
                case .success(let standings):
                    DispatchQueue.main.async {
                        self.add(childVC: StandingsVC(yourTeamStandings: standings.response), to: self.standingsSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }

    
    func fetchDataForNextGamesSection() {
        NetworkManager.shared.getFixtures(parameters: "team=3491&season=2022&next=3&timezone=Europe/Warsaw") { result in
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: NextGamesVC(nextGames: fixtures.response), to: self.nextGamesSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataforSquadSection() {
        NetworkManager.shared.getSquads(parameters: "team=3491") { result in
            switch result {
                case .success(let squad):
                    DispatchQueue.main.async {
                        self.add(childVC: SquadVC(squad: squad.response), to: self.squadSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func layoutUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(lastGameSectionView)
        scrollView.addSubview(standingsSectionView)
        scrollView.addSubview(nextGamesSectionView)
        scrollView.addSubview(squadSectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        lastGameSectionView.translatesAutoresizingMaskIntoConstraints = false
        standingsSectionView.translatesAutoresizingMaskIntoConstraints = false
        nextGamesSectionView.translatesAutoresizingMaskIntoConstraints = false
        squadSectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            lastGameSectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            lastGameSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lastGameSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lastGameSectionView.heightAnchor.constraint(equalToConstant: 40+0.5+100),
            
            standingsSectionView.topAnchor.constraint(equalTo: lastGameSectionView.bottomAnchor, constant: 10),
            standingsSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            standingsSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            standingsSectionView.heightAnchor.constraint(equalToConstant: 40+0.5+80),
            
            nextGamesSectionView.topAnchor.constraint(equalTo: standingsSectionView.bottomAnchor, constant: 10),
            nextGamesSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nextGamesSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nextGamesSectionView.heightAnchor.constraint(equalToConstant: 40+0.5+3*80),
            
            squadSectionView.topAnchor.constraint(equalTo: nextGamesSectionView.bottomAnchor, constant: 10),
            squadSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            squadSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            squadSectionView.heightAnchor.constraint(equalToConstant: 40+0.5+210),
            squadSectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
    }
}

