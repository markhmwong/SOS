//
//  InternationalMorseCode.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 8/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

/*
 
Conditions and Requirements of Morse Code
The length of a dot is one unit
A dash is three units
The space between parts of the same letter is one unit
The space between letters is three units
The space between words is seven units
A B
.- -...
[(1) 1 (3)] (3) [(3) 1 (1) 1 (1) 1 (1)] (7)

*/

// Letter and MorseCode typealias found in MorseStatemachineSystemDelegate.swift
let InternationalMorseCode: [Letter : MorseCode] = [
	"a" : ".-",
	"b" : "-...",
	"c" : "-.-.",
	"d" : "-..",
	"e" : ".",
	"f" : "..-.",
	"g" : "--.",
	"h" : "....",
	"i" : "..",
	"j" : ".---",
	"k" : "-.-",
	"l" : ".-..",
	"m" : "--",
	"n" : "-.",
	"o" : "---",
	"p" : ".--.",
	"q" : "--.-",
	"r" : ".-.",
	"s" : "...",
	"t" : "-",
	"u" : "..-",
	"v" : "...-",
	"w" : ".--",
	"x" : "-..-",
	"y" : "-.--",
	"z" : "--..",
	"A" : ".-",
	"B" : "-...",
	"C" : "-.-.",
	"D" : "-..",
	"E" : ".",
	"F" : "..-.",
	"G" : "--.",
	"H" : "....",
	"I" : "..",
	"J" : ".---",
	"K" : "-.-",
	"L" : ".-..",
	"M" : "--",
	"N" : "-.",
	"O" : "---",
	"P" : ".--.",
	"Q" : "--.-",
	"R" : ".-.",
	"S" : "...",
	"T" : "-",
	"U" : "..-",
	"V" : "...-",
	"W" : ".--",
	"X" : "-..-",
	"Y" : "-.--",
	"Z" : "--..",
	"1" : ".----",
	"2" : "..---",
	"3" : "...--",
	"4" : "....-",
	"5" : ".....",
	"6" : "-....",
	"7" : "--...",
	"8" : "---..",
	"9" : "----.",
	"0" : "-----",
	" " : "α",
]
