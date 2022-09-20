//
//  FNAlertVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 19/09/2022.
//

import UIKit

class FNAlertVC: UIViewController {
    
    let containerView = FNAlertContainerView()
    let titleLabel = FNLargeTitleLabel(allingment: .center)
    let messageLabel = FNBodyLabel(allingment: .center)
    var actionButton = FNButton()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var buttonColor: UIColor?
    var buttonImage: UIImage?
    
    
    init(title: String, message: String, buttonTitle: String, buttonColor: UIColor, buttonSystemImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.actionButton.configuration?.title = buttonTitle
        self.actionButton.configuration?.baseBackgroundColor = buttonColor
        self.actionButton.configuration?.image = buttonSystemImage
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        //containerView
        view.addSubview(containerView)
        
        //titleLabel
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        //messageLabel
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        //actionButton
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        //constraints
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20)
        ])
    }
    
}
