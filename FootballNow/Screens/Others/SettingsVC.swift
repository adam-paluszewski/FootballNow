//
//  SettingsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 28/08/2022.
//

import UIKit


class SettingsVC: UIViewController {
    
    let segmentedControlSectionView = FNSectionView(title: "Motyw aplikacji")
    let optionsSectionView = FNSectionView(title: "Pozostałe ustawienia")
    let versionLabel = FNBodyLabel(allingment: .center)
    let segmentedControl = UISegmentedControl(items: ["Jasny", "Ciemny", "Jak system"])
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSegmentedControl()
        configureTableView()
        configureVersionLabel()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }


    @objc func segmentedControlValueChanged() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
            
            switch segmentedControl.selectedSegmentIndex {
                case 0:
                    UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            window.overrideUserInterfaceStyle = .light //.light or .unspecified
                        }, completion: nil)
                    UserDefaults.standard.set(true, forKey: "isUserIntefaceLight")
                case 1:
                    UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            window.overrideUserInterfaceStyle = .dark //.light or .unspecified
                        }, completion: nil)
                    UserDefaults.standard.set(false, forKey: "isUserIntefaceLight")
                case 2:
                    UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            window.overrideUserInterfaceStyle = .unspecified //.light or .unspecified
                        }, completion: nil)
                    UserDefaults.standard.set(nil, forKey: "isUserIntefaceLight")
                default:
                    print("dddd")
            }
    }
    
    
    func checkUserInterfaceStyle() {
        if UserDefaults.standard.value(forKey: "isUserIntefaceLight") != nil {
            let isUserIntefaceLight = UserDefaults.standard.value(forKey: "isUserIntefaceLight") as! Bool
            segmentedControl.selectedSegmentIndex = isUserIntefaceLight ? 0 : 1
        } else {
            segmentedControl.selectedSegmentIndex = 2
        }
    }
    
    func configureViewController() {
        navigationItem.title = "Ustawienia"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "FNNavBarColor")
        view.backgroundColor = FNColors.backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gotowe", style: .plain, target: self, action: #selector(dismissVC))
        
        view.addSubview(segmentedControlSectionView)
        view.addSubview(optionsSectionView)
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            segmentedControlSectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentedControlSectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControlSectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            segmentedControlSectionView.heightAnchor.constraint(equalToConstant: 110),

            optionsSectionView.topAnchor.constraint(equalTo: segmentedControlSectionView.bottomAnchor, constant: 15),
            optionsSectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            optionsSectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            optionsSectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            versionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func configureSegmentedControl() {
        checkUserInterfaceStyle()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        segmentedControlSectionView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlSectionView.bodyView.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlSectionView.bodyView.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlSectionView.bodyView.trailingAnchor, constant: -15),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlSectionView.bodyView.bottomAnchor, constant: -10),
        ])
    }
    
    
    func configureTableView() {
        tableView.register(FNSettingsCell.self, forCellReuseIdentifier: FNSettingsCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
        
        optionsSectionView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: optionsSectionView.bodyView.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: optionsSectionView.bodyView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: optionsSectionView.bodyView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: optionsSectionView.bodyView.bottomAnchor),
        ])
    }
    
    
    func configureVersionLabel() {
        versionLabel.numberOfLines = 2
        versionLabel.text = """
                                v.1.0
                                © Adam Paluszewski
                            """
    }
}


extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FNSettingsCell.cellId, for: indexPath) as! FNSettingsCell
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "Wybierz ponownie swoją drużynę"
        }
        else {
            cell.textLabel!.text = "Wesprzyj projekt"
        }
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let selectTeamVC = SelectTeamVC()
            selectTeamVC.isCancelable = true
            navigationController?.pushViewController(selectTeamVC, animated: true)
        }
    }
}
