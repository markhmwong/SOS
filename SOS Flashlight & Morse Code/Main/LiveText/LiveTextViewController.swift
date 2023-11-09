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
		label.isEditable = false
		return label
	}()
	
	lazy var liveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = UIColor.defaultText
		label.backgroundColor = .clear
		label.layer.opacity = 1.0 // initial opacity to show it has not been converted by the parser
		label.textAlignment = .center
		label.isEditable = false
		return label
	}()
	
	private var viewModel: MainMorseViewModel
	

	
	init(viewModel: MainMorseViewModel) {
		self.viewModel = viewModel

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
		
		let padding = 20.0
		liveText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
		liveText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
		liveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:padding).isActive = true
		liveText.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		NSLayoutConstraint.activate([
			staticLiveText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			staticLiveText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			staticLiveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
			staticLiveText.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
		])
		
		NotificationCenter.default.addObserver(self, selector: #selector(animateCharacters), name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(tidyUpHighlightViews), name: Notification.Name(NotificationCenter.NCKeys.END_STATE), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil)
	}
	
	@objc func updateText(_ sender: Notification) {
		guard let message = sender.userInfo?[NotificationCenter.NCKeys.MESSAGE_TO_FLASH] as? String else { return }
		updateTextFields(message: message)
	}
	
	func updateTextFields(message: String) {
		liveText.text = message
		staticLiveText.text = message
	}
	
	@objc func animateCharacters(_ notification: Notification) {
		if let text = notification.userInfo?["updatedText"] as? String {
			print("received \(text)")
			liveText.animateNextLetterWithColour(searchText: text)
		}
	}
	
	@objc func tidyUpHighlightViews() {
		liveText.animateFullTextWithColour(searchText: staticLiveText.text, colour: UIColor.defaultText)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
	}
}
