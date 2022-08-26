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
        homeTeamLogoImageView.image = NetworkManager.shared.downloadImage(from: nextGame.teams.home.logo)
        awayTeamLogoImageView.image = NetworkManager.shared.downloadImage(from: nextGame.teams.away.logo)
        
        homeTeamNameLabel.text = nextGame.teams.home.name
        awayTeamNameLabel.text = nextGame.teams.away.name
        
        gameTimeLabel.text = FNFixtureMethods.getGameStartTime(timestamp: nextGame.fixture.timestamp, gameStatus: nextGame.fixture.status.short)
        
        let dateString = FNDateFormatting.getDDMM(timestamp: nextGame.fixture.timestamp)
        gameDateLabel.attributedText = FNAttributedStrings.getAttributedDate(for: dateString)
    }
    
    
    func configure() {
        backgroundColor = .clear
        gameDateLabel.numberOfLines = 2
        vLineView.backgroundColor = .lightGray
    }
    
    
    func addSubviews() {
        contentView.addSubview(gameDateLabel)
        contentView.addSubview(homeTeamNameLabel)
        contentView.addSubview(homeTeamLogoImageView)
        contentView.addSubview(awayTeamNameLabel)
        contentView.addSubview(awayTeamLogoImageView)
        contentView.addSubview(gameTimeLabel)
        contentView.addSubview(vLineView)
    }
    
    
    func addConstraints() {
        gameDateLabel.translatesAutoresizingMaskIntoConstraints = false
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            gameDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            gameDateLabel.widthAnchor.constraint(equalToConstant: 30),
            
            homeTeamLogoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -15),
            homeTeamLogoImageView.leadingAnchor.constraint(equalTo: gameDateLabel.trailingAnchor, constant: 15),
            homeTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            homeTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            homeTeamNameLabel.centerYAnchor.constraint(equalTo: homeTeamLogoImageView.centerYAnchor),
            homeTeamNameLabel.leadingAnchor.constraint(equalTo: homeTeamLogoImageView.trailingAnchor, constant: 5),
            
            awayTeamLogoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 15),
            awayTeamLogoImageView.leadingAnchor.constraint(equalTo: gameDateLabel.trailingAnchor, constant: 15),
            awayTeamLogoImageView.widthAnchor.constraint(equalToConstant: 25),
            awayTeamLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            awayTeamNameLabel.centerYAnchor.constraint(equalTo: awayTeamLogoImageView.centerYAnchor),
            awayTeamNameLabel.leadingAnchor.constraint(equalTo: awayTeamLogoImageView.trailingAnchor, constant: 5),
            
            vLineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            vLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            vLineView.widthAnchor.constraint(equalToConstant: 0.5),
            
            gameTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            gameTimeLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 10),
            gameTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
