//
//  SeizureWarningViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 26/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SeizureWarningViewController: UIViewController {
	
	lazy var warningTitle: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Photosensitive Seizure Warning"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.text = "This app contains flashing lights using the rear camera and front screen. Please stop using this app and consult a doctor if you experience lightheadedness, altered vision, eye or face twitching, jerking or shaking of arms or legs, or basically anything that you shouldn't normally experience; contrary to popular beliefs, these are not symptoms for utter joy but of photosensitive epileptic seizures. Be careful, it's serious."
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var dismissButton: UIButton = {
		if #available(iOS 15.0, *) {
			var buttonConfig = UIButton.Configuration.filled()
			buttonConfig.titleAlignment = .center
			buttonConfig.attributedTitle = AttributedString("Continue", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.defaultBlack]))
			buttonConfig.background.cornerRadius = 10.0
			buttonConfig.background.backgroundColor = .white
			let button = UIButton(configuration: buttonConfig)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.addTarget(self, action: #selector(handleDismiss), for: .touchDown)
			return button
		} else {
			let button = UIButton()
			button.setAttributedTitle(NSMutableAttributedString().flashButtonTextAttributes(string: "Continue"), for: .normal)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.layer.cornerRadius = 10.0
			button.layer.backgroundColor = Theme.Dark.FlashButton.background.cgColor
			button.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
			button.addTarget(self, action: #selector(handleDismiss), for: .touchDown)
			return button
		}
	}()
	
	weak var coordinator: MainCoordinator?
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Theme.mainBackground
		
		view.addSubview(warningLabel)
		view.addSubview(warningTitle)
		view.addSubview(dismissButton)
		
		warningTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
		warningTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
		warningTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
		
		warningLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
		warningLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
		warningLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
		
		dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
		dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
		dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10).isActive = true
	}
	
	@objc func handleDismiss() {
		coordinator?.dismiss()
	}
}

