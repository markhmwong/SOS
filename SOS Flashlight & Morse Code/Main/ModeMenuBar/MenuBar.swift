//
//  MenuBar.swift
//  Marquee
//
//  Created by Mark Wong on 9/10/2022.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate {
    
    private lazy var collectionView: UICollectionView = {
        let vc = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().horizontalMenuLayout(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(1.0)))
        vc.translatesAutoresizingMaskIntoConstraints = false
		vc.backgroundColor = .clear
        vc.delegate = self
        vc.isScrollEnabled = false
        return vc
    }()
    
    lazy var horizontalBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemOrange
        view.layer.cornerRadius = 3
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
        horizontalBar.addSubview(circle)
        
        circle.centerXAnchor.constraint(equalTo: horizontalBar.centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: horizontalBar.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 8).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 8).isActive = true

        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        dataSource.configureDataSource(collectionView: collectionView)
        
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        horizontalBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true

        horizontalBarLeadingConstraint = horizontalBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        horizontalBarLeadingConstraint?.isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let mode = MainMorseViewModel.SOSMode.init(rawValue: indexPath.item) else {
			return
		}
		self.parentViewController.scrollToMode(mode)
		
		// update collection view
		self.parentViewController.mainContentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
