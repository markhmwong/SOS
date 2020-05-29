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
	
	var buttonHandler: (() -> ())?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setupCell(with data: SettingsTip) {
		
		// cache it
		// setup IAP purchase closure triggered by the button
		buttonHandler = {
			guard let product = data.tipProduct else { return }
			IAPProducts.tipStore.buyProduct(product)
		}
		
		tipLabel.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: data.name)
		descriptionLabel.attributedText = NSMutableAttributedString().tertiaryCellTextAttributes(string: data.description)
		tipButton.setTitle("\(data.price)", for: .normal)
		
		contentView.addSubview(tipLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(tipButton)
		
		tipLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		descriptionLabel.anchorView(top: tipLabel.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
		tipButton.anchorView(top: descriptionLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
	}
	
	@objc func handleTipButton() {
		buttonHandler?()
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()

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

class TipButton: UIButton {	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupButton() {
		layer.backgroundColor = Theme.Dark.secondary.cgColor
		layer.cornerRadius = 10.0
		contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		UIView.animate(withDuration: 0.1) {
			self.layer.backgroundColor = Theme.Dark.tertiary.cgColor
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		UIView.animate(withDuration: 0.2) {
			self.layer.backgroundColor = Theme.Dark.secondary.cgColor
		}
	}
}

extension UIButton {
	func setBackgroundColor(_ color: UIColor, for forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}
}
