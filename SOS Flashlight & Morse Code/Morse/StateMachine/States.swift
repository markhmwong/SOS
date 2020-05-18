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
	
	func enter(_: MorseStateMachineSystem) {
//		print("did enter idle state")
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

struct Read: State {
	let stateName: String = "Read"
	func character(type: MorseType) -> Transition? {
		//duration
		return Transition(targetState: Flash())
	}
}

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

struct Flash: State {
	let stateName: String = "Flash"

	func flashWithMorse(type: MorseType) -> Transition? {
		return Transition(targetState: Break())
	}
}

struct End: State {
	let stateName: String = "End"

	func end() {
//		print("end")
	}
}
