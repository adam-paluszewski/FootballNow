//
//  ViewController.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let lastGameSection = UIView()
    let standingsSection = UIView()
    let nextGamesSection = UIView()
    let squadSection = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearanceOfNavigationBar()
        layoutUI()
        fillSectionsWithChildViewControllers()
        
        NetworkManager.shared.getFixtures(parameters: "team=3491&season=2022&last=1&timezone=Europe/Warsaw") { result in
            switch result {
                case .success(let fixtures):
                    DispatchQueue.main.async {
                        self.add(childVC: LastGameVC(lastGame: fixtures.response), to: self.lastGameSection)
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func fillSectionsWithChildViewControllers() {
        add(childVC: StandingsVC(), to: standingsSection)
        add(childVC: NextGamesVC(), to: nextGamesSection)
        add(childVC: SquadVC(), to: squadSection)
    }
    
    
    func configureAppearanceOfNavigationBar() {
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
    
    
    func layoutUI() {
        view.backgroundColor = .systemBackground  //UIColor(red: 225/255, green: 242/255, blue: 251/255, alpha: 1)
        
        view.addSubview(scrollView)
        scrollView.addSubview(lastGameSection)
        scrollView.addSubview(standingsSection)
        scrollView.addSubview(nextGamesSection)
        scrollView.addSubview(squadSection)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        lastGameSection.translatesAutoresizingMaskIntoConstraints = false
        standingsSection.translatesAutoresizingMaskIntoConstraints = false
        nextGamesSection.translatesAutoresizingMaskIntoConstraints = false
        squadSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            lastGameSection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            lastGameSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lastGameSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lastGameSection.heightAnchor.constraint(equalToConstant: 40+0.5+80),
            
            standingsSection.topAnchor.constraint(equalTo: lastGameSection.bottomAnchor, constant: 10),
            standingsSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            standingsSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            standingsSection.heightAnchor.constraint(equalToConstant: 100),
            
            nextGamesSection.topAnchor.constraint(equalTo: standingsSection.bottomAnchor, constant: 10),
            nextGamesSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nextGamesSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nextGamesSection.heightAnchor.constraint(equalToConstant: 300),
            
            squadSection.topAnchor.constraint(equalTo: nextGamesSection.bottomAnchor, constant: 10),
            squadSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            squadSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            squadSection.heightAnchor.constraint(equalToConstant: 200),
            squadSection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
    }
}

