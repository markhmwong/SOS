//
//  ThankYouViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 3/6/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
	
	var parentCoordinator: SettingsCoordinator?
	
	lazy var emojiBeer: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.attributedText = NSMutableAttributedString().primaryTitleAttributes(string: "🍻")
		return label
	}()
	
	lazy var thankyouMessage: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.attributedText = NSMutableAttributedString().primaryTitleAttributes(string: "Thank You.")
		return label
	}()
	
	lazy var detailedMessage: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
//		label.numberOfLines = 0
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().primaryTextAttributes(string: "Tips help out a lot but don't forget to rate my app!")
		return label
	}()
	
	lazy var reviewButton: UIButton = {
		let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Theme.Dark.tertiary
        config.baseBackgroundColor = Theme.Dark.primary
        config.cornerStyle = .capsule
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
		button.addTarget(self, action: #selector(handleReview), for: .touchDown)
		return button
	}()
	
	lazy var dismissButton: UIButton = {
		let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Theme.Dark.tertiary
        config.baseBackgroundColor = Theme.Dark.primary
        config.cornerStyle = .capsule
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleDismiss), for: .touchDown)
		return button
	}()
	
	init(parentCoordinator: SettingsCoordinator) {
		self.parentCoordinator = parentCoordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Theme.Dark.secondary
		view.addSubview(emojiBeer)
		view.addSubview(thankyouMessage)
		view.addSubview(detailedMessage)
		view.addSubview(reviewButton)
		view.addSubview(dismissButton)
		
		emojiBeer.anchorView(top: nil, bottom: thankyouMessage.topAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: .zero, size: .zero)
		thankyouMessage.anchorView(top: nil, bottom: view.centerYAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: .zero, size: .zero)
        
        detailedMessage.topAnchor.constraint(equalTo: thankyouMessage.bottomAnchor).isActive = true
        detailedMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
		detailedMessage.anchorView(top: thankyouMessage.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		reviewButton.anchorView(top: detailedMessage.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.33, height: 0.0))
		dismissButton.anchorView(top: reviewButton.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.33, height: 0.0))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// not handled in the coordinator since it's just a pop up
	@objc func handleDismiss() {
		dismiss(animated: true, completion: {
			//
		})
	}
	
	@objc func handleReview() {
		let productURL = URL(string: "https://apps.apple.com/app/id1514947015")!
		var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
		
		components?.queryItems = [
			URLQueryItem(name: "action", value: "write-review")
		]
		
		guard let writeReviewURL = components?.url else {
			return
		}
		
		UIApplication.shared.open(writeReviewURL)
	}	
}
