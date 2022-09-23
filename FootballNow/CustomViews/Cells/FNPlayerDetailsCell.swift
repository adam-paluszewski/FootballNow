//
//  FNPlayerDetailsCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 23/09/2022.
//

import UIKit

class FNPlayerDetailsCell: UITableViewCell {
    
    static let cellId = "PlayerDetailsCell"
    
    let detailLabel = FNBodyLabel(allingment: .left)
    let valueLabel = FNBodyLabel(allingment: .right)
   
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
    }
    
    
    func addSubviews() {
        addSubview(detailLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    
    func set(player: PlayerP, row: Int, title: String) {
        
        switch row {
            case 0:
                if let age = player.age {
                    valueLabel.text = String(age)
                }
                detailLabel.text = title
            case 1:
                valueLabel.text = player.height ?? "b/d"
                detailLabel.text = title
            case 2:
                valueLabel.text = player.weight ?? "b/d"
                detailLabel.text = title
            case 3:
                valueLabel.text = player.nationality ?? "b/d"
                detailLabel.text = title
            default:
                print()
        }
        
        
    }
}
