//
//  FNSelectLeagueCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 06/09/2022.
//

import UIKit

class FNSelectLeagueCell: UITableViewCell {

    static let cellId = "SelectLeagueCell"

    let leagueImageView = UIImageView()
    let leagueNameLabel = FNBodyLabel(allingment: .left)
    
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
        self.accessoryType = .disclosureIndicator
    }
    
    
    func addSubviews() {
        addSubview(leagueImageView)
        addSubview(leagueNameLabel)
    }
    
    
    func addConstraints() {
        leagueImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leagueImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leagueImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            leagueImageView.widthAnchor.constraint(equalToConstant: 30),
            leagueImageView.heightAnchor.constraint(equalToConstant: 30),
            
            leagueNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leagueNameLabel.leadingAnchor.constraint(equalTo: leagueImageView.trailingAnchor, constant: 15),
            leagueNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
    
    
    func set(league: LeaguesData) {
        leagueNameLabel.text = league.league.name
        
        NetworkManager.shared.downloadImage(from: league.league.logo ?? "") { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.leagueImageView.image = image
            }
        }
    }
}
