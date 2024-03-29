//
//  SettingsViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import TelemetryClient
import RevenueCat

struct AppMetaData {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    static let name = Bundle.appName()
}

class SettingsViewController: UITableViewController {
	
	private var viewModel: SettingsViewModel?
	
	private var coordinator: SettingsCoordinator
	
	init(coordinator: SettingsCoordinator, viewModel: SettingsViewModel) {
		self.coordinator = coordinator
		self.viewModel = viewModel
		super.init(style: .grouped)
		viewModel.settingsViewController = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.separatorStyle = .none
		
		guard let viewModel = viewModel else { return }
		viewModel.configureDiffableDataSource(tableView: tableView)
		viewModel.prepareDatasource()

		let footerView = FooterView()
		tableView.tableFooterView = footerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        TelemetryManager.send(TelemetryManager.Signal.tipDidShow.rawValue)
	}
	
	
    func emailFeedback() {
        guard let vm = viewModel else {
            return
        }
        
        let mail: MFMailComposeViewController? = MFMailComposeViewController(nibName: nil, bundle: nil)
		guard let mailVc = mail else {
			return
		}
		
        mailVc.mailComposeDelegate = self
        mailVc.setToRecipients([vm.emailToRecipient])
        mailVc.setSubject(vm.emailSubject)
        
        mailVc.setMessageBody(vm.emailBody(), isHTML: true)
        coordinator.showFeedback(mailVc)
    }
	
    func writeReview() {
		let productURL = URL(string: Whizbang.appStoreUrl)!
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
	
	//MARK: - TableView
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		if let section = SettingsSection.init(rawValue: indexPath.section) {
			
			switch section {
            case .main:
                if (indexPath.row == 3) {
                    coordinator.showAboutPage()
                } else if (indexPath.row == 0) {
                    coordinator.showMorseCodeSheet()
                } else if (indexPath.row == 1) {
                    emailFeedback()
                } else if (indexPath.row == 2) {
                    writeReview()
            }
            case .noAds:
                let cell = tableView.cellForRow(at: indexPath) as! SettingsMainCellIAP
                cell.activityIndicatorEnable()
                viewModel?.purchase(cell, vc: self)
			}
		}
	}
	
	func showThankYou() {
		coordinator.showThankYou()
	}

}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}


