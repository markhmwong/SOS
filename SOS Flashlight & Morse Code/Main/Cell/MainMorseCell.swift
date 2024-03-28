//
//  MainMorseCell.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MainCell: MorseCodeBaseCell<SystemModeItem> {
    
    override var item: SystemModeItem? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.defaultBlack
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsIfNeeded()
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func setupViewsIfNeeded() {
        super.setupViewsIfNeeded()
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor, constant: -0),
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 5)
        ])
    }
    
    override func configureCell(with item: SystemModeItem) {
        self.item = item
        
        titleLabel.text = self.item?.name
        
    }
    
}




