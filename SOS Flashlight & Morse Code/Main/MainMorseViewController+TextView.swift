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
		// Get the current text and calculate the new text if the replacement is allowed
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		
		let currentText = textView.text ?? ""
		let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
		
		// Set your character limit here (e.g., 100 characters)
		let characterLimit = 100
		
		// Check if the new text exceeds the character limit
		if newText.count <= characterLimit {
			return true // Allow the text change
		} else {
			// Display an alert or provide some feedback to the user
			// You can also prevent further text input by returning false
			print("provide alert box")
			return false
		}
	}
}

