//
//  FNEmptyStateView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 21/09/2022.
//

import UIKit

class FNEmptyStateView: UIView {
    
    let imageView = UIImageView()
    let textLabel = FNBodyLabel(allingment: .center)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(text: String, image: EmptyStateImages, axis: UIAxis) {
        super.init(frame: .zero)
        textLabel.text = text
        imageView.image =  UIImage(named: image.rawValue)
        
        commonConfigure()
        switch axis {
            case .horizontal:
                configureHorizontal()
            case .vertical:
                configureVertical()
            default:
                print("")
        }
    }
    
    
    func commonConfigure() {
        addSubview(imageView)
        addSubview(textLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .secondaryLabel
        textLabel.numberOfLines = 0
    }
    
    
    func configureHorizontal() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        ])
    }
    
    
    func configureVertical() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -80),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textLabel.widthAnchor.constraint(equalToConstant: 200),
            textLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            
        ])
    }
}
