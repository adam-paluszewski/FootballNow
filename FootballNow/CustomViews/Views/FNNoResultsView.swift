//
//  FNNoResultsView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 02/09/2022.
//

import UIKit

class FNNoResultsView: UIView {

    let textLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(text: String, image: UIImage) {
        super.init(frame: .zero)
        textLabel.text = text
        imageView.image = image

        
        configure()
        addSubviews()
    }
    
    
    func configure() {
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = .label
        textLabel.numberOfLines = 0
    }
    
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -80),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textLabel.widthAnchor.constraint(equalToConstant: 200),
            textLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            
        ])
    }
}
