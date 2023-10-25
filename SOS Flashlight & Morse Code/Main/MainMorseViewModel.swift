//
//  MainMorseViewModel.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MainMorseViewModel: NSObject {

    enum Section {
        case main
    }
    
    enum FlashLightMode: Int, CaseIterable {
        case sos = 0 
        case messageConversion // english to morse conversion
        case morseConversion // morse to english conversion
        case tools // quick tools
        
        var name: String {
            switch self {
            case .sos:
                return "sos"
            case .messageConversion:
                return "message conversion"
            case .morseConversion:
                return "morse conversion"
            case .tools:
                return "tools"
            }
        }
    }
    
    struct MainItem: Hashable {
        let name: String
        let section: Section
        let item: FlashLightMode
        let flashlight: Flashlight
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, MainItem>! = nil

    var mainMorseViewController: MainMorseViewController! = nil
    
    var flashFacingSideState: FlashFacingSide = .rear
    
    let flashlight = Flashlight()
    
    var sosLock: Bool = false
    
    // used for custom morse message to delivery via the flash light
    var messageToFlashlight: String = ""
    
//    var kFrontLightState: Bool = false

    var loopState: Bool = false {
        didSet {
//            mainMorseViewController.loopButton.alpha = loopState ? 1.0 : 0.5
        }
    }
    
    var buttonToggleState: Bool = true {
        didSet {
			
            mainMorseViewController.mainToggleButton.isEnabled = buttonToggleState
            mainMorseViewController.mainToggleButton.alpha = mainMorseViewController.mainToggleButton.isEnabled ? 1.0 : 0.1
        }
    }
    
//    var currState: MorseCodeMode

    private var currIndex: Int
    
    var nc = NotificationCenter.default
    
    var cds: CoreDataStack
    
    init(cds: CoreDataStack) {
        self.cds = cds
        self.currIndex = 0
//        self.currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.kMessage

        super.init()
        nc.addObserver(self, selector: #selector(updateMessageToFlash), name: Notification.Name(NotificationCenter.MESSAGE_TO_FLASH), object: nil)
    }
    
    @objc func updateMessageToFlash(_ sender: NSNotification) {

        assert(sender.userInfo?[NotificationCenter.MESSAGE_TO_FLASH] != nil, "Message is nil")
        assert(sender.userInfo?[NotificationCenter.MESSAGE_TO_FLASH] as! String != "", "Message is empty")
        
        guard let message = sender.userInfo?[NotificationCenter.MESSAGE_TO_FLASH] as? String else { return }
        messageToFlashlight = message
    }

    
    private func configureCellRegistration() -> UICollectionView.CellRegistration<MainCell, MainItem> {
        let cellConfig = UICollectionView.CellRegistration<MainCell, MainItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView) {
        let cellRego = self.configureCellRegistration()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, MainItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            return cell
        }
        
        diffableDataSource.apply(configureSnapshot())
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, MainItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MainItem>()
        snapshot.appendSections([.main])
        for obj in self.createItems() {
            snapshot.appendItems([obj], toSection: obj.section)
        }
        return snapshot
    }
    
    private func createItems() -> [MainItem] {
        
        var items: [MainItem] = []
        for i in FlashLightMode.allCases {
            items.append(MainItem(name: i.name, section: .main, item: i, flashlight: flashlight))
        }
        return items
    }
}
