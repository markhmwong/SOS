//
//  MorseType.swift
//  SOS Flightlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

enum MorseTypeTiming {
	// these represents the timing between letter. Please see the unitTime property underneath to see actual timings
	case dot
	case dash
	case none
	
	case breakBetweenPartsOfLetter
	case breakBetweenLetters
	case breakBetweenWords
	
	var symbol: Character {
		switch self {
			case .dash:
				return "-"
			case .dot:
				return "."
			case .none:
				return " "
				// .<break>.<break>. -<break>-<break>-
			case .breakBetweenPartsOfLetter:
				return "æ"
				// ...<break>...
			case .breakBetweenLetters:
				return "ç"
				// ...---...<break>
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
				return MorseTypeTiming.oneUnit
			case .dash:
				return MorseTypeTiming.oneUnit * 3
			case .none:
				return MorseTypeTiming.oneUnit
			case .breakBetweenPartsOfLetter:
				return MorseTypeTiming.oneUnit
			case .breakBetweenLetters:
				return MorseTypeTiming.oneUnit * 3
			case .breakBetweenWords:
				return MorseTypeTiming.oneUnit * 7
		}
	}
}
