//
//  FNFormationsHeaderView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 02/09/2022.
//

import UIKit

class FNFormationsHeaderView: UIView {
    
    let separatorView = UIView()
    let titleView = UIView()
    let sectionTitleLabel = FNBodyLabel(allingment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String?, allingment: NSTextAlignment) {
        super.init(frame: .zero)
        sectionTitleLabel.text = title
        sectionTitleLabel.textAlignment = allingment
        
        configure()
        addSubviews()
    }
    

    func configure() {
        backgroundColor = FNColors.backgroundColor
        titleView.backgroundColor = FNColors.sectionColor
        separatorView.backgroundColor = FNColors.separatorColor
        sectionTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        sectionTitleLabel.textColor = .label
    }
    
    
    func addSubviews() {
        addSubview(separatorView)
        addSubview(titleView)
        addSubview(sectionTitleLabel)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 40),
            
            sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            sectionTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
    }
}
