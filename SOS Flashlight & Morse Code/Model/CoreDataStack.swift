//
//  CoreDataStack.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import CoreData

final class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    
    // create queue
    private let cdQueue = DispatchQueue(label: "com.whizbang.queue.coredata", qos: .utility)
    
    var moc: NSManagedObjectContext? = nil
    
    var backgroundContext: NSManagedObjectContext? = nil
    
    lazy var persistentContainer: NSPersistentContainer = {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.whizbang.morsecode")!
        let storeURL = containerURL.appendingPathComponent("MorseCode.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "MorseCode")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print("CDS Error: " + error.localizedDescription)
            }
        })
        return container
    }()
    
    override init() {
        super.init()
        self.moc = self.persistentContainer.viewContext
        self.moc?.automaticallyMergesChangesFromParent = true
        self.backgroundContext = self.persistentContainer.newBackgroundContext()
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        
        if let context = backgroundContext {
            // background context is supplied
            guard context.hasChanges else { return }
            
            do {
                
                // save
                try context.save()
                guard let moc = moc else { return }
                
                moc.performAndWait {
                    do {
                        try moc.save()
                        #if DEBUG
                        print("saved")
                        #endif
                    } catch {
                        print("could not save on main context")
                    }
                }
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
        } else {
            // No background context is supplied through the method parameter
            guard let moc = moc else { return }
            moc.perform {
                do {
                    #if DEBUG
                    print("saved")
                    #endif
                    try moc.save()
                } catch {
                    print("could not save on main context")
                }
            }
        }
    }
    
    func limitRecentMessages() {
        if let c = self.moc {
            let request: NSFetchRequest<Recent> = Recent.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                var fetchedResults = try c.fetch(request)
                if fetchedResults.count > 20 {
                    if let last = fetchedResults.popLast() {
                        c.delete(last)
                    }
                }
            } catch let error as NSError {
                fatalError("Recent entity could not be fetched or deleted \(error)")
            }
        }
    }
    
    func checkMessageExistence(with recent: Recent) -> Bool {
        if let c = self.moc {
            let request: NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id == %@", argumentArray: [recent.id!])

            do {
                let fetchedResults = try c.fetch(request)
                if !fetchedResults.isEmpty {
                    return true
                } else {
                    return false
                }
            } catch let error as NSError {
                fatalError("Recent entity could not be fetched or deleted \(error)")
            }
        }
        return false
    }
    
    func deleteFromSavedMessage(_ item: SavedMessage) {
        if let c = self.moc {
            let request: NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id!])
            do {
                let fetchedResults = try c.fetch(request)
                if !fetchedResults.isEmpty {
                    c.delete(item)
                } else {
                    fatalError("Saved Entity could not be found")
                }
            } catch let error as NSError {
                fatalError("Saved entity could not be fetched or deleted \(error)")
            }
        }
    }
}
