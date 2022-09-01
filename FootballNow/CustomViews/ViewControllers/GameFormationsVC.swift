//
//  GameFormationsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameFormationsVC: UIViewController {
    
    var squad: [Lineups] = []
    
    
    init(squad: [Lineups]?) {
        super.init(nibName: nil, bundle: nil)
        if let squad = squad {
            self.squad = squad
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
    


}
