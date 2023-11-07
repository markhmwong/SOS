//
//  LiveViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 21/10/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

extension LiveTextViewController: MorseStateMachineSystemViewDelegate {
	func forwardStringTohighlight(string: String) {
		// fix this. use this instead of KVO TRACKED_CHARACTERS
//		liveText.animateNextLetterWithColour(searchText: text)
		print("animate")
	}
}

// contains the animated text view and control set
class LiveTextViewController: UIViewController {
	
	var stateMachine: MorseCodeStateMachineSystem? = nil {
		didSet {
			stateMachine?.viewDelegate = self
//			staticLiveText.layer.opacity = 0.7
			liveText.layer.opacity = 1.0
//			staticLiveText.text = stateMachine?.morseParser.messageStr
		}
	}
	
	lazy var staticLiveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .orange
		label.backgroundColor = .clear
		label.layer.opacity = 1.0 // initial opacity to show it has not been converted by the parser
		label.textAlignment = .center
		return label
	}()
	
	lazy var liveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .black
		label.backgroundColor = .clear
		label.layer.opacity = 1.0 // initial opacity to show it has not been converted by the parser
		label.textAlignment = .center
		return label
	}()
	
	var viewModel: MainMorseViewModel
	
	var highlightViews: [UIView]
	
	init(viewModel: MainMorseViewModel) {
		self.viewModel = viewModel
		self.highlightViews = []
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// bottom drawer for functionality
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.translatesAutoresizingMaskIntoConstraints = false
		self.view.backgroundColor = .clear

		view.addSubview(staticLiveText)
		view.addSubview(liveText)
		
		
		liveText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		liveText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		liveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
		liveText.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		NSLayoutConstraint.activate([
			staticLiveText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			staticLiveText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			staticLiveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
			staticLiveText.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
		])
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(tidyUpHighlightViews), name: Notification.Name(NotificationCenter.NCKeys.END_STATE), object: nil)
	}
	
	@objc func updateLabel(_ notification: Notification) {
		if let text = notification.userInfo?["updatedText"] as? String {
			print("received \(text)")
			liveText.animateNextLetterWithColour(searchText: text)
		}
	}
	
	@objc func tidyUpHighlightViews(_ notification: Notification) {
		// fade out views
//		for (index, view) in self.highlightViews.enumerated() {
//			UIView.animate(withDuration: 2.0) {
//				view.layer.opacity = 0
//			} completion: { state in
//
//			}
//			
//			// delay the removed views
//			if self.highlightViews.count == index {
//				// remove views
//				
//				for view in self.highlightViews {
//					view.removeFromSuperview()
//				}
//				self.highlightViews.removeAll()
//			}
//		}
		
		liveText.animateFullTextWithColour(searchText: staticLiveText.text, colour: UIColor.defaultBlack)

	}
	
	deinit {
		self.highlightViews = []
		NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
	}
}

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

extension UITextInput {
	var selectedRange: NSRange? {
		guard let range = selectedTextRange else { return nil }
		let location = offset(from: beginningOfDocument, to: range.start)
		let length = offset(from: range.start, to: range.end)
		return NSRange(location: location, length: length)
	}
}
