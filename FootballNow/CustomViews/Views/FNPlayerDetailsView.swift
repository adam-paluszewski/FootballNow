//
//  FNPlayerDetailsView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import UIKit

class FNPlayerDetailsView: UIView {
    
    let photoImageView = UIImageView()
    let nameLabel = FNLargeTitleLabel(allingment: .center)
    let positionLabel = FNBodyLabel(allingment: .center)
    
    let mainTraitsView = UIView()
    let hLineView = UIView()
    let vLineView = UIView()
    
    let ageLabel = FNBodyLabel(allingment: .center)
    let nationalityLabel = FNBodyLabel(allingment: .center)
    let heightLabel = FNBodyLabel(allingment: .center)
    let weightLabel = FNBodyLabel(allingment: .center)
    let numberLabel = FNBodyLabel(allingment: .center)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(player: PlayersPlayer, number: Int?, position: String?) {
        NetworkManager.shared.downloadImage(from: player.photo ?? "", completionHandler: { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
        })
        nameLabel.text = (player.firstname ?? "") + " " + (player.lastname ?? "")
        positionLabel.text = FNTranslateToPolish.shared.translatePlayerPosition(from: position)
        
        if let height = player.height {
            heightLabel.text = "Wzrost: \n\(height)"
        }
        
        if let weight = player.weight {
            weightLabel.text = "Waga: \n\(weight)"
        }
        
        if let nationality = player.nationality {
            nationalityLabel.text = "Narodowość: \n\(nationality)"
        }
        
        if let age = player.age {
            ageLabel.text = "Wiek: \n" + FNAgeSuffix.shared.ageSuffix(age: age)
        }
        
        
        
        
    }
    
    
    func configure() {
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 75
        mainTraitsView.backgroundColor = FNColors.sectionColor
        ageLabel.numberOfLines = 2
        nationalityLabel.numberOfLines = 2
        heightLabel.numberOfLines = 2
        weightLabel.numberOfLines = 2
        vLineView.backgroundColor = FNColors.separatorColor
        hLineView.backgroundColor = FNColors.separatorColor
    }
    
    
    func addSubviews() {
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(positionLabel)
        addSubview(mainTraitsView)
        mainTraitsView.addSubview(vLineView)
        mainTraitsView.addSubview(hLineView)
        mainTraitsView.addSubview(ageLabel)
        mainTraitsView.addSubview(heightLabel)
        mainTraitsView.addSubview(weightLabel)
        mainTraitsView.addSubview(numberLabel)
        addSubview(nationalityLabel)
    }
    
    
    func addConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        mainTraitsView.translatesAutoresizingMaskIntoConstraints = false
        vLineView.translatesAutoresizingMaskIntoConstraints = false
        hLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            positionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            mainTraitsView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 15),
            mainTraitsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainTraitsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainTraitsView.heightAnchor.constraint(equalToConstant: 200),
            
            vLineView.centerXAnchor.constraint(equalTo: mainTraitsView.centerXAnchor),
            vLineView.centerYAnchor.constraint(equalTo: mainTraitsView.centerYAnchor),
            vLineView.heightAnchor.constraint(equalTo: mainTraitsView.heightAnchor),
            vLineView.widthAnchor.constraint(equalToConstant: 0.5),
            
            hLineView.centerXAnchor.constraint(equalTo: mainTraitsView.centerXAnchor),
            hLineView.centerYAnchor.constraint(equalTo: mainTraitsView.centerYAnchor),
            hLineView.widthAnchor.constraint(equalTo: mainTraitsView.widthAnchor),
            hLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            
            
            ageLabel.topAnchor.constraint(equalTo: mainTraitsView.topAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: mainTraitsView.leadingAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor),
            ageLabel.heightAnchor.constraint(equalToConstant: 100),
            
            nationalityLabel.leadingAnchor.constraint(equalTo: mainTraitsView.leadingAnchor),
            nationalityLabel.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor),
            nationalityLabel.bottomAnchor.constraint(equalTo: mainTraitsView.bottomAnchor),
            nationalityLabel.heightAnchor.constraint(equalToConstant: 100),
            
            heightLabel.topAnchor.constraint(equalTo: mainTraitsView.topAnchor),
            heightLabel.trailingAnchor.constraint(equalTo: mainTraitsView.trailingAnchor),
            heightLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor),
            heightLabel.heightAnchor.constraint(equalToConstant: 100),
            
            weightLabel.trailingAnchor.constraint(equalTo: mainTraitsView.trailingAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor),
            weightLabel.bottomAnchor.constraint(equalTo: mainTraitsView.bottomAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: 100),
           
        ])
        
    }
}
