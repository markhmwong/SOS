//
//  SystemModeItem.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 28/3/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

struct SystemModeItem: Hashable {
    static func == (lhs: SystemModeItem, rhs: SystemModeItem) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    let name: String
    let section: MainMorseViewModel.Section
    let item: MainMorseViewModel.SystemMode
    let flashlight: Flashlight
}
