//
//  Recent+CoreDataProperties.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Recent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recent> {
        return NSFetchRequest<Recent>(entityName: "Recent")
    }

    @NSManaged public var value: String?
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?

}

extension Recent : Identifiable {
    func newRecentObj(id: UUID = UUID(), value: String, date: Date = Date()) {
        self.value = value
        self.id = id
        self.date = date
    }
}
