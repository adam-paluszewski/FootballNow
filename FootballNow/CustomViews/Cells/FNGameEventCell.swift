//
//  FNGameEventCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class FNGameEventCell: UITableViewCell {
    
    static let cellId = "GameEventCell"

    let homeEventTimeLabel = FNBodyLabel(allingment: .left)
    let homeEventImageView = UIImageView()
    let homeStackView = UIStackView()
    let homeEventPlayerLabel = FNDefaultLabel(allingment: .left)
    let homeExtraInfoLabel = FNDefaultLabel(allingment: .left)
    
    let awayEventTimeLabel = FNBodyLabel(allingment: .right)
    let awayEventImageView = UIImageView()
    let awayStackView = UIStackView()
    let awayEventPlayerLabel = FNDefaultLabel(allingment: .right)
    let awayExtraInfoLabel = FNDefaultLabel(allingment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        self.backgroundColor = FNColors.sectionColor
        homeStackView.axis = .vertical
        awayStackView.axis = .vertical
        homeStackView.distribution = .fillProportionally
        awayStackView.distribution = .fillProportionally
        
        homeEventPlayerLabel.font = .systemFont(ofSize: 14)
        homeExtraInfoLabel.font = .systemFont(ofSize: 11, weight: .light)
        awayEventPlayerLabel.font = .systemFont(ofSize: 14)
        awayExtraInfoLabel.font = .systemFont(ofSize: 11, weight: .light)
        
        homeEventTimeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        awayEventTimeLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    
    func addSubviews() {
        addSubview(homeEventTimeLabel)
        addSubview(homeEventImageView)
        addSubview(homeStackView)
        homeStackView.addArrangedSubview(homeEventPlayerLabel)
        homeStackView.addArrangedSubview(homeExtraInfoLabel)
        addSubview(awayEventTimeLabel)
        addSubview(awayEventImageView)
        addSubview(awayStackView)
        awayStackView.addArrangedSubview(awayEventPlayerLabel)
        awayStackView.addArrangedSubview(awayExtraInfoLabel)
    }
    
    
    func addConstraints() {
        homeEventImageView.translatesAutoresizingMaskIntoConstraints = false
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        awayEventImageView.translatesAutoresizingMaskIntoConstraints = false
        awayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeEventTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeEventTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            homeEventTimeLabel.widthAnchor.constraint(equalToConstant: 35),
            
            homeEventImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeEventImageView.leadingAnchor.constraint(equalTo: homeEventTimeLabel.trailingAnchor, constant: 10),
            homeEventImageView.widthAnchor.constraint(equalToConstant: 25),
            homeEventImageView.heightAnchor.constraint(equalToConstant: 25),

            homeStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeStackView.leadingAnchor.constraint(equalTo: homeEventImageView.trailingAnchor, constant: 15),
            homeStackView.heightAnchor.constraint(equalToConstant: 40),
            
            awayEventTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayEventTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            awayEventTimeLabel.widthAnchor.constraint(equalToConstant: 35),
            
            awayEventImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayEventImageView.trailingAnchor.constraint(equalTo: awayEventTimeLabel.leadingAnchor, constant: -10),
            awayEventImageView.widthAnchor.constraint(equalToConstant: 25),
            awayEventImageView.heightAnchor.constraint(equalToConstant: 25),

            awayStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayStackView.trailingAnchor.constraint(equalTo: awayEventImageView.leadingAnchor, constant: -15),
            awayStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func set(game: FixturesData, indexPath: Int) {
        let events = game.events
        let eventsReversed = Array(events!.reversed())
        
        let homeTeam = game.teams.home.id
        let awayTeam = game.teams.away.id
        let event = eventsReversed[indexPath]
        
        if event.team.id == homeTeam {
            awayEventTimeLabel.isHidden = true
            awayEventImageView.isHidden = true
            awayEventPlayerLabel.isHidden = true
            awayExtraInfoLabel.isHidden = true
            
            if let timeElapsed = event.time.elapsed {
                homeEventTimeLabel.text = "\(timeElapsed)'"
            }
            
            homeEventPlayerLabel.text = event.player.name
            
            if event.assist.name != nil {
                if event.type == "subst" {
                    homeEventPlayerLabel.text = event.assist.name
                    
                    if let eventPlayerName = event.player.name {
                        homeExtraInfoLabel.text = "za \(eventPlayerName)"
                    }
                    
                } else if event.type == "Goal" {
                    homeEventPlayerLabel.text = event.player.name
                    homeExtraInfoLabel.text = "asysta \(event.assist.name ?? "")"
                }
            } else {
                homeExtraInfoLabel.isHidden = true
            }
            
            switch event.type {
                case "Goal":
                    if event.detail == "Penalty"{
                        homeEventImageView.image = UIImage(named: "FNPenaltyGoal")
                    } else {
                        homeEventImageView.image = UIImage(named: "FNGoal")
                    }
                case "subst":
                    homeEventImageView.image = UIImage(named: "FNSubstitution")
                case "Card":
                    if event.detail == "Yellow Card"{
                        homeEventImageView.image = UIImage(named: "FNYellowCard")
                    } else {
                        homeEventImageView.image = UIImage(named: "FNRedCard")
                    }
                default:
                    print("Incorrect api answer")
            }
            
        } else if event.team.id == awayTeam {
            homeEventTimeLabel.isHidden = true
            homeEventImageView.isHidden = true
            homeEventPlayerLabel.isHidden = true
            homeExtraInfoLabel.isHidden = true
            
            
            if let timeElapsed = event.time.elapsed {
                awayEventTimeLabel.text = "\(timeElapsed)'"
            }
            //            cell.awayEventImage =
            awayEventPlayerLabel.text = event.player.name
            
            
            
            //assist is used for substitute event
            if event.assist.name != nil {
                if event.type == "subst" {
                    awayEventPlayerLabel.text = event.assist.name
                    
                    if let eventPlayerName = event.player.name {
                        awayExtraInfoLabel.text = "za \(eventPlayerName)"
                    }
                    
                } else if event.type == "Goal" {
                    awayEventPlayerLabel.text = event.player.name
                    awayExtraInfoLabel.text = "asysta \(event.assist.name ?? "")"
                }
                
            } else {
                awayExtraInfoLabel.isHidden = true
            }
            
            switch event.type {
                case "Goal":
                    if event.detail == "Penalty"{
                        awayEventImageView.image = UIImage(named: "FNPenaltyGoal")
                    } else {
                        awayEventImageView.image = UIImage(named: "FNGoal")
                    }
                case "subst":
                    awayEventImageView.image = UIImage(named: "FNSubstitution")
                case "Card":
                    if event.detail == "Yellow Card"{
                        awayEventImageView.image = UIImage(named: "FNYellowCard")
                    } else {
                        awayEventImageView.image = UIImage(named: "FNRedCard")
                    }
                default:
                    print("Incorrect api answer")
            }
            
        }
    }
}
