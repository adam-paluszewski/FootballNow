//
//  FNGameStatisticsCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class FNGameStatisticsCell: UITableViewCell {
    
    static let cellId = "StatisticsCell"
    
    let homeStatisticLabel = FNBodyLabel(allingment: .center)
    let awayStatisticLabel = FNBodyLabel(allingment: .center)
    let statisticInfoLabel = FNBodyLabel(allingment: .center)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(homeStats: FixtureStatistics?, awayStats: FixtureStatistics?) {
        statisticInfoLabel.text = FNTranslateToPolish.shared.translateGameStatistics(from: homeStats?.type)
        
        if let homeValue = homeStats?.value {
            switch homeValue {
                case .int(let number):
                    homeStatisticLabel.text = String(number)
                case .string(let word):
                    homeStatisticLabel.text = word
            }
        } else {
            homeStatisticLabel.text = String(0)
        }
        
        if let awayValue = awayStats?.value {
            switch awayValue {
                case .int(let number):
                    awayStatisticLabel.text = String(number)
                case .string(let word):
                    awayStatisticLabel.text = word
            }
        } else {
            awayStatisticLabel.text = String(0)
        }
    }
    
    
    func configure() {
        self.backgroundColor = UIColor(named: "FNSectionColor")
    }
    
    
    func addSubviews() {
        addSubview(homeStatisticLabel)
        addSubview(awayStatisticLabel)
        addSubview(statisticInfoLabel)
    }
    
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            homeStatisticLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeStatisticLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            
            statisticInfoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statisticInfoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            awayStatisticLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayStatisticLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
        ])
    }
}
