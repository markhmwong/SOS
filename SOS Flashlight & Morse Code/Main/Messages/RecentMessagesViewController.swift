//
//  SavedMessagesViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

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
            content.textProperties.color = .white
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
//        NotificationCenter.default.removeObserver(self, forKeyPath: .saveMessage)
    }
}

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
        
    }
    
    
    deinit {
        mainFetcher = nil
        collectionView = nil
    }
}

/*
 
 MARK: Cell
 
 */
class RecentMessageCell: UICollectionViewCell {
    
    var item: Recent? = nil {
        didSet {
            self.configure()
        }
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveMessage), for: .touchDown)
        return button
    }()
    
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
    
    private func configure() {
        addSubview(self.addButton)
        
        addButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true

    }
    
    @objc func saveMessage() {
        NotificationCenter.default.post(name: .saveMesage, object: item)
    }
}
