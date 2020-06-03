//
//  SettingsCellTypes.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 21/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

protocol SettingsRowHashable {
	var name: String { get set }
	var section: SettingsSection { get set }
}

struct SettingsTip: Hashable, SettingsRowHashable {
	var name: String
	var description: String
	var section: SettingsSection
	var price: String
	var tipProduct: SKProduct?
}

struct SettingsMain: Hashable, SettingsRowHashable {
	var name: String
	var detail: String?
	var section: SettingsSection
}

enum SettingsSection: Int, CaseIterable {
	case tips
	case main
	
	var cellId: String {
		switch self {
			case .tips:
				return "tipCell"
			case .main:
				return "mainCell"
		}
	}
}

class SettingsTipCell: UITableViewCell {
	
	private var spinner = UIActivityIndicatorView(style: .medium)
	
	// title
	private lazy var tipLabel: UILabel = {
		let label = UILabel()
		label.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: "Tip")
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	// button
	private lazy var tipButton: TipButton = {
		let button = TipButton()
		button.setTitle("Tip Button", for: .normal)
		button.addTarget(self, action: #selector(handleTipButton), for: .touchDown)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	// description
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: "Description")
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private var buttonHandler: (() -> ())?
	
	private var indexPath: IndexPath? = nil
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setupCell(with data: SettingsTip, indexPath: IndexPath) {
		self.indexPath = indexPath
		// cache it
		// setup IAP purchase closure triggered by the button
		buttonHandler = {
			// Start activity spinner
			self.purchaseInProgressActivitySpinner()
			self.tipButton.clearButtonTitle()
			guard let product = data.tipProduct else { return }
			print("Purchasing --- \(product.localizedTitle)")
			
			// Purchase product
			IAPProducts.tipStore.buyProduct(product)
		}
		
		self.tipLabel.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: data.name)
		self.descriptionLabel.attributedText = NSMutableAttributedString().tertiaryCellTextAttributes(string: data.description)
		self.tipButton.setTitle("\(data.price)", for: .normal)

		contentView.addSubview(tipLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(tipButton)
		contentView.addSubview(spinner)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		
		tipLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		descriptionLabel.anchorView(top: tipLabel.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
		tipButton.anchorView(top: descriptionLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
		spinner.anchorView(top: nil, bottom: nil, leading: tipButton.trailingAnchor, trailing: nil, centerY: tipButton.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)

	}
	
	@objc func handleTipButton() {
		buttonHandler?()
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
	}

	func purchaseInProgressActivitySpinner() {
		DispatchQueue.main.async {
			self.spinner.startAnimating()
		}
	}
	
	func purchaseCompleteActivitySpinner() {
		DispatchQueue.main.async {
			self.spinner.stopAnimating()
		}
	}
	
}

class SettingsMainCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


