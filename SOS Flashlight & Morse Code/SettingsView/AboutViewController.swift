//
//  AboutViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 21/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class AboutCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
    func start(_ cds: CoreDataStack?) {
		let vc = AboutViewController(viewModel: AboutViewModel(), coordinator: self)
		navigationController.pushViewController(vc, animated: true)
	}
}

class AboutViewModel: NSObject {
	
	let appDescription: String = "A simple morse code app."
	
	let copyright: String = "Whizbang Apps Copyright \(Calendar.current.currentYearToInt())\nPrivacy Policy - This app uses Telemetry Deck in order for me to track app usage annonymously.\nWarning - This app contains flashing lights using the rear camera and front screen. Please stop using this app and consult a doctor if you experience lightheadedness, altered vision, eye or face twitching, jerking or shaking of arms or legs, or basically anything that you shouldn't normally experience; contrary to popular beliefs, these are not symptoms for utter joy but of photosensitive epileptic seizures. Be careful, it's serious."
	
    let support: String = "Twitter: \(Whizbang.twitter)\nEmail: hello@whizbangapps.xyz"
}

class AboutViewController: BaseViewController<AboutViewModel, AboutCoordinator> {
	
	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().primaryTextAttributes(string: viewModel.appDescription)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var supportLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().primaryTextAttributes(string: viewModel.support)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var copyrightLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.attributedText =  NSMutableAttributedString().tertiaryTitleAttributes(string: viewModel.copyright)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(viewModel: AboutViewModel, coordinator: AboutCoordinator) {
		super.init(viewModel: viewModel, coordinator: coordinator)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(descriptionLabel)
		view.addSubview(copyrightLabel)
		view.addSubview(supportLabel)
		
		descriptionLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: view.centerYAnchor, centerX: view.centerXAnchor, padding: .zero, size: .zero)

        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:5).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        supportLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:5).isActive = true
        supportLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        supportLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        
        copyrightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20).isActive = true
        copyrightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        copyrightLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
	}
}
