//
//  TeamDashboardVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class TeamDashboardVC: UIViewController {
    
    let scrollView = UIScrollView()
    let lastGameSectionView = FNSectionView(title: "Ostatni mecz", buttonText: "Więcej")
    let standingsSectionView = FNSectionView(title: "Tabela ligowa", buttonText: "Więcej")
    let nextGamesSectionView = FNSectionView(title: "Kolejne mecze", buttonText: "Więcej")
    let squadSectionView = FNSectionView(title: "Skład drużyny", buttonText: "Więcej")
    let lastGameActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let standingsActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let nextGamesAactivityIndicatorView = UIActivityIndicatorView(style: .large)
    let squadActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var myTeam: TeamsData?
    var isTeamInFavorites = false
    
    
    init(isMyTeamShowing: Bool, team: TeamsData?) {
        super.init(nibName: nil, bundle: nil)
        self.myTeam = team
        guard let myTeam = myTeam else { return }
        
        if isMyTeamShowing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FNSettingsIcon"), style: .plain, target: self, action: #selector(openSettings))
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: FNNavigationBarTitleView(image: myTeam.team.logo, title: myTeam.team.name))
        } else {
            navigationItem.titleView = FNNavigationBarTitleView(image: myTeam.team.logo, title: myTeam.team.name)
            
            isTeamInFavorites = Favorites.shared.isTeamInFavorites(id: team!.team.id)
            var image = UIImage()
            
            if isTeamInFavorites {
                image = UIImage(systemName: "heart.fill")!
            } else {
                image = UIImage(systemName: "heart")!
            }
            
            let addToFavoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToFavorites))
            addToFavoritesButton.tintColor = .red
            navigationItem.rightBarButtonItem = addToFavoritesButton
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        createObservers()
        checkForMyTeam()
        fetchDataForLastGameSection()
        fetchDataForStandingsSection()
        fetchDataForNextGamesSection()
        fetchDataforSquadSection()
        
        print(myTeam)
    }
    
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        view.backgroundColor = UIColor(named: "FNBackgroundColor")
        scrollView.showsVerticalScrollIndicator = false
        layoutUI()
        
        let activityIndicators = [lastGameActivityIndicatorView, standingsActivityIndicatorView, nextGamesAactivityIndicatorView, squadActivityIndicatorView]
        for indicator in activityIndicators {
            indicator.backgroundColor = .systemBackground
            indicator.alpha = 0.6
            indicator.startAnimating()
        }

    }
    
    
    @objc func openSettings() {
        let settingsVC = SettingsVC()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
 
    }
    
    
    @objc func addToFavorites() {
        if isTeamInFavorites {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            let index = Favorites.shared.favoritesTeams.firstIndex(where: {$0.team.name == myTeam?.team.name})!
            Favorites.shared.favoritesTeams.remove(at: index)
            Favorites.shared.set("favoritesTeams", object: Favorites.shared.favoritesTeams)
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            Favorites.shared.favoritesTeams.append(myTeam!)
            Favorites.shared.set("favoritesTeams", object: Favorites.shared.favoritesTeams)
        }
        isTeamInFavorites.toggle()
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
        myTeam = notification.object as? TeamsData
        removeChildren()
        fetchDataForLastGameSection()
        fetchDataForStandingsSection()
        fetchDataForNextGamesSection()
        fetchDataforSquadSection()
    
        guard let myTeam = myTeam else { return }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: FNNavigationBarTitleView(image: myTeam.team.logo, title: myTeam.team.name))
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
        NetworkManager.shared.getFixtures(parameters: "team=\(myTeam.team.id)&season=2022&last=10&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: LastGameSectionVC(lastGame: fixtures.response), to: self.lastGameSectionView)
                        self.lastGameActivityIndicatorView.stopAnimating()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataForStandingsSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getStandings(parameters: "season=2022&team=\(myTeam.team.id)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let standings):
                    DispatchQueue.main.async {
                        self.add(childVC: StandingsSectionVC(yourTeamStandings: standings.response), to: self.standingsSectionView)
                        self.standingsActivityIndicatorView.stopAnimating()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }

    
    func fetchDataForNextGamesSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getFixtures(parameters: "team=\(myTeam.team.id)&season=2022&next=15&timezone=Europe/Warsaw") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: NextGamesSectionVC(nextGames: fixtures.response), to: self.nextGamesSectionView)
                        self.nextGamesAactivityIndicatorView.stopAnimating()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fetchDataforSquadSection() {
        guard let myTeam = myTeam else { return }
        NetworkManager.shared.getSquads(parameters: "team=\(myTeam.team.id)") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let squad):
                    DispatchQueue.main.async {
                        self.add(childVC: SquadSectionVC(squad: squad.response), to: self.squadSectionView)
                        self.squadActivityIndicatorView.stopAnimating()
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
        lastGameSectionView.addSubview(lastGameActivityIndicatorView)
        standingsSectionView.addSubview(standingsActivityIndicatorView)
        nextGamesSectionView.addSubview(nextGamesAactivityIndicatorView)
        squadSectionView.addSubview(squadActivityIndicatorView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        lastGameSectionView.translatesAutoresizingMaskIntoConstraints = false
        standingsSectionView.translatesAutoresizingMaskIntoConstraints = false
        nextGamesSectionView.translatesAutoresizingMaskIntoConstraints = false
        squadSectionView.translatesAutoresizingMaskIntoConstraints = false
        lastGameActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        standingsActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        nextGamesAactivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        squadActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            lastGameSectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            lastGameSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lastGameSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lastGameSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardLastGameHeight),
            
            lastGameActivityIndicatorView.topAnchor.constraint(equalTo: lastGameSectionView.bodyView.topAnchor),
            lastGameActivityIndicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lastGameActivityIndicatorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lastGameActivityIndicatorView.bottomAnchor.constraint(equalTo: lastGameSectionView.bottomAnchor),
            
            standingsSectionView.topAnchor.constraint(equalTo: lastGameSectionView.bottomAnchor, constant: 15),
            standingsSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            standingsSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            standingsSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardStandingsHeight),
            
            standingsActivityIndicatorView.topAnchor.constraint(equalTo: standingsSectionView.bodyView.topAnchor),
            standingsActivityIndicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            standingsActivityIndicatorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            standingsActivityIndicatorView.bottomAnchor.constraint(equalTo: standingsSectionView.bottomAnchor),
            
            nextGamesSectionView.topAnchor.constraint(equalTo: standingsSectionView.bottomAnchor, constant: 15),
            nextGamesSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nextGamesSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nextGamesSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardNextGamesHeight),
            
            nextGamesAactivityIndicatorView.topAnchor.constraint(equalTo: nextGamesSectionView.bodyView.topAnchor),
            nextGamesAactivityIndicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nextGamesAactivityIndicatorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nextGamesAactivityIndicatorView.bottomAnchor.constraint(equalTo: nextGamesSectionView.bottomAnchor),
            
            squadSectionView.topAnchor.constraint(equalTo: nextGamesSectionView.bottomAnchor, constant: 15),
            squadSectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            squadSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            squadSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardSquadHeight),
            squadSectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            
            squadActivityIndicatorView.topAnchor.constraint(equalTo: squadSectionView.bodyView.topAnchor),
            squadActivityIndicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            squadActivityIndicatorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            squadActivityIndicatorView.bottomAnchor.constraint(equalTo: squadSectionView.bottomAnchor),
        ])
    }
}
