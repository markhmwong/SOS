//
//  MenuBar.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate {
    
    private lazy var collectionView: UICollectionView = {
        let vc = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().horizontalMenuLayout(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(1.0)))
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = UIColor.mainBackground
        vc.delegate = self
        vc.isScrollEnabled = false
        return vc
    }()
    
    var horizontalBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.defaultText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dataSource: MenuBarDataSource

    var parentViewController: MainMorseViewController
    
    var flashlight: Flashlight
    
    init(vc: MainMorseViewController, flashlight: Flashlight) {
        self.flashlight = flashlight
        self.parentViewController = vc
        dataSource = MenuBarDataSource()
        super.init(frame: .zero)
        setup()
    }
    
    var horizontalBarLeadingConstraint: NSLayoutConstraint? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        addSubview(horizontalBar)
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        dataSource.configureDataSource(collectionView: collectionView)
        
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true

        horizontalBarLeadingConstraint = horizontalBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        horizontalBarLeadingConstraint?.isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.parentViewController.scrollToItem(indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
