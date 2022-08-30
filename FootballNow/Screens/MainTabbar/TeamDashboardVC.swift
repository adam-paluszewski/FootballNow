//
//  TeamDashboardVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class TeamDashboardVC: UIViewController {
    
    let scrollView = UIScrollView()
    let lastGameSectionView = UIView()
    let standingsSectionView = UIView()
    let nextGamesSectionView = UIView()
    let squadSectionView = UIView()
    
    var myTeam: [String]? // [0]id, [1]logo, [2]name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewController()
        createObservers()
        checkForMyTeam()
        fetchDataForLastGameSection()
        fetchDataForStandingsSection()
        fetchDataForNextGamesSection()
        fetchDataforSquadSection()
    }
    
    
    func configureViewController() {
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        scrollView.showsVerticalScrollIndicator = false
        layoutUI()
    }
    
    
    func configureNavigationBar() {
        setNavBarAppearance()
        setTitleForNavBar()
        setRightNavBarItem()
    }
    
    
    func setTitleForNavBar() {
        guard let myTeam = myTeam else { return }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: FNNavigationBarTitleView(image: myTeam[1], title: myTeam[2]))
    }
    
    
    func setRightNavBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FNSettingsIcon"), style: .plain, target: self, action: #selector(openSettings))
    }
    
    
    func setNavBarAppearance() { //move somewhere else later
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "FNNavBarColor")
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    
    @objc func openSettings() {
        let settingsVC = SettingsVC()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
 
    }
    
    
    func checkForMyTeam() {
        if myTeam == nil {
            let selectTeamVC = SelectTeamVC()
            let navController = UINavigationController(rootViewController: selectTeamVC)
            navController.isModalInPresentation = true
            navigationController?.present(navController, animated: true)
        }
    }
    
    
    func createObservers() {
        let team = Notification.Name(NotificationKeys.selectedTeam)
        NotificationCenter.default.addObserver(self, selector: #selector(fireObserver), name: team, object: nil)
    }
    
    
    @objc func fireObserver(notification: NSNotification) {
        myTeam = notification.object as? [String]
        removeChildren()
        setTitleForNavBar()
        fetchDataForLastGameSection()
        fetchDataForStandingsSection()
        fetchDataForNextGamesSection()
        fetchDataforSquadSection()
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
    
    
    func removeChildren() {
        for childVC in children {
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
    }
    
    
    func fetchDataForLastGameSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getFixtures(parameters: "team=\(myTeam[0])&season=2022&last=10&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: LastGameSectionVC(lastGame: fixtures.response), to: self.lastGameSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataForStandingsSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getStandings(parameters: "season=2022&team=\(myTeam[0])") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    DispatchQueue.main.async {
                        self.add(childVC: StandingsSectionVC(yourTeamStandings: standings.response), to: self.standingsSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }

    
    func fetchDataForNextGamesSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getFixtures(parameters: "team=\(myTeam[0])&season=2022&next=15&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: NextGamesSectionVC(nextGames: fixtures.response), to: self.nextGamesSectionView)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataforSquadSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getSquads(parameters: "team=\(myTeam[0])") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let squad):
                    DispatchQueue.main.async {
                        self.add(childVC: SquadSectionVC(squad: squad.response), to: self.squadSectionView)
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
            
            lastGameSectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            lastGameSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lastGameSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lastGameSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardLastGameHeight),
            
            standingsSectionView.topAnchor.constraint(equalTo: lastGameSectionView.bottomAnchor, constant: 15),
            standingsSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            standingsSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            standingsSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardStandingsHeight),
            
            nextGamesSectionView.topAnchor.constraint(equalTo: standingsSectionView.bottomAnchor, constant: 15),
            nextGamesSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nextGamesSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nextGamesSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardNextGamesHeight),
            
            squadSectionView.topAnchor.constraint(equalTo: nextGamesSectionView.bottomAnchor, constant: 15),
            squadSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            squadSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            squadSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardSquadHeight),
            squadSectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
    }
}
