//
//  States.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 8/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

// Concrete States
struct Idle: State {
	let stateName: String = "Idle"
	
	func enter(_: MorseCodeStateMachineSystem) {
		
	}
	
	func characterExists(exists: Bool) -> Transition? {
		if exists {
			return Transition(targetState: Read())
		} else {
			// loop?
			return Transition(targetState: End())
		}
	}	
}

// Read state, put the machine into read only mode, reading the next character in the string
struct Read: State {
	let stateName: String = "Read"
	func character(type: MorseTypeTiming) -> Transition? {
		//duration
		return Transition(targetState: Flash())
	}
}

// A break to help determine and classify one character
struct Break: State {
	let stateName: String = "Break"

	func characterExists(exists: Bool) -> Transition? {
		// turn /off light
		if exists {
			return Transition(targetState: Read())
		} else {
			return Transition(targetState: Idle())
		}
	}
}

// A state to toggle the flash
struct Flash: State {
	let stateName: String = "Flash"

	func flashWithMorse(type: MorseTypeTiming) -> Transition? {
		return Transition(targetState: Break())
	}
}

// Completion State and end of timer
struct End: State {
	let stateName: String = "End"
	func exit(_: MorseCodeStateMachineSystem) {
		// this should be end
	}
	func end() {
		// Do nothing
	}
}
