//
//  FNTablePlayerCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import UIKit

class FNTablePlayerCell: UITableViewCell {

    static let cellId = "TablePlayerCell"
    
    let cache = NetworkManager.shared.cache
    
    let photoImageView = UIImageView()
    let nameLabel = FNBodyLabel(allingment: .left)
    let ageLabel = FNCaptionLabel(allingment: .left)
    let positionLabel = FNBodyLabel(allingment: .left)
    let numberLabel = FNBodyLabel(allingment: .center)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(player: SquadsPlayer) {
        nameLabel.text = player.name
        ageLabel.text = FNAgeSuffix.shared.ageSuffix(age: player.age)
        positionLabel.text = FNTranslateToPolish.shared.translatePlayerPosition(from: player.position)
        
        if let photo =  player.photo {
            NetworkManager.shared.downloadImage(from: photo) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }
    }
    
    
    func configure() {
        backgroundColor = FNColors.sectionColor
        accessoryType = .disclosureIndicator
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 30
        ageLabel.textColor = .secondaryLabel
        positionLabel.textColor = .secondaryLabel
    }
    
    
    func addSubviews() {
        addSubview(photoImageView)
        addSubview(numberLabel)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(positionLabel)
    }
    
    
    func addConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),

            positionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            positionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            positionLabel.widthAnchor.constraint(equalToConstant: 100),
            
            ageLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5)
        ])
    }
}
