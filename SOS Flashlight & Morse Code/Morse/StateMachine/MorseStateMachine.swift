//
//  MorseStateMachine.swift
//  SOS Flightlight & Morse Code
//
//  Created by Mark Wong on 7/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation




class MorseStateMachineSystem {
	private var currState: String = ""
	// Timer variables
	private var timer: Timer?
	
	private var timeRemaining: TimeInterval = 0.0
	
	// State Machine variables
	private var state: State
	
	private var morseParser: MorseParser
	
	private var delegate: MorseStateMachineSystemDelegate
	
	private var expires: Date?
	
	private var c: MorseType // characterType
	
	private var loopState: Bool = true
	
	init(morseParser: MorseParser, delegate: MorseStateMachineSystemDelegate) {
		self.morseParser = morseParser
		self.delegate = delegate
		c = .none
		state = Idle()
    }
	
	// begin
	func startSystemAtIdle() {
		delegate.start()
		c = morseParser.readNextCharacter()
		reviseTime(time: c.unitTime)
		self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
		
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
		timer?.invalidate()
		timer = nil
	}
	
	private func process(transition: Transition?) {
//		print("transition \(transition)")
        guard let transition = transition else { return }
        state.exit(self)
		transition.effect?(self)
		state = transition.targetState
        state.enter(self)
    }
	
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
				// loop
				if (loopState) {
					delegate.willLoop()
					morseParser.reinstateMessage()
					startSystemAtIdle()
					print("\(c)")
				} else {
					// end
					end()
					delegate.didEnd()
				}
			} else {

				morseParser.popCharacter()
				characterExists()
				c = morseParser.readNextCharacter()
				reviseTime(time: c.unitTime)
				
//				print("Next letter")
//				print(morseParser.convertedMessage, c.unitTime)
//				print(c)
			}

		} else {
			
		}
	}
	
	// calculates period for a flash/break
	func reviseTime(time: TimeInterval) {
		expires = Date().addingTimeInterval(time)
	}
	
}



