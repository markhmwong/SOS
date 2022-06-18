//
//  MorseMainViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 18/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MainMorseViewController: UIViewController {
    
    var viewModel: MainMorseViewModel

    var mainContent: UICollectionView = {
        let vc = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createCollectionViewSettingsLayout(itemSpace: .zero, groupSpacing: .zero))
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .blue
        return vc
    }()
    
    var menuBar: MenuBar
    
    init(viewModel: MainMorseViewModel) {
        self.viewModel = viewModel
        
        self.menuBar = MenuBar()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        view.addSubview(self.mainContent)
        view.addSubview(self.menuBar)
        
        menuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 14).isActive = true
        
        mainContent.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainContent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainContent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainContent.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
}

class MainMorseViewModel: NSObject {
    
    // cells
    // sos
    // morse code message conversion
    // morse code text conversion
    // camera tools
    
    override init() {
        super.init()
    }
    
    
    
}

class MenuBar: UIView {
    
    lazy var collectionView: UICollectionView = {
        let vc = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createCollectionViewSettingsLayout(itemSpace: .zero, groupSpacing: .zero))
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .purple
        return vc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
}
