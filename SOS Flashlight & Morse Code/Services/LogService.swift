//
//  LogService.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 24/3/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
