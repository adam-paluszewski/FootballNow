//
//  FNDefaultTextLabel.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 25/08/2022.
//

import UIKit

class FNDefaultTextLabel: UILabel {

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
        font = .systemFont(ofSize: 14, weight: .regular)
    }
}
