//
//  FNPlayerCell.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/08/2022.
//

import UIKit

class FNPlayerCell: UICollectionViewCell {
    
    static let cellId = "PlayerCell"
    
    let tshirtImageView = UIImageView()
    let photoImageView = UIImageView()
    let nameLabel = FNBodyLabel(allingment: .center)
    let positionLabel = FNCaptionLabel(allingment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(player: SquadsPlayer) {
        if let photo = player.photo {
            photoImageView.image = NetworkManager.shared.downloadImage(from: photo)
        }
        
        nameLabel.text = player.name
        positionLabel.text = player.position
        

    }
    
    
    func configure() {
        tshirtImageView.image = UIImage(named: "tshirt.png")
        self.backgroundColor = UIColor(named: "FNTertiaryBackgroundColor")
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 50
        positionLabel.textColor = .secondaryLabel
    }
    
    
    func addSubviews() {
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(positionLabel)
        addSubview(tshirtImageView)
    }
    
    
    func addConstraints() {
        tshirtImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            positionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            positionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tshirtImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            tshirtImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            tshirtImageView.widthAnchor.constraint(equalToConstant: 35),
            tshirtImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
