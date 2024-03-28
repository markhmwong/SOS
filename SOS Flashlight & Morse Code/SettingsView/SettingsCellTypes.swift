//
//  SettingsCellTypes.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 21/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit
import RevenueCat

protocol ItemProtocol {
	var name: String { get set }
	var section: SettingsSection { get set }
}

struct SettingsTip: Hashable, ItemProtocol {
	var name: String
	var description: String
	var section: SettingsSection
	var price: String
	var tipProduct: SKProduct?
}

struct SettingsMain: Hashable, ItemProtocol {
	var name: String
	var detail: String? = nil
	var section: SettingsSection
    //var package: Package? = nil
}

// currently used for ads
struct SettingsIAP: Hashable, ItemProtocol {
    var name: String
    var detail: String?
    var section: SettingsSection
    var package: Package? = nil
}

enum SettingsSection: Int, CaseIterable {
    case noAds
	case main
    
	var cellId: String {
		switch self {
        case .main:
            return "mainCell"
        case .noAds:
            return "iapCell"
		}
	}
}

//MARK: Tip Cell
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
		contentView.addSubview(tipLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(tipButton)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(spinner)
		tipLabel.anchorView(top: contentView.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		descriptionLabel.anchorView(top: tipLabel.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
		tipButton.anchorView(top: descriptionLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: contentView.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10, right: 0.0), size: .zero)
		spinner.anchorView(top: nil, bottom: nil, leading: tipButton.trailingAnchor, trailing: nil, centerY: tipButton.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setupCell(with data: SettingsTip, indexPath: IndexPath) {
		self.indexPath = indexPath

		DispatchQueue.main.async {
//			self.tipLabel.text = data.name
//			self.tipLabel.textColor = Theme.Font.DefaultColor
			self.tipLabel.attributedText = NSMutableAttributedString().primaryCellTextAttributes(string: data.name)
			self.descriptionLabel.attributedText = NSMutableAttributedString().tertiaryCellTextAttributes(string: data.description)
			self.tipButton.setTitle("\(data.price)", for: .normal)
		}
		
		// cache it
		// setup IAP purchase closure triggered by the button
		buttonHandler = {
			// Start activity spinner
			self.purchaseInProgressActivitySpinner()
			self.tipButton.clearButtonTitle()
			guard let product = data.tipProduct else { return }
//			print("Purchasing --- \(product.localizedTitle)")

			// Purchase product
			IAPProducts.tipStore.buyProduct(product)
		}
	}
	
	@objc func handleTipButton() {
		buttonHandler?()
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

//MARK: Main Cell
class SettingsMainCell: UITableViewCell, SettingsCellPurchaseable {

    func activityIndicatorEnable() {
        activityIndicatorView.startAnimating()
    }
    
    func activityIndicatorDisable() {
        activityIndicatorView.stopAnimating()
    }
    
    func initialiseActivityView() {
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(activityIndicatorView)
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        self.contentView.addSubview(priceLabel)
        self.priceLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        self.priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    internal var activityIndicatorView: UIActivityIndicatorView! = nil
    
    internal lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

protocol SettingsCellPurchaseable {
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var priceLabel: UILabel { get }
    func initialiseActivityView()
    func activityIndicatorEnable()
    func activityIndicatorDisable()
}

extension SettingsCellPurchaseable {
    private var cellPriceLabel: UILabel! {
        return nil
    }

    var priceLabel: UILabel! {
        return cellPriceLabel
    }
}
