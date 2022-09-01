//
//  GameStatisticsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class GameStatisticsVC: UIViewController {
    
    var statistics: [Statistics] = []
    
    let testView = UIView()
    
    init(statistics: [Statistics]?) {
        super.init(nibName: nil, bundle: nil)
        if let statistics = statistics {
            self.statistics = statistics
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()

        view.backgroundColor = .yellow

    }
    

    func configureViewController() {
        view.addSubview(testView)
        
        testView.translatesAutoresizingMaskIntoConstraints = false
    }

}
