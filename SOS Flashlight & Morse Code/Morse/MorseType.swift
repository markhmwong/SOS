//
//  MorseType.swift
//  SOS Flightlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

enum MorseType {
	case dot
	case dash
	case none
	case breakBetweenPartsOfLetter
	case breakBetweenLetters
	case breakBetweenWords
	
	var letter: Character {
		switch self {
			case .dash:
				return "-"
			case .dot:
				return "."
			case .none:
				return " "
			case .breakBetweenPartsOfLetter:
				return "æ"
			case .breakBetweenLetters:
				return "ç"
			case .breakBetweenWords:
				return "α"
		}
	}
	
	// unit of time
	private static var oneUnit: TimeInterval = 0.15
	
	// time duration of a dot
	var unitTime: TimeInterval {
		switch self {
			case .dot:
				return MorseType.oneUnit
			case .dash:
				return MorseType.oneUnit * 3
			case .none:
				return MorseType.oneUnit
			case .breakBetweenPartsOfLetter:
				return MorseType.oneUnit
			case .breakBetweenLetters:
				return MorseType.oneUnit * 3
			case .breakBetweenWords:
				return MorseType.oneUnit * 7
		}
	}
}
