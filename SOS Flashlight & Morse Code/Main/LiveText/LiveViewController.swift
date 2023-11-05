//
//  LiveViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 21/10/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

extension LiveViewController: MorseStateMachineSystemViewDelegate {
	func forwardStringTohighlight(string: String) {
		liveText.animate(searchText: string, viewController: self)
		print("animate")
	}
}

// contains the animated text view and control set
class LiveViewController: UIViewController {
	
	var stateMachine: MorseCodeStateMachineSystem? = nil {
		didSet {
			stateMachine?.viewDelegate = self
//			staticLiveText.text = stateMachine?.morseParser.messageStr
		}
	}
	
	lazy var staticLiveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .cyan
		label.backgroundColor = .black
		label.layer.opacity = 0.4 // initial opacity to show it has not been converted by the parser
		return label
	}()
	
	lazy var liveText: UITextView = {
		let label = UITextView()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "SOS"
		label.textColor = .white
		label.backgroundColor = .black
		label.layer.opacity = 0.4 // initial opacity to show it has not been converted by the parser
		return label
	}()
	
//	// live text view
//	lazy var liveTextView: LiveAnimatedTextViewController = {
//		let vc = LiveAnimatedTextViewController(viewModel: viewModel)
//		vc.view.translatesAutoresizingMaskIntoConstraints = false
//		return vc
//	}()
	
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
		self.view.backgroundColor = .red

		view.addSubview(staticLiveText)
		view.addSubview(liveText)
		
		
		liveText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		liveText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		liveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:100).isActive = true
		liveText.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		NSLayoutConstraint.activate([
			staticLiveText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			staticLiveText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			staticLiveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
			staticLiveText.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
		])
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(removeHighlightedViews), name: Notification.Name(NotificationCenter.NCKeys.END_STATE), object: nil)
	}
	
	@objc func updateLabel(_ notification: Notification) {
		if let text = notification.userInfo?["updatedText"] as? String {
			print("received \(text)")
			liveText.animate(searchText: text, viewController: self)
		}
	}
	
	@objc func removeHighlightedViews(_ notification: Notification) {
		for view in self.highlightViews {
			view.removeFromSuperview()
		}
		self.highlightViews.removeAll()
	}
	
	deinit {
		self.highlightViews = []
		NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationCenter.NCKeys.TRACKED_CHARACTERS), object: nil)
	}
}

extension UITextView {
	
	func animate(searchText: String, viewController: LiveViewController) {
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
		
		print("\(selectionRects(for: textRange).count)")
		
		selectionRects(for: textRange).forEach { selectionRect in
			guard let snapshotView = resizableSnapshotView(from: selectionRect.rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
			
			snapshotView.frame = viewController.view.convert(selectionRect.rect, from: self)
			snapshotView.alpha = 0.0
			snapshotView.backgroundColor = .blue
			viewController.view.addSubview(snapshotView)
			viewController.highlightViews.append(snapshotView)

			UIView.animate(withDuration: 0.4, delay: 1, options: [.curveEaseInOut, .allowAnimatedContent], animations: {

				snapshotView.alpha = 1.0

			}, completion: { _ in			})
		}
		
		
	}
}