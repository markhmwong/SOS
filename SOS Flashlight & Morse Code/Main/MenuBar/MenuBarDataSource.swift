//
//  MenuBarDataSource.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MenuBarDataSource: NSObject {
    
    struct MenuItem: Hashable {
        let name: String
        let icon: String
        let section: MenuSection
        
    }
    
    enum MenuSection {
        case main
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<MenuSection, MenuItem>! = nil
    
    override init() {
        super.init()
    }
    
    private func configureCellRegistration() -> UICollectionView.CellRegistration<MenuBarCell, MenuItem> {
        let cellConfig = UICollectionView.CellRegistration<MenuBarCell, MenuItem> { (cell, indexPath, item) in
            cell.configureCell(with: item)
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView) {
        let cellRego = self.configureCellRegistration()
        diffableDataSource = UICollectionViewDiffableDataSource<MenuSection, MenuItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            cell.configureCell(with: item)
            return cell
        }
        diffableDataSource.apply(configureSnapshot())
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<MenuSection, MenuItem> {
        var snapshot = NSDiffableDataSourceSnapshot<MenuSection, MenuItem>()
        snapshot.appendSections([.main])
        for obj in self.createItems() {
            snapshot.appendItems([obj], toSection: obj.section)
        }
        return snapshot
    }
    
    private func createItems() -> [MenuItem] {
        let sosItem = MenuItem(name: "SOS", icon: "bolt.fill", section: .main)
        let messageConversionItem = MenuItem(name: "Message", icon: "message.and.waveform.fill", section: .main)
        let morseTextConversionItem = MenuItem(name: "Conversion", icon: "text.bubble.fill", section: .main)
        let cameraToolsItem = MenuItem(name: "Tools", icon: "hammer.fill", section: .main)
        
        return [sosItem, messageConversionItem, morseTextConversionItem, cameraToolsItem]
    }
}
