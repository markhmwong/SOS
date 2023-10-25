//
//  LiveViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 21/10/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

// contains the animated text view and control set
class LiveViewController: UIViewController {
	
	// live text view
	lazy var liveTextView: LiveAnimatedTextViewController = {
		let vc = LiveAnimatedTextViewController(viewModel: mainMorseViewModel)
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		return vc
	}()
	
	var mainMorseViewModel: MainMorseViewModel
	
	init(viewModel: MainMorseViewModel) {
		self.mainMorseViewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// bottom drawer for functionality
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .red
		self.addChild(liveTextView)
		self.view.addSubview(liveTextView.view)
		
		liveTextView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		liveTextView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		liveTextView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		liveTextView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
	}
}

// Receives text as the engine parses each letter
class LiveAnimatedTextViewController: UIViewController {
	
	var mainMorseViewModel: MainMorseViewModel
	
	lazy var liveText: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .white
		label.numberOfLines = 0
		return label
	}()
	
	init(viewModel: MainMorseViewModel) {
		self.mainMorseViewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(liveText)
		view.backgroundColor = .blue
		liveText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	
}
