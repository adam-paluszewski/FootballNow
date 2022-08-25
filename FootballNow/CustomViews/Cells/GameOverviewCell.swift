//
//  GameOverviewCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class GameOverviewCell: UITableViewCell {
    
    static let cellId = "LastGameCell"
    
    let homeTeamView = UIView()
    let awayTeamView = UIView()
    let scoreView = UIView()
    let homeTeamLogo = UIImageView()
    let homeTeamName = FNDefaultTextLabel(allingment: .center)
    let awayTeamLogo = UIImageView()
    let awayTeamName = FNDefaultTextLabel(allingment: .center)
    let gameStatus = FNDefaultTextLabel(allingment: .center)
    let gameScore = FNDefaultTextLabel(allingment: .center)
    let gameTime = FNDefaultTextLabel(allingment: .center)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(game: GameData) {
//        let gameStatus = game.fixture.status.short
//        let gameTime = game.fixture.status.elapsed
//        
//        gameTime.text = FixtureMethods.getElapsedTime(elapsed: gameTime, gameStatus: gameStatus)
//
        gameScore.text = "\(String(game.goals.home!)) - \(String(game.goals.away!))"
        
        homeTeamName.text = game.teams.home.name
        awayTeamName.text = game.teams.away.name
        
//        gameStatus.text = FixtureMethods.getGameStatus(for: gameStatus)
//
//        homeTeamLogo.image = downloadImage(from: game.teams.home.logo)
//        awayTeamLogo.image = downloadImage(from: game.teams.away.logo)
    }
    
    
//    func downloadImage(from urlString: String) -> UIImage {
//        let cacheKey = NSString(string: urlString)
//
//        if let image = cache.object(forKey: cacheKey) {
//            return image
//        }
//
//        let image = Networking.getImageFromStringURL(string: urlString)
//        cache.setObject(image, forKey: cacheKey)
//        return image
//    }
    

    func configure() {
        backgroundColor = .secondarySystemBackground
        homeTeamName.text = "Raków Częstochowa"
        homeTeamLogo.image = UIImage(systemName: "heart")
        awayTeamName.text = "Raków Częstochowa"
        awayTeamLogo.image = UIImage(systemName: "heart")
        
        addSubview(homeTeamView)
        addSubview(awayTeamView)
        addSubview(scoreView)
        homeTeamView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: self.topAnchor),
            scoreView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scoreView.heightAnchor.constraint(equalToConstant: 80),
            scoreView.widthAnchor.constraint(equalToConstant: 80),
            
            homeTeamView.topAnchor.constraint(equalTo: self.topAnchor),
            homeTeamView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            homeTeamView.trailingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            homeTeamView.heightAnchor.constraint(equalToConstant: 80),
            
            awayTeamView.topAnchor.constraint(equalTo: self.topAnchor),
            awayTeamView.leadingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            awayTeamView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            awayTeamView.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        homeTeamView.addSubview(homeTeamLogo)
        homeTeamView.addSubview(homeTeamName)
        homeTeamLogo.translatesAutoresizingMaskIntoConstraints = false
        homeTeamName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeTeamLogo.topAnchor.constraint(equalTo: homeTeamView.topAnchor, constant: 10),
            homeTeamLogo.widthAnchor.constraint(equalToConstant: 40),
            homeTeamLogo.heightAnchor.constraint(equalToConstant: 40),
            homeTeamLogo.centerXAnchor.constraint(equalTo: homeTeamView.centerXAnchor),
            
            homeTeamName.topAnchor.constraint(equalTo: homeTeamLogo.bottomAnchor, constant: 3),
            homeTeamName.leadingAnchor.constraint(equalTo: homeTeamView.leadingAnchor, constant: 10),
            homeTeamName.trailingAnchor.constraint(equalTo: homeTeamView.trailingAnchor, constant: -10),
            homeTeamName.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        awayTeamView.addSubview(awayTeamLogo)
        homeTeamView.addSubview(awayTeamName)
        awayTeamLogo.translatesAutoresizingMaskIntoConstraints = false
        awayTeamName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            awayTeamLogo.topAnchor.constraint(equalTo: awayTeamView.topAnchor, constant: 10),
            awayTeamLogo.widthAnchor.constraint(equalToConstant: 40),
            awayTeamLogo.heightAnchor.constraint(equalToConstant: 40),
            awayTeamLogo.centerXAnchor.constraint(equalTo: awayTeamView.centerXAnchor),
            
            awayTeamName.topAnchor.constraint(equalTo: awayTeamLogo.bottomAnchor, constant: 3),
            awayTeamName.leadingAnchor.constraint(equalTo: awayTeamView.leadingAnchor, constant: 10),
            awayTeamName.trailingAnchor.constraint(equalTo: awayTeamView.trailingAnchor, constant: -10),
            awayTeamName.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        scoreView.addSubview(gameStatus)
        scoreView.addSubview(gameScore)
        scoreView.addSubview(gameTime)
        gameStatus.translatesAutoresizingMaskIntoConstraints = false
        gameScore.translatesAutoresizingMaskIntoConstraints = false
        gameTime.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameScore.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            gameScore.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor),
            
            gameStatus.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 3),
            gameStatus.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 3),
            gameStatus.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -3),
            gameStatus.heightAnchor.constraint(equalToConstant: 18),
            
            gameTime.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -3),
            gameTime.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 3),
            gameTime.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -3),
            gameTime.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        gameScore.text = "3 - 5"
        gameStatus.text = "Zakonczony"
        gameTime.text = "87'"
    }
    
    
}
