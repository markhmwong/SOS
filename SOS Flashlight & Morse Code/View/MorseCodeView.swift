//
//  MorseCordeView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 11/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum MorseCodeMode: Int, CaseIterable {
	case kSos
	case kMessage
	case kConversion
	case kSwitch
	case kHold
}

class MorseCodeView: UIView, UITextFieldDelegate {
	// top container
	lazy var topContainer: TopContainer = {
		let view = TopContainer(viewController: viewController)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// bottom container
	lazy var bottomContainer: BottomContainer = {
		let view = BottomContainer(viewModel: viewModel, viewController: viewController)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private weak var viewModel: ViewControllerViewModel?
	
	private weak var viewController: ViewController?
	
	init(viewModel: ViewControllerViewModel, viewController: ViewController) {
		self.viewModel = viewModel
		self.viewController = viewController
		super.init(frame: .zero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		// to dismiss the keyboard
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTopContainerTapGesture))
		tapGesture.numberOfTapsRequired = 1
		tapGesture.numberOfTouchesRequired = 1
		topContainer.addGestureRecognizer(tapGesture)
		addSubview(topContainer)
		addSubview(bottomContainer)
		
		topContainer.setupView()
		bottomContainer.setupView()
		backgroundColor = Theme.Dark.primary

	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		// top container area
		topContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		topContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		topContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
		topContainer.heightAnchor.constraint(equalToConstant: bounds.height / 1.3).isActive = true
		
		// bottom container area
		bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
		bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	
	@objc func handleTopContainerTapGesture() {
		if (topContainer.messageField.isFirstResponder) {
			topContainer.retireKeyboardForMessageField()
			viewModel?.message = topContainer.messageField.text ?? ""
		}
	}
}
