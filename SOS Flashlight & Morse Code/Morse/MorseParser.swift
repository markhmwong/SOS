//
//  Morseparser.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 8/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

// Parses the message to detect whether to flash a dot or ddash
class MorseParser: NSObject {
	
	private let message: [Character]
	
	var convertedMessage: [Character] = []
	
	init(message: String) {
		self.message = Array(message)
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
				convertedMessage.append(MorseType.breakBetweenWords.letter)
			} else {
				for morseCode in value {
					convertedMessage.append(morseCode)
					convertedMessage.append(MorseType.breakBetweenPartsOfLetter.letter) // æ denotes a break
				}
				convertedMessage.append(MorseType.breakBetweenLetters.letter)
			}
		}
	}
	
	func popCharacter() {
		convertedMessage.removeFirst()
	}
	
	// to do - return morse type
	func readNextCharacter() -> MorseType {
		// won't need the loop once we use the timer
		// we'll read the array every unit of time
		return dotOrDash(character: convertedMessage.first)
	}
	
	private func dotOrDash(character c: Character?) -> MorseType {
		guard let c = c else {
			return .none
		}
		
		switch c {
			case MorseType.dot.letter:
				return .dot
			case MorseType.dash.letter:
				return .dash
			case MorseType.breakBetweenPartsOfLetter.letter:
				return .breakBetweenPartsOfLetter
			case MorseType.breakBetweenLetters.letter:
				return .breakBetweenLetters
			case MorseType.breakBetweenWords.letter:
				return .breakBetweenWords
			case MorseType.none.letter:
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
	func removeErroneousCharacters() -> [Character] {
		return convertedMessage.filter { (ch) -> Bool in
			return ch != MorseType.breakBetweenLetters.letter
		}.filter { (ch) -> Bool in
			return ch != MorseType.breakBetweenPartsOfLetter.letter
		}.map { (ch) -> Character in
			ch == MorseType.breakBetweenWords.letter ? " " : ch
		}
	}
}
