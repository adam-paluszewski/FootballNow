//
//  FNNextGameCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/08/2022.
//

import UIKit

class FNNextGameCell: UITableViewCell {

    static let cellId = "NextGamesCell"
    
    let gameDateLabel = UILabel()
    let homeTeamNameLabel = FNBodyLabel(allingment: .left)
    let homeTeamLogoImageView = UIImageView()
    let awayTeamNameLabel = FNBodyLabel(allingment: .left)
    let awayTeamLogoImageView = UIImageView()
    let gameTimeLabel = FNBodyLabel(allingment: .center)
    let vLineView = UIView()
    let leagueLogoImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(nextGame: FixturesData) {
        homeTeamNameLabel.text = nextGame.teams.home.name
        awayTeamNameLabel.text = nextGame.teams.away.name
        
        gameTimeLabel.text = FNFixtureMethods.getGameStartTime(timestamp: nextGame.fixture.timestamp, gameStatus: nextGame.fixture.status.short)
        
        let dateString = FNDateFormatting.getDDMM(timestamp: nextGame.fixture.timestamp)
        gameDateLabel.attributedText = FNAttributedStrings.getAttributedDate(for: dateString)
        
        NetworkManager.shared.downloadImage(from: nextGame.teams.home.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.homeTeamLogoImageView.image = image
            }
        }
        
        NetworkManager.shared.downloadImage(from: nextGame.teams.away.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.awayTeamLogoImageView.image = image
            }
        }
        
        NetworkManager.shared.downloadImage(from: nextGame.league.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.leagueLogoImageView.image = image
            }
        }
    }
    
    
    func configure() {
        backgroundColor = .clear
        gameDateLabel.numberOfLines = 2
        gameDateLabel.textAlignment = .center
        gameTimeLabel.numberOfLines = 3
        vLineView.backgroundColor = .lightGray
    }
    
    
    func addSubviews() {
        addSubview(gameDateLabel)
        addSubview(homeTeamNameLabel)
        addSubview(homeTeamLogoImageView)
        addSubview(awayTeamNameLabel)
        addSubview(awayTeamLogoImageView)
        addSubview(gameTimeLabel)
        addSubview(vLineView)
        addSubview(leagueLogoImageView)
    }
    
    
    func addConstraints() {
        gameDateLabel.translatesAutoresizingMaskIntoConstraints = false
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        leagueLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gameDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            gameDateLabel.widthAnchor.constraint(equalToConstant: 30),
            
            homeTeamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            homeTeamLogoImageView.leadingAnchor.constraint(equalTo: gameDateLabel.trailingAnchor, constant: 15),
            homeTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            homeTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            homeTeamNameLabel.centerYAnchor.constraint(equalTo: homeTeamLogoImageView.centerYAnchor),
            homeTeamNameLabel.leadingAnchor.constraint(equalTo: homeTeamLogoImageView.trailingAnchor, constant: 5),
            
            awayTeamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            awayTeamLogoImageView.leadingAnchor.constraint(equalTo: gameDateLabel.trailingAnchor, constant: 15),
            awayTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            awayTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            awayTeamNameLabel.centerYAnchor.constraint(equalTo: awayTeamLogoImageView.centerYAnchor),
            awayTeamNameLabel.leadingAnchor.constraint(equalTo: awayTeamLogoImageView.trailingAnchor, constant: 5),
            
            vLineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            vLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100),
            vLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            vLineView.widthAnchor.constraint(equalToConstant: 0.5),
            
            gameTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gameTimeLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 10),
            gameTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            leagueLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leagueLogoImageView.heightAnchor.constraint(equalToConstant: 35),
            leagueLogoImageView.widthAnchor.constraint(equalToConstant: 35),
            leagueLogoImageView.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor, constant: -10)
        ])
    }
}
