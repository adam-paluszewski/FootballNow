//
//  StandingsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class StandingsVC: UIViewController {

    let section = FNSectionView(title: "Tabela ligowa", buttonText: "Więcej")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 225/255, green: 242/255, blue: 251/255, alpha: 1)
        configure()
        
        section.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    
    
    
    
    func configure() {
        view.addSubview(section)

        NSLayoutConstraint.activate([
            section.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            section.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            section.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            section.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    
    @objc func buttonPressed() {
        print("standings")
    }

}
