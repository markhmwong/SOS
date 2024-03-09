//
//  MorseCodeTree.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 17/12/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import Foundation

class TreeNode {
	var value: String
	var left: TreeNode?
	var right: TreeNode?
	
	init(_ value: String) {
		self.value = value
		self.left = nil
		self.right = nil
	}
}

class MorseCodeTree {
	var root: TreeNode
	
	init() {
		// Root node with an empty value
		self.root = TreeNode("")
		createMorseCodeTree()
	}
	
	private func insert(_ morseCode: String, _ letter: String) {
		var current = root
		
		for char in morseCode {
			if char == "." {
				if let left = current.left {
					current = left
				} else {
					current.left = TreeNode("")
					current = current.left!
				}
			} else if char == "-" {
				if let right = current.right {
					current = right
				} else {
					current.right = TreeNode("")
					current = current.right!
				}
			}
		}
		
		current.value = letter
	}
	
	private func createMorseCodeTree() {
		let morseToEnglish: [String: String] = [
			".-": "A", "-...": "B", "-.-.": "C", "-..": "D", ".": "E",
			"..-.": "F", "--.": "G", "....": "H", "..": "I", ".---": "J",
			"-.-": "K", ".-..": "L", "--": "M", "-.": "N", "---": "O",
			".--.": "P", "--.-": "Q", ".-.": "R", "...": "S", "-": "T",
			"..-": "U", "...-": "V", ".--": "W", "-..-": "X", "-.--": "Y",
			"--..": "Z", "-----": "0", ".----": "1", "..---": "2",
			"...--": "3", "....-": "4", ".....": "5", "-....": "6",
			"--...": "7", "---..": "8", "----.": "9"
			// Add more Morse code mappings as needed
		]
		
		for (morseCode, letter) in morseToEnglish {
			insert(morseCode, letter)
		}
	}
	
	func translateMorseToEnglish(morse: String) -> String {
		var current = root
		var result = ""
		
		for char in morse {
			if char == "." {
				if let left = current.left {
					current = left
				}
			} else if char == "-" {
				if let right = current.right {
					current = right
				}
			} else if char == " " {
				result += current.value
				current = root
			}
		}
		
		result += current.value
		
		return result
	}
}
