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
    let sectionTitle = UILabel()
    let button = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        configureHeaderView()
        configureSeparatorView()
        configureBodyView()
        
        configureSectionTitle()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String) {
        super.init(frame: .zero)
        sectionTitle.text = title
        
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        
        configureHeaderView()
        configureSeparatorView()
        configureBodyView()
        
        configureSectionTitle()
    }
    
    
    init(title: String, buttonText: String) {
        super.init(frame: .zero)
        sectionTitle.text = title
        button.setTitle(buttonText, for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        
        configureHeaderView()
        configureSeparatorView()
        configureBodyView()
        
        configureSectionTitle()
        configureButton()
    }
    
    
    func configure() {
//        layer.cornerRadius = 0
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOpacity = 0.3
//        layer.shadowOffset = CGSize(width: 3, height: 3)
//        layer.shadowRadius = 5
    }
    
    
    func configureHeaderView() {
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .secondarySystemBackground
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    func configureSeparatorView() {
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    func configureBodyView() {
        addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.backgroundColor = .secondarySystemBackground
        
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    
    func configureSectionTitle() {
        headerView.addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.font = .systemFont(ofSize: 14, weight: .regular)
        sectionTitle.textColor = .label
        
        NSLayoutConstraint.activate([
            sectionTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            sectionTitle.widthAnchor.constraint(equalToConstant: 100),
            sectionTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func configureButton() {
        headerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .trailing
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
