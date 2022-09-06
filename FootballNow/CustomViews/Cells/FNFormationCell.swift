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
    let homeImageView = UIImageView()
    
    let awayNumberLabel = FNBodyLabel(allingment: .center)
    let awayNameLabel = FNBodyLabel(allingment: .right)
    let awayImageView = UIImageView()
    
    
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
        homeImageView.isHidden = false
        awayImageView.isHidden = false
        homeImageView.image = UIImage(named: "FNGamefield")
        awayImageView.image = UIImage(named: "FNGamefield")
    }
    
    
    func setCoach(homeCoach: Coach?, awayCoach: Coach?) {
        homeNameLabel.text = homeCoach?.name ?? "Brak informacji"
        awayNameLabel.text = awayCoach?.name ?? "Brak informacji"
        
        homeImageView.isHidden = false
        NetworkManager.shared.downloadImage(from: homeCoach?.photo ?? "", completionHandler: { [weak self] image in
            DispatchQueue.main.async {
                self?.homeImageView.image = image
            }
        })
        
        awayImageView.isHidden = false
        NetworkManager.shared.downloadImage(from: awayCoach?.photo ?? "", completionHandler: { [weak self] image in
            DispatchQueue.main.async {
                self?.awayImageView.image = image
            }
        })
        
        homeImageView.layer.cornerRadius = 15
        awayImageView.layer.cornerRadius = 15
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
        backgroundColor = FNColors.sectionColor
        homeNumberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        awayNumberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        homeImageView.clipsToBounds = true
        awayImageView.clipsToBounds = true
        
        homeImageView.isHidden = true
        awayImageView.isHidden = true
    }
    
    
    func addSubviews() {
        addSubview(homeNumberLabel)
        addSubview(homeNameLabel)
        addSubview(awayNumberLabel)
        addSubview(awayNameLabel)
        addSubview(homeImageView)
        addSubview(awayImageView)
    }
    
    
    func addConstraints() {
        homeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        homeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        awayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        awayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        awayImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            homeNumberLabel.widthAnchor.constraint(equalToConstant: 25),
            
            homeNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeNameLabel.leadingAnchor.constraint(equalTo: homeNumberLabel.trailingAnchor, constant: 15),
            
            awayNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            awayNumberLabel.widthAnchor.constraint(equalToConstant: 25),
            
            awayNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayNameLabel.trailingAnchor.constraint(equalTo: awayNumberLabel.leadingAnchor, constant: -15),
            
            homeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            homeImageView.widthAnchor.constraint(equalToConstant: 30),
            homeImageView.heightAnchor.constraint(equalToConstant: 30),
            
            awayImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            awayImageView.widthAnchor.constraint(equalToConstant: 30),
            awayImageView.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}
