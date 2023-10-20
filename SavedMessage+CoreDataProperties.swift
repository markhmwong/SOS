//
//  SavedMessage+CoreDataProperties.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMessage> {
        return NSFetchRequest<SavedMessage>(entityName: "SavedMessage")
    }

    @NSManaged public var value: String?
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?

}

extension SavedMessage : Identifiable {

}
