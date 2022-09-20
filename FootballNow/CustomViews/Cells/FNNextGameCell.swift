//
//  FNNextGameCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/08/2022.
//

import UIKit

class FNNextGameCell: UITableViewCell {

    static let cellId = "NextGamesCell"
    
    let gameDateLabel = FNBodyLabel(allingment: .center)
    let homeTeamNameLabel = FNBodyLabel(allingment: .left)
    let homeTeamLogoImageView = UIImageView()
    let awayTeamNameLabel = FNBodyLabel(allingment: .left)
    let awayTeamLogoImageView = UIImageView()
    let gameTimeLabel = FNBodyLabel(allingment: .center)
    let vLineView = UIView()
    let leagueLogoImageView = UIImageView()
    let stackView = UIStackView()
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
    
    
    func set(nextGame: FixturesResponse) {
        homeTeamNameLabel.text = nextGame.teams.home.name
        awayTeamNameLabel.text = nextGame.teams.away.name
        
        if let gameTime = FNFixtureMethods.getGameStartTime(timestamp: nextGame.fixture.timestamp, gameStatus: nextGame.fixture.status.short) {
            gameTimeLabel.text = gameTime
            gameTimeLabel.isHidden = false
        } else {
            gameTimeLabel.isHidden = true
        }
        
        
        let dateString = FNDateFormatting.getDMMM(timestamp: nextGame.fixture.timestamp)
        gameDateLabel.text = dateString
        
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
        backgroundColor = FNColors.sectionColor
        gameDateLabel.numberOfLines = 2
        gameTimeLabel.textColor = .secondaryLabel
        gameTimeLabel.numberOfLines = 1
        vLineView.backgroundColor = FNColors.separatorColor
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        leagueLogoImageView.sizeToFit()
        leagueBackgroundView.backgroundColor = .systemGray2
        leagueBackgroundView.clipsToBounds = true
        leagueBackgroundView.layer.cornerRadius = 22.5
    }
    
    
    func addSubviews() {
        contentView.addSubview(homeTeamNameLabel)
        contentView.addSubview(homeTeamLogoImageView)
        contentView.addSubview(awayTeamNameLabel)
        contentView.addSubview(awayTeamLogoImageView)
        contentView.addSubview(vLineView)
        contentView.addSubview(leagueBackgroundView)
        contentView.addSubview(leagueLogoImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(gameDateLabel)
        stackView.addArrangedSubview(gameTimeLabel)
    }
    
    
    func addConstraints() {
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        leagueLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
        ])
    }
}
