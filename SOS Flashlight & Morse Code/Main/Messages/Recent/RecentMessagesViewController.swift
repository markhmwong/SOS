//
//  SavedMessagesViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class RecentMessagesViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView! = nil
    
    private var vm: RecentMessagesViewModel
    
    private var coordinator: MainCoordinator
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Recent> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Recent> = Recent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date < %d", argumentArray: [Date().addingTimeInterval(0)])

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.vm.cds.moc!, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var mainFetcher: Fetcher<Recent>! = nil
    
    init(vm: RecentMessagesViewModel, coordinator: MainCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent Messages"
        view.backgroundColor = .mainBackground
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createCollectionViewListWithSwipe(appearance: .insetGrouped, swipe: { indexPath in
            return nil
        }))
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        mainFetcher = Fetcher(controller: fetchedResultsController)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        vm.configureDataSource(collectionView: collectionView, fetcher: mainFetcher)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! RecentMessageCell
		guard let message = cell.item?.value else {
			return
		}
		NotificationCenter.default.post(name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil, userInfo: [NotificationCenter.NCKeys.MESSAGE_TO_FLASH : message])
		self.coordinator.dismiss()
    }
    
    
    deinit {
        mainFetcher = nil
        collectionView = nil
    }
}
