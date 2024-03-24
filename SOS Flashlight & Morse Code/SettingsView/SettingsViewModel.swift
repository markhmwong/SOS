//
//  SettingsViewModel.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 25/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import StoreKit
import RevenueCat

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
	
	var diffableDatasource: UITableViewDiffableDataSource<SettingsSection, AnyHashable>?
	
	var datasource: [AnyHashable] = []
	
	var datasourceDict: [SettingsSection : [AnyHashable]] = [:]
	
	var settingsViewController: SettingsViewController?
	
	var rowSelected: Int? = nil
	
    var removeAdPackage: Package! = nil
    
	init() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleFailedTransaction), name: .IAPHelperPurchaseCancelledNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulTransaction), name: .IAPHelperPurchaseCompleteNotification, object: nil)
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
		diffableDataSourceSnapshot.appendSections([SettingsSection.main])
		
		diffableDataSourceSnapshot.appendItems(datasourceDict[.main]!, toSection: .main)
        
		diffableDatasource?.apply(diffableDataSourceSnapshot, animatingDifferences: false, completion: { })
        
//         add cell to remove ads
        SubscriptionService.shared.availableProducts { package, error in
            
            var snapshot = self.diffableDatasource?.snapshot()

            snapshot?.insertSections([SettingsSection.noAds], beforeSection: .main)

            guard let package = package, error != nil else {
                print("SettingsViewModel: \(error)")
                let iap = SettingsIAP(name: "Remove Ads", detail: "Not available", section: .noAds, package: nil)
                snapshot?.appendItems([iap], toSection: .noAds)

                self.diffableDatasource?.apply(snapshot!, animatingDifferences: true, completion: { })
                return
            }
            
            let iapArr = package.map { package in
                print("SettingsViewModel: package \(package.storeProduct.localizedTitle)")
                self.removeAdPackage = package // this may cause problems
                return SettingsIAP(name: "\(package.storeProduct.localizedTitle)", section: .noAds, package: package)
            }

            self.datasourceDict = [
                .noAds : iapArr,
            ]

            snapshot?.appendItems(iapArr, toSection: .noAds)

            self.diffableDatasource?.apply(snapshot!, animatingDifferences: true, completion: { })
        }
	}
	
	func configureDiffableDataSource(tableView: UITableView) {
		diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell in
			
			if let tip = item as? SettingsTip {
				return self.cellForRowTip(tableView: tableView, indexPath: indexPath, row: tip)
			}
            
            if let iap = item as? SettingsIAP {
                return self.cellForRowMain(tableView: tableView, indexPath: indexPath, row: iap)
            }
			
			if let main = item as? SettingsMain {
				return self.cellForRowMain(tableView: tableView, indexPath: indexPath, row: main)
			}

			return self.cellForRowDefault(tableView: tableView, indexPath: indexPath, row: SettingsMain(name: "unknown", section: .main))
		})
	}
	
	// cell factory
	func cellForRowTip(tableView: UITableView, indexPath: IndexPath, row: ItemProtocol) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: row.section.cellId, for: indexPath) as! SettingsTipCell
		cell.setupCell(with: row as! SettingsTip, indexPath: indexPath)
		return cell
	}
    
    private func initMainCell(_ tableView: UITableView, item: ItemProtocol) -> SettingsMainCell {
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: item.section.cellId)
        let casted = item as! SettingsMain
        if cell == nil {
            cell = SettingsMainCell(style: .subtitle, reuseIdentifier: item.section.cellId)
        }
        var config = UIListContentConfiguration.subtitleCell()
        cell?.contentConfiguration = config
        config.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        config.text = casted.name
        config.secondaryText = casted.detail ?? ""
        config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell?.contentConfiguration = config
        return cell as! SettingsMainCell
    }
    
    private func initIAPCell(_ tableView: UITableView, item: ItemProtocol) -> SettingsMainCell {
        var cell: SettingsMainCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: item.section.cellId) as? SettingsMainCell
        
        let casted = item as? SettingsIAP
        if cell == nil {
            cell = SettingsMainCell(style: .subtitle, reuseIdentifier: item.section.cellId)
        }
        var config = UIListContentConfiguration.subtitleCell()
        cell?.contentConfiguration = config
        config.textProperties.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        config.text = casted?.name
        config.secondaryText = casted?.detail ?? ""
        config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell?.contentConfiguration = config
        
        cell?.initialiseActivityView()
        cell?.priceLabel.text = "\(casted?.package?.localizedPriceString ?? "n/a")"
        if casted?.package == nil {
            cell?.layer.opacity = 0.3
            cell?.isUserInteractionEnabled = false
        }

        return cell!
    }
	
	func cellForRowMain(tableView: UITableView, indexPath: IndexPath, row: ItemProtocol) -> UITableViewCell {
        
        switch row.section {
        case .main:
            return self.initMainCell(tableView, item: row)
        case .noAds:
            return self.initIAPCell(tableView, item: row)
        }
	}
	
	func cellForRowDefault(tableView: UITableView, indexPath: IndexPath, row: ItemProtocol) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: row.section.cellId, for: indexPath) as! SettingsMainCell
        var config = UIListContentConfiguration.subtitleCell()
        cell.contentConfiguration = config
        config.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        config.text = row.name
		return cell
	}
	
	// MARK: - Handle Transaction Activity
	@objc func handleFailedTransaction() {
//		updateSnapshot()
        print("handleFailedTransaction")
	}
	
	@objc func handleSuccessfulTransaction() {
        print("handleSuccessfulTransaction")
//		updateSnapshot()
		
//		bring up thank you vc
		guard let settingsViewController = settingsViewController else { return }
		settingsViewController.showThankYou()
	}
    
    func purchase(_ cell: SettingsMainCellIAP, vc: SettingsViewController) {
        Purchases.shared.purchase(package: self.removeAdPackage) { storeTransaction, customerInfo, error, state in
            
            if error != nil {
                cell.activityIndicatorDisable()
                // show error
                WarningBox.showCustomAlertBox(title: "\(error?.localizedDescription ?? "Unknown")", message: "\(error?.localizedFailureReason ?? "Some reason")", vc: vc)
            } else {
                // successfully purchased
                WarningBox.showCustomAlertBox(title: "A big thanks!", message: "Purchase complete", vc: vc)
                // update label
                cell.activityIndicatorDisable()
                
                // update local device
                SubscriptionService.shared.buyAdRemovalIAP()
                
                #if DEBUG
                print("successful purchase")
                #endif
            }
        }
    }
    
    func checkExistingPurchases(_ cell: SettingsMainCell) -> Bool {
        return false
    }
}
