//
//  FNSearchResultCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import UIKit

class FNSearchResultCell: UITableViewCell {

    static let cellId = "SearchResultCell"

    let teamLogoImageView = UIImageView()
    let teamNameLabel = FNBodyLabel(allingment: .left)
    let addToFavoritesButton = UIButton()
    
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
//        self.accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor(named: "FNSectionColor")
        addToFavoritesButton.tintColor = .systemRed
    }
    
    
    func addSubviews() {
        addSubview(teamLogoImageView)
        addSubview(teamNameLabel)
        contentView.addSubview(addToFavoritesButton)
    }
    
    
    func addConstraints() {
        teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            teamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            teamLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 30),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            teamNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo: teamLogoImageView.trailingAnchor, constant: 15),
            teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            addToFavoritesButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func set(teams: TeamsData) {
        teamNameLabel.text = teams.team.name
        
        NetworkManager.shared.downloadImage(from: teams.team.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.teamLogoImageView.image = image
            }
        }
        
        if Favorites.shared.favoritesTeams.contains(where: {$0.team.name == teams.team.name}) {
            addToFavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
            
            
    }
}
