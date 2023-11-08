//
//  UITextView+Animate.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 8/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

extension UITextView {
	
	func animateFullTextWithColour(searchText: String, colour: UIColor = UIColor.systemOrange) {
		let beginning = beginningOfDocument
		
		guard
			let string = text,
			let range = string.range(of: searchText),
			let start = position(from: beginning, offset: string.distance(from: string.startIndex, to: range.lowerBound)),
			let end = position(from: beginning, offset: string.distance(from: string.startIndex, to: range.upperBound)),
			let textRange = textRange(from: start, to: end)
		else {
			return
		}
		let location = offset(from: beginningOfDocument, to: textRange.start)
		let length = offset(from: textRange.start, to: textRange.end)
		let nsRange = NSRange(location: location, length: length)
		
		// get the string from the label attributedText
		let stringCopy: NSMutableAttributedString = self.attributedText.mutableCopy() as! NSMutableAttributedString
		stringCopy.addAttribute(.foregroundColor, value: UIColor.clear, range: nsRange)
		
		UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
			self.attributedText = stringCopy
		}, completion: { _ in
			stringCopy.addAttribute(.foregroundColor, value: colour, range: nsRange)
			UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
				self.attributedText = stringCopy
			})
		})
	}
	
	func animateNextLetterWithColour(searchText: String, colour: UIColor = UIColor.systemOrange) {
		let beginning = beginningOfDocument
		
		guard
			let string = text,
			let range = string.range(of: searchText),
			let start = position(from: beginning, offset: string.distance(from: string.startIndex, to: range.upperBound) - 1),
			let end = position(from: beginning, offset: string.distance(from: string.startIndex, to: range.upperBound)),
			let textRange = textRange(from: start, to: end)
		else {
			return
		}
		let location = offset(from: beginningOfDocument, to: textRange.start)
		let length = offset(from: textRange.start, to: textRange.end)
		let nsRange = NSRange(location: location, length: length)
		
		
		let stringCopy = self.attributedText.mutableCopy() as! NSMutableAttributedString
		stringCopy.addAttribute(.foregroundColor, value: UIColor.clear, range: nsRange)
		
		UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
			self.attributedText = stringCopy
		}, completion: { _ in
			stringCopy.addAttribute(.foregroundColor, value: colour, range: nsRange)
			UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
				self.attributedText = stringCopy
			})
		})
	}
}
