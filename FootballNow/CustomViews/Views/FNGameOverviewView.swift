//
//  FNGameOverviewView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/08/2022.
//

import UIKit

class FNGameOverviewView: UIView {

    let homeTeamView = UIView()
    let awayTeamView = UIView()
    let scoreView = UIView()
    let homeTeamLogoImageView = UIImageView(image: UIImage(named: "empty.jpg"))
    let homeTeamNameLabel = FNBodyLabel(allingment: .center)
    let awayTeamLogoImageView = UIImageView(image: UIImage(named: "empty.jpg"))
    let awayTeamNameLabel = FNBodyLabel(allingment: .center)
    let gameStatusLabel = FNCaptionLabel(allingment: .center)
    let gameScoreLabel = FNLargeTitleLabel(allingment: .center)
    let timeElapsedLabel = FNCaptionLabel(allingment: .center)
    
    let cache = NetworkManager.shared.cache

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(game: FixturesData) {
        let status = game.fixture.status.short
        let time = game.fixture.status.elapsed

        timeElapsedLabel.text = FNFixtureMethods.getElapsedTime(elapsed: time, gameStatus: status)

        gameScoreLabel.text = "\(String(game.goals.home!)) - \(String(game.goals.away!))"
        
        homeTeamNameLabel.text = game.teams.home.name
        awayTeamNameLabel.text = game.teams.away.name
        
        gameStatusLabel.text = FNFixtureMethods.getGameStatus(for: status)

        homeTeamLogoImageView.image = NetworkManager.shared.downloadImage(from: game.teams.home.logo)
        awayTeamLogoImageView.image = NetworkManager.shared.downloadImage(from: game.teams.away.logo)
    }
    
    
    func configure() {
        
    }

    
    func addSubviews() {
        addSubview(homeTeamView)
        addSubview(awayTeamView)
        addSubview(scoreView)
        
        homeTeamView.addSubview(homeTeamLogoImageView)
        homeTeamView.addSubview(homeTeamNameLabel)
        
        awayTeamView.addSubview(awayTeamLogoImageView)
        homeTeamView.addSubview(awayTeamNameLabel)
        
        scoreView.addSubview(gameStatusLabel)
        scoreView.addSubview(gameScoreLabel)
        scoreView.addSubview(timeElapsedLabel)
    }
    
    
    func addConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        homeTeamView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: self.topAnchor),
            scoreView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scoreView.widthAnchor.constraint(equalToConstant: 80),
            scoreView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            homeTeamView.topAnchor.constraint(equalTo: self.topAnchor),
            homeTeamView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            homeTeamView.trailingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            homeTeamView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            awayTeamView.topAnchor.constraint(equalTo: self.topAnchor),
            awayTeamView.leadingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            awayTeamView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            awayTeamView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            homeTeamLogoImageView.topAnchor.constraint(equalTo: homeTeamView.topAnchor, constant: 15),
            homeTeamLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            homeTeamLogoImageView.heightAnchor.constraint(equalToConstant: 40),
            homeTeamLogoImageView.centerXAnchor.constraint(equalTo: homeTeamView.centerXAnchor),
            
            homeTeamNameLabel.leadingAnchor.constraint(equalTo: homeTeamView.leadingAnchor, constant: 10),
            homeTeamNameLabel.trailingAnchor.constraint(equalTo: homeTeamView.trailingAnchor, constant: -10),
            homeTeamNameLabel.heightAnchor.constraint(equalToConstant: 18),
            homeTeamNameLabel.bottomAnchor.constraint(equalTo: homeTeamView.bottomAnchor, constant: -15),
            
            awayTeamLogoImageView.topAnchor.constraint(equalTo: homeTeamLogoImageView.topAnchor),
            awayTeamLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            awayTeamLogoImageView.heightAnchor.constraint(equalToConstant: 40),
            awayTeamLogoImageView.centerXAnchor.constraint(equalTo: awayTeamView.centerXAnchor),
            
            awayTeamNameLabel.leadingAnchor.constraint(equalTo: awayTeamView.leadingAnchor, constant: 10),
            awayTeamNameLabel.trailingAnchor.constraint(equalTo: awayTeamView.trailingAnchor, constant: -10),
            awayTeamNameLabel.heightAnchor.constraint(equalToConstant: 18),
            awayTeamNameLabel.bottomAnchor.constraint(equalTo: awayTeamView.bottomAnchor, constant: -15),
            
            gameScoreLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            gameScoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor),
            
            gameStatusLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 3),
            gameStatusLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 3),
            gameStatusLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -3),
            gameStatusLabel.heightAnchor.constraint(equalToConstant: 18),
            
            timeElapsedLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -3),
            timeElapsedLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 3),
            timeElapsedLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -3),
            timeElapsedLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
