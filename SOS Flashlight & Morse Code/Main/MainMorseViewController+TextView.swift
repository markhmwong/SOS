//
//  MainMorseViewController+TextView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 8/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

extension MainMorseViewController: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		// Define your character limit
		let characterLimit = 100
		
		// Get the current text
		guard let currentText = textView.text else {
			return true
		}
		
		// Calculate the new text if the replacement is allowed
		let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
		
		// Ensure the text length doesn't exceed the character limit
		if newText.count > characterLimit {
			return false
		}
		
		// Define a regular expression pattern for English letters only
		let pattern = "^[a-zA-Z ]*$"
		
		// Check if the replacement text matches the pattern (only English letters)
		if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
			let range = NSRange(location: 0, length: newText.utf16.count)
			if regex.firstMatch(in: newText, options: [], range: range) == nil {
				return false
			}
		} else {
			return false
		}
		
		return true
	}
}

