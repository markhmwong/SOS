//
//  Delegate.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 9/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

typealias MorseCode = String
typealias Letter = Character

protocol MorseStateMachineSystemDelegate {
	func start()
	func willBreak()
	func willFlash(type: MorseType)
	func didFlash(type: MorseType)
	func didEnd()
	func willLoop()
}

typealias State = Events & Activities

struct Transition {
	var targetState: State
	var effect: Effect?
	
	typealias Effect = (MorseStateMachineSystem) -> ()
}

protocol Events {
	var stateName: String { get }
	
	mutating func flashWithMorse(type: MorseType) -> Transition?
	mutating func characterExists(exists: Bool) -> Transition?
	mutating func character(type: MorseType) -> Transition?
	mutating func begin() -> Transition?
	mutating func end() -> Transition?
	mutating func loop() -> Transition?
}

protocol Activities {
    func enter(_: MorseStateMachineSystem)
    func exit(_: MorseStateMachineSystem)
}

extension Events {
	mutating func begin() -> Transition? {
		return nil
	}
	
	mutating func flashWithMorse(type: MorseType) -> Transition? {
		return nil
	}
	
	mutating func characterExists(exists: Bool) -> Transition? {
		return nil
	}
	
	mutating func character(type: MorseType) -> Transition? {
		return nil
	}
	
	mutating func end() -> Transition? {
		return nil
	}
	
	mutating func loop() -> Transition? {
		return nil
	}
}

extension Activities {
    func enter(_: MorseStateMachineSystem) {}
    func exit(_: MorseStateMachineSystem) {}
}
