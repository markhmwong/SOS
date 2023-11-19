//
//  MorseStateMachine.swift
//  SOS Flightlight & Morse Code
//
//  Created by Mark Wong on 7/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

class MorseCodeStateMachineSystem {
	// Private variables
	private var currState: String = ""
	
	// Timer variables
	private	let unitTime = 0.01

	private var timer: Timer?
	
	private var timeRemaining: TimeInterval = 0.0
	
	// State Machine variables
	private var state: State
	
	private(set) var morseParser: MorseParser
	
	private var delegate: MorseStateMachineSystemDelegate
	
	// expose it
	var viewDelegate: MorseStateMachineSystemViewDelegate? = nil
	
	private var expires: Date?
	
	private var c: MorseTypeTiming // characterType
	
	private var parsedCharacters: String
	
	// Public variable
	var loopState: Bool = false
	
	init(morseParser: MorseParser, delegate: MorseStateMachineSystemDelegate, viewDelegate: MorseStateMachineSystemViewDelegate? = nil) {
		self.morseParser = morseParser
		self.delegate = delegate
		self.viewDelegate = viewDelegate
		c = .none
		parsedCharacters = ""
		state = Idle()
    }
	
	// begin
	func startSystemAtIdle() {
		delegate.start()
		c = morseParser.readAndConvertNextCharacter()
		reviseTime(time: c.unitTime)
		// nil timer
		self.timer = Timer.scheduledTimer(timeInterval: unitTime, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
		process(transition: state.characterExists(exists: morseParser.isEndOfMessage()))
	}
	
	func characterExists() {
		process(transition: state.characterExists(exists: morseParser.isEndOfMessage()))
	}
	
	func characterType() {
		process(transition: state.character(type: c))
	}
	
	// effect
	func flashWithMorse() {
		delegate.willFlash(type: c)
		process(transition: state.flashWithMorse(type: c))
	}
	
	func end() {
		process(transition: state.end())
		// end timer
		endTimer()
		NotificationCenter.default.post(name: Notification.Name(NotificationCenter.NCKeys.END_STATE), object: nil)
		print("End Timer")
	}
	
	// flush timer
	func endTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	private func process(transition: Transition?) {
		guard let transition = transition else { return }
        state.exit(self)
		transition.effect?(self)
		state = transition.targetState
        state.enter(self)
    }
	
	// Main loop of the state machine
	@objc func fireTimer() {
		guard let expires = self.expires else { return }
		timeRemaining = expires.timeIntervalSince(Date())
		
		characterType() // Read - enters Flash state
		
		flashWithMorse() // Flash - will enters Break state
		
		// read next letter
		if (timeRemaining <= 0.0) {
			// time - whether dot or dash
			
			if (c == .dash || c == .dot) {
				delegate.didFlash(type: c)
			}
			
			if (c == .none) {
				// user triggers loop
				if (loopState) {
					delegate.willLoop()
					morseParser.reinstateMessage()
					startSystemAtIdle()
				} else {
					// otherwise end the state machine
					end()
					delegate.didEnd()
				}
			} else {
				morseParser.popCharacter()
				characterExists()
				c = morseParser.readAndConvertNextCharacter()
				reviseTime(time: c.unitTime)
			}
		}
	}
	
	// calculates period for a flash/break
	func reviseTime(time: TimeInterval) {
		expires = Date().addingTimeInterval(time)
	}
}
