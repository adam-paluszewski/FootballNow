//
//  FNNoResultsView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 02/09/2022.
//

import UIKit

enum ImagePosition {
    case left, top
}

class FNNoResultsView: UIView {

    let textLabel = UILabel()
    let imageView = UIImageView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(text: String, image: UIImage, imagePosition: ImagePosition) {
        super.init(frame: .zero)
        textLabel.text = text
        imageView.image = image
        
        switch imagePosition {
            case .left:
                stackView.axis = .horizontal
            case .top:
                stackView.axis = .vertical
        }
        
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    func configure() {
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = .label
        stackView.spacing = 20
    }
    
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
    
}
