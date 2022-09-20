//
//  TeamDashboardVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class TeamDashboardVC: UIViewController {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let lastGameSectionView = FNSectionView(title: "Ostatni mecz")
    let standingsSectionView = FNSectionView(title: "Tabela ligowa")
    let nextGamesSectionView = FNSectionView(title: "Kolejne mecze")
    let squadSectionView = FNSectionView(title: "Zawodnicy")
    
    var addToFavoritesButton = UIBarButtonItem()
    
    var isMyTeamShowing: Bool!
    var team: TeamsResponse?
    var isTeamInFavorites = false
    
    
    init(isMyTeamShowing: Bool = false, team: TeamsResponse?) {
        super.init(nibName: nil, bundle: nil)
        self.team = team
        self.isMyTeamShowing = isMyTeamShowing
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        checkIfUserHaveMyTeam()
        addChildrenViewControllers()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isMyTeamShowing {
            PersistenceManager.shared.checkIfTeamIsInFavorites(teamId: team?.team.id) { isInFavorites in
                switch isInFavorites {
                    case true:
                        addToFavoritesButton.image = UIImage(systemName: "heart.fill")!
                        isTeamInFavorites = true
                    case false:
                        addToFavoritesButton.image = UIImage(systemName: "heart")!
                        isTeamInFavorites = false
                }
            }
        }
    }
    
    
    func configureViewController() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = FNColors.backgroundColor
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        addToFavoritesButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(addToFavorites))
        addToFavoritesButton.tintColor = .red
        navigationItem.rightBarButtonItem = addToFavoritesButton
        
        if isMyTeamShowing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: FNNavigationItemView())
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.settings, style: .plain, target: self, action: #selector(openSettings))
        } else {
            navigationItem.titleView = FNTeamTitleView(image: team!.team.logo, title: team!.team.name)
            navigationItem.leftBarButtonItem = nil
        }
        
        layoutUI()
    }
    
    
    func checkIfUserHaveMyTeam() {
        if team == nil {
            let selectTeamVC = SelectTeamVC()
            let navController = UINavigationController(rootViewController: selectTeamVC)
            navController.isModalInPresentation = true
            navController.modalTransitionStyle = .coverVertical
            navigationController?.present(navController, animated: true)
        }
    }
    
    
    func addChildrenViewControllers() {
        add(childVC: FNLastGameVC(teamId: team?.team.id), to: lastGameSectionView)
        add(childVC: FNStandingsVC(teamId: team?.team.id), to: standingsSectionView)
        add(childVC: FNNextGamesVC(teamId: team?.team.id), to: nextGamesSectionView)
        add(childVC: FNSquadVC(teamId: team?.team.id), to: squadSectionView)
    }
    
    
    @objc func handleRefreshControl() {
        remove(childrenVC: children)
        addChildrenViewControllers()
        scrollView.refreshControl?.endRefreshing()
    }

    
    @objc func openSettings() {
        let settingsVC = SettingsVC()
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.isModalInPresentation = true
        present(navController, animated: true)
    }
    
    
    @objc func addToFavorites() {
        if isTeamInFavorites {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            PersistenceManager.shared.updateWith(favorite: self.team!, actionType: .remove) { error in
                guard error != nil else { return }
                presentAlertOnMainThread(title: "Błąd", message: FNError.unableRemoveFromFavorites.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            PersistenceManager.shared.updateWith(favorite: self.team!, actionType: .add) { error in
                guard error != nil else { return }
                presentAlertOnMainThread(title: "Błąd", message: FNError.unableAddToFavorites.rawValue, buttonTitle: "OK", buttonColor: .systemRed, buttonSystemImage: SFSymbols.error)
            }
        }
        isTeamInFavorites.toggle()
    }
    
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if container as? FNNextGamesVC != nil {
            nextGamesSectionView.isHidden = true
        } else if container as? FNLastGameVC != nil {
            lastGameSectionView.isHidden = true
        } else if container as? FNStandingsVC != nil {
            standingsSectionView.isHidden = true
        } else if container as? FNSquadVC != nil {
            squadSectionView.isHidden = true
        }
    }
    
    
    func layoutUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(lastGameSectionView)
        stackView.addArrangedSubview(standingsSectionView)
        stackView.addArrangedSubview(nextGamesSectionView)
        stackView.addArrangedSubview(squadSectionView)
        
        scrollView.showsVerticalScrollIndicator = false
        stackView.axis = .vertical
        stackView.spacing = 15
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            lastGameSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardLastGameHeight),
            standingsSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardStandingsHeight),
            nextGamesSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardNextGamesHeight),
            squadSectionView.heightAnchor.constraint(equalToConstant: SectionHeight.teamDashboardSquadHeight),
        ])
    }
}
