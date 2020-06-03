//
//  SettingsCoordinator.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI

// info coordinator (top right)
class SettingsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	var parentNavController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = SettingsViewController(coordinator: self, viewModel: SettingsViewModel())
		let nav = UINavigationController(rootViewController: vc)
		parentNavController = nav
		vc.navigationItem.title = "Settings"
		let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
		back.tintColor = Theme.Font.DefaultColor
		vc.navigationItem.leftBarButtonItem = back
		navigationController.present(nav, animated: true) {
			//
		}
	}
	
	func showMorseCodeSheet() {
		guard let parentNavigationController = parentNavController else { return }
		let codeSheetCoordinator = MorseCodeSheetCoordinator(navigationController: parentNavigationController)
		codeSheetCoordinator.start()
		childCoordinators.append(codeSheetCoordinator)
	}
	
    func showFeedback(_ viewController: MFMailComposeViewController) {
        DispatchQueue.main.async {
			self.parentNavController?.present(viewController, animated: true, completion: nil)
        }
    }
	
	func showAboutPage() {
		guard let parentNavigationController = parentNavController else { return }
		let aboutCoordinator = AboutCoordinator(navigationController: parentNavigationController)
		aboutCoordinator.start()
		childCoordinators.append(aboutCoordinator)
	}
	
	func showThankYou() {
		guard let parentNavigationController = parentNavController else { return }
		let vc = ThankYouViewController(parentCoordinator: self)
		let nav = UINavigationController(rootViewController: vc)
		nav.navigationBar.isHidden = true
		parentNavigationController.present(nav, animated: true) {
			//
		}
	}
	
	@objc func handleDismiss() {
		navigationController.dismiss(animated: true) {
			//
		}
	}
}

