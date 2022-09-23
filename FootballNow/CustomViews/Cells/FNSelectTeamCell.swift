//
//  FNSelectTeamCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 29/08/2022.
//

import UIKit

class FNSelectTeamCell: UITableViewCell {
    
    static let cellId = "SelectTeamCell"

    let teamLogoImageView = UIImageView()
    let teamNameLabel = FNBodyLabel(allingment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        backgroundColor = FNColors.sectionColor
        self.accessoryType = .disclosureIndicator
    }
    
    
    func addSubviews() {
        addSubview(teamLogoImageView)
        addSubview(teamNameLabel)
        
        teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            teamLogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            teamLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 30),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            teamNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo: teamLogoImageView.trailingAnchor, constant: 15),
            teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }

    
    func set(teams: TeamsResponse) {
        teamNameLabel.text = teams.team.name
        
        NetworkManager.shared.downloadImage(from: teams.team.logo) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.teamLogoImageView.image = image
            }
        }
    }
}
