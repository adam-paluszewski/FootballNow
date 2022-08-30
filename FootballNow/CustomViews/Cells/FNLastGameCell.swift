//
//  FNLastGameCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class FNLastGameCell: UITableViewCell {

    static let cellId = "LastGamesCell"
    
    let gameDateLabel = FNBodyLabel(allingment: .center)
    let homeTeamNameLabel = FNBodyLabel(allingment: .left)
    let homeTeamLogoImageView = UIImageView()
    let awayTeamNameLabel = FNBodyLabel(allingment: .left)
    let awayTeamLogoImageView = UIImageView()
    let homeTeamScoreLabel = FNBodyLabel(allingment: .center)
    let awayTeamScoreLabel = FNBodyLabel(allingment: .center)
    let vLineView = UIView()
    let leagueLogoImageView = UIImageView()
    let leagueBackgroundView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(lastGame: FixturesData) {
        homeTeamNameLabel.text = lastGame.teams.home.name
        awayTeamNameLabel.text = lastGame.teams.away.name
        
        if let homeTeamGoals = lastGame.goals.home {
            homeTeamScoreLabel.text = String(homeTeamGoals)
        }
        
        if let awayTeamGoals = lastGame.goals.away {
            awayTeamScoreLabel.text = String(awayTeamGoals)
        }
        
        let dateString = FNDateFormatting.getDMMM(timestamp: lastGame.fixture.timestamp)
        gameDateLabel.text = dateString + " Zakończony"
        
        NetworkManager.shared.downloadImage(from: lastGame.teams.home.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.homeTeamLogoImageView.image = image
            }
        }
        
        NetworkManager.shared.downloadImage(from: lastGame.teams.away.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.awayTeamLogoImageView.image = image
            }
        }
        
        NetworkManager.shared.downloadImage(from: lastGame.league.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.leagueLogoImageView.image = image
            }
        }
    }
    
    
    func configure() {
        backgroundColor = .clear
        vLineView.backgroundColor = .lightGray
        gameDateLabel.textColor = .secondaryLabel
        gameDateLabel.numberOfLines = 2
        leagueBackgroundView.backgroundColor = .systemGray2
        leagueBackgroundView.clipsToBounds = true
        leagueBackgroundView.layer.cornerRadius = 22.5
    }
    
    
    func addSubviews() {
        addSubview(leagueBackgroundView)
        addSubview(leagueLogoImageView)
        addSubview(homeTeamNameLabel)
        addSubview(homeTeamLogoImageView)
        addSubview(awayTeamNameLabel)
        addSubview(awayTeamLogoImageView)
        addSubview(homeTeamScoreLabel)
        addSubview(awayTeamScoreLabel)
        addSubview(vLineView)
        addSubview(gameDateLabel)
    }
    
    
    func addConstraints() {
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        leagueLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        leagueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leagueBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leagueBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            leagueBackgroundView.widthAnchor.constraint(equalToConstant: 45),
            leagueBackgroundView.heightAnchor.constraint(equalToConstant: 45),
            
            leagueLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leagueLogoImageView.centerXAnchor.constraint(equalTo: leagueBackgroundView.centerXAnchor),
            leagueLogoImageView.widthAnchor.constraint(equalToConstant: 30),
            leagueLogoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            homeTeamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            homeTeamLogoImageView.leadingAnchor.constraint(equalTo: leagueLogoImageView.trailingAnchor, constant: 20),
            homeTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            homeTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            homeTeamNameLabel.centerYAnchor.constraint(equalTo: homeTeamLogoImageView.centerYAnchor),
            homeTeamNameLabel.leadingAnchor.constraint(equalTo: homeTeamLogoImageView.trailingAnchor, constant: 5),
            
            awayTeamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            awayTeamLogoImageView.leadingAnchor.constraint(equalTo: leagueLogoImageView.trailingAnchor, constant: 20),
            awayTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            awayTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            awayTeamNameLabel.centerYAnchor.constraint(equalTo: awayTeamLogoImageView.centerYAnchor),
            awayTeamNameLabel.leadingAnchor.constraint(equalTo: awayTeamLogoImageView.trailingAnchor, constant: 5),
            
            vLineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            vLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100),
            vLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            vLineView.widthAnchor.constraint(equalToConstant: 0.5),
            
            homeTeamScoreLabel.firstBaselineAnchor.constraint(equalTo: homeTeamNameLabel.firstBaselineAnchor),
            homeTeamScoreLabel.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor, constant: -10),
            homeTeamScoreLabel.widthAnchor.constraint(equalToConstant: 20),
            
            awayTeamScoreLabel.firstBaselineAnchor.constraint(equalTo: awayTeamNameLabel.firstBaselineAnchor),
            awayTeamScoreLabel.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor, constant: -10),
            awayTeamScoreLabel.widthAnchor.constraint(equalToConstant: 20),
            
            gameDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gameDateLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 10),
            gameDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
