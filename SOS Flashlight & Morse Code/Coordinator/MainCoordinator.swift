//
//  MainCoordinator.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	var rootViewController: MainMorseViewController? = nil
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
    func start(_ cds: CoreDataStack?) {
        guard let cds = cds else { return }
		navigationController.delegate = self
        
        let vm = MainMorseViewModel(cds: cds)
        let vc = MainMorseViewController(viewModel: vm, coordinator: self)
        rootViewController = vc
        
		navigationController.pushViewController(vc, animated: false)
	}
	
	func showSeizureWarning() {
		let vc = SeizureWarningViewController(coordinator: self)
		navigationController.present(vc, animated: true)
	}
	
	func showError(error: TextFieldError) {
		let alert = UIAlertController(title: "You're a little quick..", message: "It's empty", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertAction.Style.default, handler: nil))
		rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	@objc func showSettings() {
		let coordinator = SettingsCoordinator(navigationController: navigationController)
		coordinator.start(nil)
		childCoordinators.append(coordinator)
	}
    
    @objc func showTipJar() {
        let coordinator = TipJarCoordinator(navigationController: navigationController)
        coordinator.start(nil)
        childCoordinators.append(coordinator)
    }
    
    func showInfo(mode: MainMorseViewModel.SOSMode) {
        
        var title = ""
        var descriptionLabel = ""
        var icon = ""
        
        switch mode {
        case .messageConversion:
            title = "Message"
            descriptionLabel = "Have a long message you wish to send through morse? Use this feature to send a longer message."
            icon = "message.and.waveform.fill"
        case .morseConversion:
            title = "Conversion"
            descriptionLabel = "This feature quickly converts english text to morse code symbols."
            icon = "text.bubble.fill"
        case .sos:
            title = "SOS"
            descriptionLabel = "The fastest way to send an SOS. The front screen can also be used as the light source to signal an SOS. Use the bottom right button to switch between the front (screen) and rear (light) of the phone"
            icon = "bolt.fill"
        case .tools:
            title = "Tools"
            descriptionLabel = "Handy tools to easily signal your mates, in either toggle mode or by touch."
            icon = "hammer.fill"
        }
        
        let vc = SOSInfoViewController(title: title, description: descriptionLabel, icon: icon)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.present(vc, animated: true)
    }
	
	/// Show the share panel
	func showShare(textToShare: String = "") {
		let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = navigationController.viewControllers.first?.view
		navigationController.present(activityViewController, animated: true) {
			//
		}
	}
    
    func showSavedMessages(cds: CoreDataStack) {
        let vm = SavedMessagesViewModel(cds: cds)
        let vc = SavedMessagesViewController(vm: vm, coordinator: self)
        let nav = UINavigationController(rootViewController: vc)
        vc.title = "Saved Messages"
        navigationController.present(nav, animated: true)
    }
    
    func showRecentMessages(cds: CoreDataStack) {
        let vm = RecentMessagesViewModel(cds: cds)
        let vc = RecentMessagesViewController(vm: vm, coordinator: self)
        let nav = UINavigationController(rootViewController: vc)
        vc.title = "Recent Messages"
        navigationController.present(nav, animated: true)
    }
	
	func dismiss() {
		navigationController.dismiss(animated: true, completion: nil)
	}
}
