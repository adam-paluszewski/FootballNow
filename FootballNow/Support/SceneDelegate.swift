//
//  SceneDelegate.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        window?.rootViewController = createTabbar()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        configureUserIntefaceStyle()
    }
    
    
    func createTabbar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createTeamDashboardNC(), createGamesNC(), createFavoritesNC(), createSearchNC()]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "FNNavBarColor")
        tabBar.tabBar.standardAppearance = tabBarAppearance
        tabBar.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        return tabBar
    }
    
    
    func createTeamDashboardNC() -> UINavigationController {
        var team: [String] = []
        
        if let data = UserDefaults.standard.value(forKey: "myTeam") as? Data {
            let decoder = JSONDecoder()
            if let myTeam = try? decoder.decode([String].self, from: data) {
                team = myTeam
            }
        }
        
        let teamDashboardVC = TeamDashboardVC(isMyTeamShowing: true, team: team)
        teamDashboardVC.tabBarItem = UITabBarItem(title: "Moja drużyna", image: UIImage(systemName: "person.3"),selectedImage: UIImage(systemName: "person.3.fill"))
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
        favoritesVC.tabBarItem = UITabBarItem(title: "Ulubione", image: UIImage(systemName: "heart"),selectedImage: UIImage(systemName: "heart.fill"))
        favoritesVC.tabBarItem.tag = 2
        
        return UINavigationController(rootViewController: favoritesVC)
    }
    
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Odkrywaj", image: UIImage(systemName: "magnifyingglass"),selectedImage: UIImage(systemName: "magnifyingglass"))
        searchVC.tabBarItem.tag = 3
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func configureUserIntefaceStyle() {
        if UserDefaults.standard.value(forKey: "isUserIntefaceLight") != nil {
            let isUserIntefaceLight = UserDefaults.standard.value(forKey: "isUserIntefaceLight") as! Bool
            window!.overrideUserInterfaceStyle = isUserIntefaceLight ? .light : .dark
        }
    }
    
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemBlue
    }
    
    
    

    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}



