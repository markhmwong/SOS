//
//  PaddedButton.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 24/3/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class PaddedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        self.layer.backgroundColor = Theme.Dark.secondary.cgColor
        self.layer.cornerRadius = 8.0
        self.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 25.0, bottom: 7.0, right: 25.0)
    }
}
