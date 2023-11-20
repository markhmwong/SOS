//
//  Morseparser.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 8/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

// Parses the message to detect whether to flash a dot or ddash
// Contains the message itself
class MorseParser: NSObject {
	
	// Initial Method
	// Converts the english characters to morse code and fills in with symbols for
	// spaces, between letters, words
	// Removes the first character from the converted message
	private let message: [Character]
	
	private(set) var messageStr: String
	
	// message but in morse code
	var convertedMessage: [Character]
	
	// Tracks the character that is being read by the state machine
	// Removed characters, this should be inverse of the convertedMessage
	// This should be in english characters with the symbol in between letters
	private var trackedCharacters: String {
		didSet {
			NotificationCenter.default.post(name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil, userInfo: ["updatedText" : self.trackedCharacters])
		}
	}
	
	private var trackedIndex: Int {
		didSet {
			let substring = self.messageStr.index(self.messageStr.startIndex, offsetBy: trackedIndex)
			self.trackedCharacters = String(self.messageStr[..<substring])
		}
	}
	
	init(message: String) {
		self.messageStr = message
		self.message = Array(message)
		self.trackedIndex = 0
		self.trackedCharacters = ""
		self.convertedMessage = []
		super.init()
		convertCharacters()

	}
	
	func reinstateMessage() {
		convertCharacters()
	}
	
	// convert the message
	private func convertCharacters() {
		for c in message {
			guard let value = InternationalMorseCode[c] else { return }
			
			if value == " " {
				convertedMessage.append(MorseTypeTiming.breakBetweenWords.symbol)
			} else {
				for morseCode in value {
					convertedMessage.append(morseCode)
					convertedMessage.append(MorseTypeTiming.breakBetweenPartsOfLetter.symbol) // æ denotes a break
					
				}
				convertedMessage.append(MorseTypeTiming.breakBetweenLetters.symbol)
			}
		}
		print("converted message \(convertedMessage)")
	}
	
	func popCharacter() {
		convertedMessage.removeFirst()
	}
	
	// return the converted morse type to get the timing.
	func readAndConvertNextCharacter() -> MorseTypeTiming {
		// won't need the loop once we use the timer
		// we'll read the array every unit of time
		return dotOrDash(character: convertedMessage.first)
	}
	
	// convert letter
	private func dotOrDash(character c: Character?) -> MorseTypeTiming {
		guard let c = c else {
			return .none
		}
		
		switch c {
			case MorseTypeTiming.dot.symbol:
				return .dot
			case MorseTypeTiming.dash.symbol:
				return .dash
			case MorseTypeTiming.breakBetweenPartsOfLetter.symbol:
				return .breakBetweenPartsOfLetter
			case MorseTypeTiming.breakBetweenLetters.symbol:
				if self.trackedIndex < message.count {
					self.trackedIndex = self.trackedIndex + 1
				}
				// add to inverse characters list
				return .breakBetweenLetters
			case MorseTypeTiming.breakBetweenWords.symbol:
				return .breakBetweenWords
			case MorseTypeTiming.none.symbol:
				return .none
			default:
				return .none
		}
	}
	
	func isEndOfMessage() -> Bool {
		if convertedMessage.isEmpty {
			return false
		} else {
			return true
		}
	}
	
	// remove characters representing time for in between letters
	// these are not letters of the english language and are placed during coversion to notify the parser the correct unit of time
	// by removing these, it allows the user to see the correct message in morse code
	func removeErroneousCharacters() -> [Character] {
		return convertedMessage.filter { (ch) -> Bool in
			return ch != MorseTypeTiming.breakBetweenLetters.symbol
		}.filter { (ch) -> Bool in
			return ch != MorseTypeTiming.breakBetweenPartsOfLetter.symbol
		}.map { (ch) -> Character in
			ch == MorseTypeTiming.breakBetweenWords.symbol ? " " : ch
		}
	}
}
