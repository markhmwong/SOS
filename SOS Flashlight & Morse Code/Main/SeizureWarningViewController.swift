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
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var dismissButton: UIButton = {
		let button = UIButton()
		button.setAttributedTitle(NSMutableAttributedString().flashButtonTextAttributes(string: "CLOSE"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 10.0
		button.layer.backgroundColor = Theme.Dark.FlashButton.background.cgColor
		button.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
		button.addTarget(self, action: #selector(handleDismiss), for: .touchDown)
		return button
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
		view.backgroundColor = Theme.Dark.secondary
		
		warningTitle.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "PHOTOSENSITIVE SEIZURE WARNING")
		warningLabel.attributedText = NSMutableAttributedString().secondaryTextAttributes(string: "This app contains flashing lights using the rear camera and front screen. Please stop using this app and consult a doctor if you experience lightheadedness, altered vision, eye or face twitching, jerking or shaking of arms or legs, or basically anything that you shouldn't normally experience; contrary to popular beliefs, these are not symptoms for utter joy but of photosensitive epileptic seizures. Be careful, it's serious.")
		
		view.addSubview(warningLabel)
		view.addSubview(warningTitle)
		view.addSubview(dismissButton)

		warningTitle.anchorView(top: nil, bottom: warningLabel.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0), size: .zero)
		warningLabel.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: view.centerYAnchor, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: -10.0, right: -10.0), size: .zero)
		dismissButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -15.0, right: 0.0), size: .zero)
	}
	
	@objc func handleDismiss() {
		coordinator?.dismiss()
	}
}

