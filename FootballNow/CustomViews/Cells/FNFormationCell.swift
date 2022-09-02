//
//  FNFormationCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 02/09/2022.
//

import UIKit

class FNFormationCell: UITableViewCell {
    
    static let cellId = "FormationCell"

    let homeNumberLabel = FNBodyLabel(allingment: .center)
    let homeNameLabel = FNBodyLabel(allingment: .left)
    
    let awayNumberLabel = FNBodyLabel(allingment: .center)
    let awayNameLabel = FNBodyLabel(allingment: .right)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setFormation(homeFormation: Lineups?, awayFormation: Lineups?) {
        homeNameLabel.text = homeFormation?.formation
        awayNameLabel.text = awayFormation?.formation
    }
    
    
    func setCoach(homeCoach: Coach?, awayCoach: Coach?) {
        homeNameLabel.text = homeCoach?.name
        awayNameLabel.text = awayCoach?.name
    }
    
    
    func setStartingXI(homeSquad: StartXI?, awaySquad: StartXI?) {
        if let playerNumber = homeSquad?.player?.number {
            homeNumberLabel.text = String(playerNumber)
        }
        
        homeNameLabel.text = homeSquad?.player?.name
        
        if let playerNumber = awaySquad?.player?.number {
            awayNumberLabel.text = String(playerNumber)
        }
        
        awayNameLabel.text = awaySquad?.player?.name
    }
    
    
    func setSubstitutes(homeSquad: Substitutes?, awaySquad: Substitutes?) {
        if let playerNumber = homeSquad?.player?.number {
            homeNumberLabel.text = String(playerNumber)
        }
        
        homeNameLabel.text = homeSquad?.player?.name
        
        if let playerNumber = awaySquad?.player?.number {
            awayNumberLabel.text = String(playerNumber)
        }
        
        awayNameLabel.text = awaySquad?.player?.name
    }
    
    
    func configure() {
        backgroundColor = UIColor(named: "FNSectionColor")
    }
    
    
    func addSubviews() {
        addSubview(homeNumberLabel)
        addSubview(homeNameLabel)
        addSubview(awayNumberLabel)
        addSubview(awayNameLabel)
    }
    
    
    func addConstraints() {
        homeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        homeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        awayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        awayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            homeNumberLabel.widthAnchor.constraint(equalToConstant: 20),
            
            homeNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeNameLabel.leadingAnchor.constraint(equalTo: homeNumberLabel.trailingAnchor, constant: 10),
            
            awayNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            awayNumberLabel.widthAnchor.constraint(equalToConstant: 20),
            
            awayNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayNameLabel.trailingAnchor.constraint(equalTo: awayNumberLabel.leadingAnchor, constant: -10),
        ])
    }
}
