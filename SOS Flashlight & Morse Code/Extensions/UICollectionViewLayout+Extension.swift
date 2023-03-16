//
//  UICollectionViewLayout+Extension.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 18/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
    func horizontalMenuLayout(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .absolute(60.0), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //            let estimatedHeight: CGFloat = cellHeight // cell height
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: cellHeight)
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(0), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            item.contentInsets = itemSpace
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            if (header && sectionIndex == 0 && elementKind != "") {
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            
            return section
        }
        return layout
    }
    
    func fullScreenLayoutWithHorizontalBar(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .absolute(60.0), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0), menuBar: MenuBar) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: cellHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(0), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
        item.contentInsets = itemSpace
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
          items.forEach { item in
              let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2)
              let minScale: CGFloat = 1.0
              let maxScale: CGFloat = 1.0
              let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
              item.transform = CGAffineTransform(scaleX: scale, y: scale)
              
              menuBar.horizontalBarLeadingConstraint?.constant = (offset.x / 4)
          }
        }
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
    
    func createCollectionViewSectionHeaderLayout(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .absolute(60.0), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //            let estimatedHeight: CGFloat = cellHeight // cell height
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: cellHeight)
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(10), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            item.contentInsets = itemSpace
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(44))
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: TipJarViewController.sectionElementKind, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            //            if (header && sectionIndex == 0 && elementKind != "") {
            //                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
            //                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
            //                section.boundarySupplementaryItems = [header]
            //            }
            
            return section
        }
        return layout
    }
    
    func createCollectionViewListWithSwipe(appearance: UICollectionLayoutListConfiguration.Appearance, swipe: @escaping UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider) -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: appearance)
        listConfig.showsSeparators = false
        listConfig.headerMode = .none
        listConfig.headerTopPadding = 10.0
        listConfig.trailingSwipeActionsConfigurationProvider = swipe
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
