//
//  RecentMessagesViewModel.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 9/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

class RecentMessagesViewModel: NSObject {
	
	enum Section: Int {
		case main
	}
	
	var cds: CoreDataStack
	
	var mainFetcher: Fetcher<Recent>! = nil
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Recent>! = nil
	
	
	init(cds: CoreDataStack) {
		self.cds = cds
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(saveMessage), name: .saveMesage, object: nil)
	}
	
	@objc func saveMessage(_ notification: Notification) {
		if let r = notification.object as? Recent {
			//check if the message already exists
			if !cds.checkMessageExistence(with: r) {
				guard let moc = cds.moc else { return }
				
				let s = SavedMessage(context: moc)
				s.value = r.value
				s.date = r.date
				s.id = r.id
				self.cds.saveContext()
			} else {
#if DEBUG
				print("Already exists")
#endif
			}
		} else {
			fatalError("Recent does not exist")
		}
	}
	
	func configureCellRegistration() -> UICollectionView.CellRegistration<RecentMessageCell, Recent> {
		let cell = UICollectionView.CellRegistration<RecentMessageCell, Recent> { (cell, indexPath, item) in
			var content = UIListContentConfiguration.subtitleCell()
			content.text = item.value
			content.textProperties.color = .defaultText
			cell.contentConfiguration = content
			cell.item = item
		}
		return cell
	}
	
	func configureDataSource(collectionView: UICollectionView, fetcher: Fetcher<Recent>) {
		self.mainFetcher = fetcher
		
		let cellRego = self.configureCellRegistration()
		
		diffableDataSource = UICollectionViewDiffableDataSource<Section, Recent>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
			
			return cell
		}
		diffableDataSource.apply(configureSnapshot())
	}
	
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, Recent> {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Recent>()
		snapshot.appendSections([.main])
		if let objs = mainFetcher.fetchRequestedObjects() {
			print(objs.count)
			snapshot.appendItems(objs, toSection: .main)
		}
		return snapshot
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.saveMesage, object: nil)
	}
}
