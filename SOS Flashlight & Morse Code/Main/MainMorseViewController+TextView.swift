//
//  MainMorseViewController+TextView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 8/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

extension MainMorseViewController: UITextViewDelegate {
	
	@objc func handleRecentButton() {
		NotificationCenter.default.post(name: .showRecentMessages, object: nil)
	}
	
	// button above keyboard
	@objc func handleEndEditing() {
		messageField.resignFirstResponder()
		// assign viewmodel.messagetoflash
		NotificationCenter.default.post(name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil, userInfo: [NotificationCenter.NCKeys.MESSAGE_TO_FLASH : messageField.text ?? ""])
	}
	
	@objc func handleSave() {
		print("save - to do")
	}
	
	@objc func handleClear() {
		messageField.text = ""
		// assign viewmodel.messagetoflash
	}
	
	func messageToolbar() {
		let keyboardToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
		let clearButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .done, target: self, action: #selector(handleClear))
		clearButton.tintColor = UIColor.defaultText
		
		let doneButton = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .done, target: self, action: #selector(handleEndEditing))
		doneButton.tintColor = UIColor.defaultText
		
		// do save button later just keep recents
//		let saveButton =  UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .done, target: self, action: #selector(handleSave))
//		saveButton.tintColor = UIColor.defaultText
		
		let recentButton =  UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(handleRecentButton))
		recentButton.tintColor = UIColor.defaultText
		
		let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
		fixedSpaceItem.width = 10
		
		keyboardToolbar.items = [
			clearButton,
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
			recentButton,
			fixedSpaceItem,
			//saveButton,
			//fixedSpaceItem,
			doneButton
		]
		keyboardToolbar.barStyle = .default
		messageField.inputAccessoryView = keyboardToolbar
	}
	
	func textViewDidChange(_ textView: UITextView) {
		NotificationCenter.default.post(name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil, userInfo: [NotificationCenter.NCKeys.MESSAGE_TO_FLASH : messageField.text ?? ""])
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
//		textMessage = textView.text
	}
	
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

