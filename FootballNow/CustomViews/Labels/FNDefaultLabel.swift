//
//  FNDefaultLabel.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 01/09/2022.
//

import UIKit

class FNDefaultLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(allingment: NSTextAlignment) {
        super.init(frame: .zero)
        
        textAlignment = allingment
        configure()
    }
    
    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 14, weight: .regular)
    }
}
