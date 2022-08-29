//
//  FNLastGameCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class FNLastGameCell: UITableViewCell {

    static let cellId = "LastGamesCell"
    
    let gameDateLabel = UILabel()
    let homeTeamNameLabel = FNBodyLabel(allingment: .left)
    let homeTeamLogoImageView = UIImageView()
    let awayTeamNameLabel = FNBodyLabel(allingment: .left)
    let awayTeamLogoImageView = UIImageView()
    let homeTeamScoreLabel = FNBodyLabel(allingment: .center)
    let awayTeamScoreLabel = FNBodyLabel(allingment: .center)
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
    
    
    func set(lastGame: FixturesData) {
        homeTeamNameLabel.text = lastGame.teams.home.name
        awayTeamNameLabel.text = lastGame.teams.away.name
        
        if let homeTeamGoals = lastGame.goals.home {
            homeTeamScoreLabel.text = String(homeTeamGoals)
        }
        
        if let awayTeamGoals = lastGame.goals.away {
            awayTeamScoreLabel.text = String(awayTeamGoals)
        }
        
        let dateString = FNDateFormatting.getDDMM(timestamp: lastGame.fixture.timestamp)
        gameDateLabel.attributedText = FNAttributedStrings.getAttributedDate(for: dateString)
        
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
        contentView.addSubview(homeTeamScoreLabel)
        contentView.addSubview(awayTeamScoreLabel)
        contentView.addSubview(vLineView)
    }
    
    
    func addConstraints() {
        gameDateLabel.translatesAutoresizingMaskIntoConstraints = false
        homeTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            homeTeamScoreLabel.firstBaselineAnchor.constraint(equalTo: homeTeamNameLabel.firstBaselineAnchor),
            homeTeamScoreLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 45),
            
            awayTeamScoreLabel.firstBaselineAnchor.constraint(equalTo: awayTeamNameLabel.firstBaselineAnchor),
            awayTeamScoreLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: 45),
        ])
    }
}
