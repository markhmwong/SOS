//
//  SettingsViewModel.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 25/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import StoreKit

class SettingsViewModel {
		
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
	
	// IAP Products
	var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
	
    // Email parameters
	let emailToRecipient = Whizbang.emailToRecipient
	
	let emailSubject: String = Whizbang.emailSubject
	
	let tipProductCache: String = "com.whizbang.sos.tipProducts"
	
    func emailBody() -> String {
        return Whizbang.emailBody
    }
	
	private var diffableDatasource: UITableViewDiffableDataSource<SettingsSection, AnyHashable>?
	
	var datasource: [AnyHashable] = []
	
	var datasourceDict: [SettingsSection : [AnyHashable]] = [:]
	
	var settingsViewController: SettingsViewController?
	
	var rowSelected: Int? = nil
	
	init() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleFailedTransaction), name: .IAPHelperPurchaseCancelledNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulTransaction), name: .IAPHelperPurchaseCompleteNotification, object: nil)
	}

	
	func buttonsNotAvailable() {

		
		datasourceDict[.main] = [
			SettingsMain(name: "Morse Code Sheet", section: .main),
			SettingsMain(name: "Contact", section: .main),
			SettingsMain(name: "Write A Review / Rate", detail: "⭐ Rating my apps helps me a ton! ⭐", section: .main),
			SettingsMain(name: "About", section: .main)
		]
	}
	

	
	func prepareDatasource() {
		datasourceDict = [
			.main : [
						SettingsMain(name: "Morse Code Sheet", section: .main),
						SettingsMain(name: "Contact", section: .main),
						SettingsMain(name: "Write A Review / Rate", detail: "⭐ Rating my apps helps me a ton! ⭐", section: .main),
						SettingsMain(name: "About", section: .main)
					],
		]
		updateSnapshot()
	}
	
	func updateSnapshot() {
		var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<SettingsSection, AnyHashable>()
		diffableDataSourceSnapshot.appendSections(SettingsSection.allCases)
		
		diffableDataSourceSnapshot.appendItems(datasourceDict[.main]!, toSection: .main)
		diffableDatasource?.apply(diffableDataSourceSnapshot, animatingDifferences: false, completion: {
			//
		})
	}
	
	func configureDiffableDataSource(tableView: UITableView) {
		diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, row) -> UITableViewCell in
			
			if let tip = row as? SettingsTip {
				return self.cellForRowTip(tableView: tableView, indexPath: indexPath, row: tip)
			}
			
			if let main = row as? SettingsMain {
				return self.cellForRowMain(tableView: tableView, indexPath: indexPath, row: main)
			}
			
			return self.cellForRowDefault(tableView: tableView, indexPath: indexPath, row: SettingsMain(name: "unknown", section: .main))
		})
	}
	
	// cell factory
	func cellForRowTip(tableView: UITableView, indexPath: IndexPath, row: SettingsRowHashable) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: row.section.cellId, for: indexPath) as! SettingsTipCell

		cell.setupCell(with: row as! SettingsTip, indexPath: indexPath)
		return cell
	}
	
	func cellForRowMain(tableView: UITableView, indexPath: IndexPath, row: SettingsRowHashable) -> UITableViewCell {
		let casted = row as! SettingsMain
		var cell = tableView.dequeueReusableCell(withIdentifier: row.section.cellId)
		
		if cell == nil {
			cell = SettingsMainCell(style: .subtitle, reuseIdentifier: row.section.cellId)
		}
		
		cell?.textLabel?.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: casted.name)
		cell?.detailTextLabel?.attributedText = NSMutableAttributedString().secondaryTextAttributes(string: casted.detail ?? "")
		return cell!
	}
	
	func cellForRowDefault(tableView: UITableView, indexPath: IndexPath, row: SettingsRowHashable) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: row.section.cellId, for: indexPath) as! SettingsMainCell
		cell.textLabel?.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: row.name)
		return cell
	}
	
	// MARK: - Handle Transaction Activity
	@objc func handleFailedTransaction() {
		updateSnapshot()
	}
	
	@objc func handleSuccessfulTransaction() {
		updateSnapshot()
		
//		bring up thank you vc
		guard let settingsViewController = settingsViewController else { return }
		settingsViewController.showThankYou()
	}
}
