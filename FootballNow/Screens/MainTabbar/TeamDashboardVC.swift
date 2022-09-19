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
    
    var team: TeamsData?
    var isTeamInFavorites = false
    
    
    init(isMyTeamShowing: Bool = false, team: TeamsData?) {
        super.init(nibName: nil, bundle: nil)
        self.team = team
        guard let myTeam = team else { return }
        
        if isMyTeamShowing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: FNNavigationItemView())
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.settings, style: .plain, target: self, action: #selector(openSettings))
        } else {
            navigationItem.titleView = FNTeamTitleView(image: myTeam.team.logo, title: myTeam.team.name)
            navigationItem.leftBarButtonItem = nil
            
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
        checkIfUserHaveMyTeam()
        addChildrenViewControllers()
    }
    
    
    func configureViewController() {
        view.backgroundColor = FNColors.backgroundColor
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
        add(childVC: LastGameSectionVC(teamId: team?.team.id), to: lastGameSectionView)
        add(childVC: StandingsSectionVC(teamId: team?.team.id), to: standingsSectionView)
        add(childVC: NextGamesSectionVC(teamId: team?.team.id), to: nextGamesSectionView)
        add(childVC: SquadSectionVC(teamId: team?.team.id), to: squadSectionView)
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
            let index = Favorites.shared.favoritesTeams.firstIndex(where: {$0.team.name == team?.team.name})!
            Favorites.shared.favoritesTeams.remove(at: index)
            Favorites.shared.setFavoritesTeams("favoritesTeams", object: Favorites.shared.favoritesTeams)
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            Favorites.shared.favoritesTeams.append(team!)
            Favorites.shared.setFavoritesTeams("favoritesTeams", object: Favorites.shared.favoritesTeams)
        }
        isTeamInFavorites.toggle()
    }
    
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if container as? NextGamesSectionVC != nil {
            nextGamesSectionView.isHidden = true
        } else if container as? LastGameSectionVC != nil {
            lastGameSectionView.isHidden = true
        } else if container as? StandingsSectionVC != nil {
            standingsSectionView.isHidden = true
        } else if container as? SquadSectionVC != nil {
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
