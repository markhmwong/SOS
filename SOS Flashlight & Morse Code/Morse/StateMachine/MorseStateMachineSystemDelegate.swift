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

typealias State = Events & Activities

struct Transition {
    
	var targetState: State
    
	var effect: Effect?
	
	typealias Effect = (MorseCodeStateMachineSystem) -> Void
}

// Triggers at certain parts of the State Machine. This might seem it supercedes the State Machine itself, in the manner that it tracks the machine as it plays out, however this tracking/series of delegate methods is necessary to interface with the viewcontroller and in turn update the view.
protocol MorseStateMachineSystemDelegate {
    
	func start()
    
	func willBreak()
    
	func willFlash(type: MorseTypeTiming)
    
	func didFlash(type: MorseTypeTiming)
    
	func didEnd()
    
	func willLoop()
    
}

protocol Events {
	var stateName: String { get }
	
	mutating func flashWithMorse(type: MorseTypeTiming) -> Transition?
	mutating func characterExists(exists: Bool) -> Transition?
	mutating func character(type: MorseTypeTiming) -> Transition?
	mutating func begin() -> Transition?
	mutating func end() -> Transition?
	mutating func loop() -> Transition?
}

extension Events {
	mutating func begin() -> Transition? {
		return nil
	}
	
	mutating func flashWithMorse(type: MorseTypeTiming) -> Transition? {
		return nil
	}
	
	mutating func characterExists(exists: Bool) -> Transition? {
		return nil
	}
	
	mutating func character(type: MorseTypeTiming) -> Transition? {
		return nil
	}
	
	mutating func end() -> Transition? {
		return nil
	}
	
	mutating func loop() -> Transition? {
		return nil
	}
}

protocol Activities {
	func enter(_: MorseCodeStateMachineSystem)
	func exit(_: MorseCodeStateMachineSystem)
}

extension Activities {
    func enter(_: MorseCodeStateMachineSystem) {}
    func exit(_: MorseCodeStateMachineSystem) {}
}
