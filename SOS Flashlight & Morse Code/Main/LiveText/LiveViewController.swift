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
	
	lazy var liveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .white
		label.backgroundColor = .black
		label.layer.opacity = 0.4
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
		
		liveText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		liveText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		liveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		liveText.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.animateText()
	}
	
	func animateText() {
		guard let text = liveText.text else {
			return
		}
		

		
		liveText.animate(searchText: "S", superview: view)
	}
	
	//returns the next letter in the String
	func iterateOverEachChar(message: String) -> String {
		
		
		return ""
	}
	
}

extension UITextView {
	
	func animate(searchText: String, superview: UIView) {
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
		print("\(selectionRects(for: textRange).count)")
		selectionRects(for: textRange).forEach { selectionRect in
			guard let snapshotView = resizableSnapshotView(from: selectionRect.rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
			
			snapshotView.frame = superview.convert(selectionRect.rect, from: self)
			snapshotView.alpha = 1.0
			snapshotView.backgroundColor = .clear
			superview.addSubview(snapshotView)
			
			UIView.animate(withDuration: 1, delay: 1, options: .autoreverse, animations: {
//				snapshotView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
				snapshotView.alpha = 1.0
			}, completion: { _ in
//				snapshotView.removeFromSuperview()
			})
		}
		
		
	}
}
