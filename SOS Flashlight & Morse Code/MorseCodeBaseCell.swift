//
//  MorseCodeBaseCell.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 28/3/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

protocol MorseCodeCell {
    associatedtype T
    func configureCell<T>(with item: T)
    func setupViewsIfNeeded()
}

class MorseCodeBaseCell<T>: UICollectionViewCell {
    
    var item: T? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsIfNeeded() {
        
    }
    
    func configureCell(with item: T) {
       
    }
   
}
