//
//  FNCaptionLabel.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/08/2022.
//

import UIKit

class FNCaptionLabel: UILabel {

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
        font = .systemFont(ofSize: 12, weight: .regular)
    }

}
