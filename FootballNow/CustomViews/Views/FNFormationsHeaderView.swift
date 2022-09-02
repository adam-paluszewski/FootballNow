//
//  FNFormationsHeaderView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 02/09/2022.
//

import UIKit

class FNFormationsHeaderView: UIView {
    
    let separatorView = UIView()
    let sectionTitleLabel = FNBodyLabel(allingment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String) {
        super.init(frame: .zero)
        sectionTitleLabel.text = title
        
        configure()
        addSubviews()
        addConstraints()
    }
    

    func configure() {
        backgroundColor = UIColor(named: "FNSectionColor")
        separatorView.backgroundColor = .lightGray
        
        sectionTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        sectionTitleLabel.textColor = .label
    }
    
    
    func addSubviews() {
        addSubview(separatorView)
        addSubview(sectionTitleLabel)
    }
    
    
    func addConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sectionTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            separatorView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1)


        ])
    }

}
