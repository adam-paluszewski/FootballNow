//
//  FNTeamTitleView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 30/08/2022.
//

import UIKit

class FNTeamTitleView: UIView {

    let imageView = UIImageView()
    let titleLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    init(image: String, title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        NetworkManager.shared.downloadImage(from: image, completionHandler: { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    
    func addConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
