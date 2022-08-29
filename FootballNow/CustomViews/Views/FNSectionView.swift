//
//  FNSectionView.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 22/08/2022.
//

import UIKit

class FNSectionView: UIView {
    
    let headerView = UIView()
    let separatorView = UIView()
    let bodyView = UIView()
    let sectionTitleLabel = FNBodyLabel(allingment: .left)
    let button = UIButton()

    
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
        
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    init(title: String, buttonText: String) {
        super.init(frame: .zero)
        sectionTitleLabel.text = title
        button.setTitle(buttonText, for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        addSubviews()
        addConstraints()
    }
    
    
    func configure() {
        
        headerView.backgroundColor = UIColor(named: "FNSectionColor")
        separatorView.backgroundColor = .lightGray
        bodyView.backgroundColor = UIColor(named: "FNSectionColor")
        
        sectionTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        sectionTitleLabel.textColor = .label
        
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .trailing
    }
    
    
    func addSubviews() {
        addSubview(headerView)
        addSubview(separatorView)
        addSubview(bodyView)
        
        headerView.addSubview(sectionTitleLabel)
        headerView.addSubview(button)
    }
    
    
    func addConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 40),
            
            separatorView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            bodyView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            sectionTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            sectionTitleLabel.widthAnchor.constraint(equalToConstant: 300),
            sectionTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
