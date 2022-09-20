//
//  FNStandingsHeaderView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import UIKit

class FNStandingsHeaderView: UIView {

    let positionLabel = FNTinyLabel(allingment: .left)
    let gamesPlayedLabel = FNTinyLabel(allingment: .center)
    let gamesWonLabel = FNTinyLabel(allingment: .center)
    let gamesDrawLabel = FNTinyLabel(allingment: .center)
    let gamesLostLabel = FNTinyLabel(allingment: .center)
    let pointsLabel = FNTinyLabel(allingment: .center)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        backgroundColor = FNColors.sectionColor
        
        positionLabel.text = "Pozycja"
        gamesPlayedLabel.text = "RM"
        gamesWonLabel.text = "Z"
        gamesDrawLabel.text = "R"
        gamesLostLabel.text = "P"
        pointsLabel.text = "Punkty"
    }
    
    
    func addSubviews() {
        addSubview(positionLabel)
        addSubview(gamesPlayedLabel)
        addSubview(gamesWonLabel)
        addSubview(gamesDrawLabel)
        addSubview(gamesLostLabel)
        addSubview(pointsLabel)
    }
    
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            positionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            positionLabel.widthAnchor.constraint(equalToConstant: 50),
            
            pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pointsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            pointsLabel.widthAnchor.constraint(equalToConstant: 35),
            
            gamesLostLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gamesLostLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -15),
            gamesLostLabel.widthAnchor.constraint(equalToConstant: 17),
            
            gamesDrawLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gamesDrawLabel.trailingAnchor.constraint(equalTo: gamesLostLabel.leadingAnchor, constant: -15),
            gamesDrawLabel.widthAnchor.constraint(equalToConstant: 17),
            
            gamesWonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gamesWonLabel.trailingAnchor.constraint(equalTo: gamesDrawLabel.leadingAnchor, constant: -15),
            gamesWonLabel.widthAnchor.constraint(equalToConstant: 17),
            
            gamesPlayedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gamesPlayedLabel.trailingAnchor.constraint(equalTo: gamesWonLabel.leadingAnchor, constant: -15),
            gamesPlayedLabel.widthAnchor.constraint(equalToConstant: 17),
        ])
    }
}
