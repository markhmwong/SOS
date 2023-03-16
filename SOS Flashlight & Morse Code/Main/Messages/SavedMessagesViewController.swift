//
//  SavedMessagesViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class SavedMessagesViewModel: NSObject {
    
    enum Section: Int {
        case main
    }
    
    var cds: CoreDataStack
    
    var mainFetcher: Fetcher<SavedMessage>! = nil
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, SavedMessage>! = nil

    
    init(cds: CoreDataStack) {
        self.cds = cds
        super.init()
    }
    
    func configureCellRegistration() -> UICollectionView.CellRegistration<SavedMessageCell, SavedMessage> {
        let cell = UICollectionView.CellRegistration<SavedMessageCell, SavedMessage> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = item.value
            content.textProperties.color = .white
            cell.contentConfiguration = content
            cell.item = item
        }
        return cell
    }
    
    func configureDataSource(collectionView: UICollectionView, fetcher: Fetcher<SavedMessage>) {
        self.mainFetcher = fetcher
        
        let cellRego = self.configureCellRegistration()
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, SavedMessage>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            
            return cell
        }
        diffableDataSource.apply(configureSnapshot())
    }
    
    func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, SavedMessage> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SavedMessage>()
        snapshot.appendSections([.main])
        if let objs = mainFetcher.fetchRequestedObjects() {
            snapshot.appendItems(objs, toSection: .main)
        }
        return snapshot
    }
    
    func deleteSavedMessage(_ savedMessage: SavedMessage) {
        self.cds.deleteFromSavedMessage(savedMessage)
        self.cds.saveContext()
        //delete from data source
        self.deleteFromDataSource(savedMessage)
    }
    
    func deleteFromDataSource(_ item: SavedMessage) {
        var snapshot = self.diffableDataSource.snapshot()
        snapshot.deleteItems([item])
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

class SavedMessagesViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView! = nil
    
    private var vm: SavedMessagesViewModel
    
    private var coordinator: MainCoordinator
    
    private lazy var fetchedResultsController: NSFetchedResultsController<SavedMessage> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date < %d", argumentArray: [Date().addingTimeInterval(0)])

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.vm.cds.moc!, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var mainFetcher: Fetcher<SavedMessage>! = nil
    
    init(vm: SavedMessagesViewModel, coordinator: MainCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground
        let layout = UICollectionViewLayout().createCollectionViewListWithSwipe(appearance: .insetGrouped, swipe: { [weak self] indexPath in
            
            guard let self = self else { return nil }
            
            let actionHandler: UIContextualAction.Handler = { action, view, completion in
                completion(true)
                let cell = self.collectionView.cellForItem(at: indexPath) as! SavedMessageCell
                guard let item = cell.item else { return }
                WarningBox.showDeleteBox(title: "Delete the message?", message: "", vc: self) {
                    self.vm.deleteSavedMessage(item)
                }
            }

            let action = UIContextualAction(style: .destructive, title: "Done!", handler: actionHandler)
            action.image = UIImage(systemName: "trash")
            action.backgroundColor = .systemRed.adjust(by: 10)
            return UISwipeActionsConfiguration(actions: [action])
        })
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
    }
    
    
    deinit {
        mainFetcher = nil
        collectionView = nil
    }
}

/*
 
 MARK: Cell
 
 */
class SavedMessageCell: UICollectionViewListCell {
    
    var item: SavedMessage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
}
