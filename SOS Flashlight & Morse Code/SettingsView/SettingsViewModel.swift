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
	let emailToRecipient = Whizbang.shared.emailToRecipient
	
	let emailSubject: String = Whizbang.shared.emailSubject
	
	let tipProductCache: String = "com.whizbang.sos.tipProducts"
	
    func emailBody() -> String {
        return Whizbang.shared.emailBody
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
	
	func grabTipsProducts() {
		
		if let cachedVersionProducts = ProductCache.shared.retrieveCache(for: tipProductCache as NSString) as? [SKProduct] {
			// assume all tip products still exist and retrieve from cache
			self.updateTipButtons(products: cachedVersionProducts)
		} else {
			let networkQueue = DispatchQueue(label: "com.whizbang.sos.networkQueue", qos: .utility)
			networkQueue.sync {
				IAPProducts.tipStore.requestProducts { [weak self] (success, products) in
					guard let self = self, let products = products else { return }

					if (success) {
//						print("successfully retrieved")
						ProductCache.shared.setObject(products as NSArray, forKey: self.tipProductCache as NSString)
						self.updateTipButtons(products: products)
					} else {
						// failed to retrieve products
						 self.buttonsNotAvailable()
					}
				}
			}
		}
    }
	
	func buttonsNotAvailable() {
		datasourceDict[.tips] = [
			SettingsTip(name: "Small Tip", description: "", section: .tips, price: "N/A"),
			SettingsTip(name: "Medium Tip", description: "", section: .tips, price: "N/A"),
			SettingsTip(name: "Big Tip", description: "", section: .tips, price: "N/A"),
			SettingsTip(name: "Astronomical Tip", description: "", section: .tips, price: "N/A"),
		]
		
		datasourceDict[.main] = [
			SettingsMain(name: "Morse Code Sheet", section: .main),
			SettingsMain(name: "Contact", section: .main),
			SettingsMain(name: "Write A Review / Rate", detail: "⭐ Rating my apps helps me a ton! ⭐", section: .main),
			SettingsMain(name: "About", section: .main)
		]
	}
	
	func updateTipButtons(products: [SKProduct]?) {

		datasourceDict[.tips]?.removeAll()
		datasourceDict[.tips] = []

		if let products = products {
			// sort by price
			let sortedByPrice = products.sorted { (productA, productB) -> Bool in
				return productA.price.compare(productB.price) == .orderedAscending
			}
			
			for product in sortedByPrice {
				priceFormatter.locale = product.priceLocale
				if let price = priceFormatter.string(from: product.price) {
					// Price Confirmed
					datasourceDict[.tips]?.append(SettingsTip(name: "\(product.localizedTitle)", description: "\(product.localizedDescription)", section: .tips, price: "\(price)", tipProduct: product))
				} else {
					// No price / Price error / No product
					datasourceDict[.tips]?.append(SettingsTip(name: "\(product.localizedTitle)", description: "\(product.localizedDescription)", section: .tips, price: "N/A"))
				}
			}
		} else {
			datasourceDict[.tips] = [
				SettingsTip(name: "Small Tip", description: "", section: .tips, price: "N/A"),
				SettingsTip(name: "Medium Tip", description: "", section: .tips, price: "N/A"),
				SettingsTip(name: "Big Tip", description: "", section: .tips, price: "N/A"),
				SettingsTip(name: "Astronomical Tip", description: "", section: .tips, price: "N/A"),
			]
		}
		
		if datasourceDict[.main] == nil {
			datasourceDict[.main] = [
				SettingsMain(name: "Morse Code Sheet", section: .main),
				SettingsMain(name: "Contact", section: .main),
				SettingsMain(name: "Write A Review / Rate", detail: "⭐ Rating my apps helps me a ton! ⭐", section: .main),
				SettingsMain(name: "About", section: .main)
			]
		}
		
		DispatchQueue.main.async {
			self.updateSnapshot()
		}
	}
	
	func registerCellids(tableView: UITableView) {
		tableView.register(SettingsTipCell.self, forCellReuseIdentifier: SettingsSection.tips.cellId)
		// registering SettignsMainCell is not required, as the need for a subtitle cell (with a detail label) is necessary
		// we initialise the SettingsMainCell within cellForRowMain
	}
	
	func prepareDatasource() {
		datasourceDict = [
			.tips : [
						SettingsTip(name: "Small Tip", description: "", section: .tips, price: "loading.."),
						SettingsTip(name: "Medium Tip", description: "", section: .tips, price: "loading.."),
						SettingsTip(name: "Big Tip", description: "", section: .tips, price: "loading.."),
						SettingsTip(name: "Astronomical Tip", description: "", section: .tips, price: "loading.."),
					],
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
		diffableDataSourceSnapshot.appendItems(datasourceDict[.tips]!, toSection: .tips)
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
		print("failed transaction")
		updateSnapshot()
	}
	
	@objc func handleSuccessfulTransaction() {
		print("successful")
		updateSnapshot()
		
//		bring up thank you vc
		guard let settingsViewController = settingsViewController else { return }
		settingsViewController.showThankYou()
	}
}
