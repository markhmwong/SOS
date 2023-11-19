//
//  MorseStateMachineSystemViewDelegate.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 2/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import Foundation

protocol MorseStateMachineSystemViewDelegate {
	func forwardStringTohighlight(string: String)
}
