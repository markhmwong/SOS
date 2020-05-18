//
//  Coordinator.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 14/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

	func start()
}

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		navigationController.delegate = self
		navigationController.navigationBar.isTranslucent = true
		let vc = ViewController(coordinator: self)
		vc.viewModel = ViewControllerViewModel(viewController: vc)
		navigationController.pushViewController(vc, animated: false)
		
		// navigation buttons
		navigationController.navigationBar.isHidden = true
	}
	
	func showInfoCoordinator() {
		
	}
	
	func showShare(textToShare: String = "") {
		let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = navigationController.viewControllers.first?.view
		navigationController.present(activityViewController, animated: true) {
			//
		}
	}
}

// info coordinator (top right)
class InfoCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
	func start() {
		
	}
	
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

class InfoViewController {
	
}
