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
    
    enum SystemMode: Int, CaseIterable {
        case sos = 0
        case encodeMorse // english to morse conversion
        case decodeMorse // morse to english conversion
        case tools // quick tools
        
        var name: String {
            switch self {
            case .sos:
                return "sos"
            case .encodeMorse:
                return "message conversion"
            case .decodeMorse:
                return "morse conversion"
            case .tools:
                return "tools"
            }
        }
    }
    

    
    var dismissFlag: Bool = false
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, SystemModeItem>! = nil

    var mainMorseViewController: MainMorseViewController! = nil
    
    let flashlight = Flashlight()
    
    var sosLock: Bool = false
    
    // used for custom morse message to delivery via the flash light
    var messageToBeSignalled: String = ""

    var loopState: Bool = false
    
    var buttonToggleState: Bool = true {
        didSet {
            mainMorseViewController.mainToggleButton.isEnabled = buttonToggleState
            mainMorseViewController.mainToggleButton.alpha = mainMorseViewController.mainToggleButton.isEnabled ? 1.0 : 0.1
        }
    }


    private var currIndex: Int
    
    var nc = NotificationCenter.default
    
    var cds: CoreDataStack
    
    init(cds: CoreDataStack) {
        self.cds = cds
        self.currIndex = 0
        super.init()
		nc.addObserver(self, selector: #selector(updateMessageToSignal), name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil)
    }
	
	func updateIndicator(on: Bool, vc: LightIndicatorViewController) {
		vc.indicatorState(on: on)
	}
    
    @objc func updateMessageToSignal(_ sender: NSNotification) {
        #if DEBUG
		assert(sender.userInfo?[NotificationCenter.NCKeys.MESSAGE_TO_FLASH] != nil, "Message is nil")
//		assert(sender.userInfo?[NotificationCenter.NCKeys.MESSAGE_TO_FLASH] as! String != "", "Message is empty")
        #endif
		guard let message = sender.userInfo?[NotificationCenter.NCKeys.MESSAGE_TO_FLASH] as? String else { return }
        messageToBeSignalled = message
    }
	
	func updateFrontScreenFlash(state: Bool, vc: FrontFacingLcdViewController) {
		if state {
			UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
				vc.on()
			}
		} else {
			UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
				vc.off()
			}
		}
	}

    private func configureCellRegistration() -> UICollectionView.CellRegistration<MainCell, SystemModeItem> {
        let cellConfig = UICollectionView.CellRegistration<MainCell, SystemModeItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView) {
        let cellRego = self.configureCellRegistration()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, SystemModeItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            return cell
        }
        
        diffableDataSource.apply(configureSnapshot())
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, SystemModeItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SystemModeItem>()
        snapshot.appendSections([.main])
        for obj in self.createItems() {
            snapshot.appendItems([obj], toSection: obj.section)
        }
        return snapshot
    }
    
    private func createItems() -> [SystemModeItem] {
        
        var items: [SystemModeItem] = []
        for i in SystemMode.allCases {
            items.append(SystemModeItem(name: i.name, section: .main, item: i, flashlight: flashlight))
        }
        return items
    }
	
	deinit {
		self.nc.removeObserver(self, name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil)
	}
}
