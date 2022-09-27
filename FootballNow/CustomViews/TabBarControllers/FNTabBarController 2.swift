//
//  FNTabBarController.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 18/09/2022.
//

import UIKit

class FNTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(named: "FNNavigationTint")
        viewControllers = [createTeamDashboardNC(), createGamesNC(), createFavoritesNC(), createSearchNC()]
            
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "FNNavBarColor")
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
    }
    
    
    func createTeamDashboardNC() -> UINavigationController {
        var team: TeamsData?
        
        PersistenceManager.shared.retrieveMyTeam { result in
            switch result {
                case .success(let myTeam):
                    team = myTeam
                case .failure(let error):
                    print("eror")
            }
        }
        
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: true, team: team)
        teamDashboardVC.tabBarItem = UITabBarItem(title: "Moja drużyna", image: UIImage(systemName: "person.2"),selectedImage: UIImage(systemName: "person.2.fill"))
        teamDashboardVC.tabBarItem.tag = 0
        
        return UINavigationController(rootViewController: teamDashboardVC)
    }
    
    
    func createGamesNC() -> UINavigationController {
        let gamesVC = GamesVC()
        gamesVC.tabBarItem = UITabBarItem(title: "Rozgrywki", image: UIImage(systemName: "sportscourt"),selectedImage: UIImage(systemName: "sportscourt.fill"))
        gamesVC.tabBarItem.tag = 1
        
        return UINavigationController(rootViewController: gamesVC)
    }
    
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Ulubione kluby"
        favoritesVC.tabBarItem = UITabBarItem(title: "Ulubione", image: UIImage(systemName: "heart"),selectedImage: UIImage(systemName: "heart.fill"))
        favoritesVC.tabBarItem.tag = 2
        
        return UINavigationController(rootViewController: favoritesVC)
    }
    
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Szukaj klubu"
        searchVC.tabBarItem = UITabBarItem(title: "Odkrywaj", image: UIImage(systemName: "magnifyingglass"),selectedImage: UIImage(systemName: "magnifyingglass"))
        searchVC.tabBarItem.tag = 3
        
        return UINavigationController(rootViewController: searchVC)
    }
}
