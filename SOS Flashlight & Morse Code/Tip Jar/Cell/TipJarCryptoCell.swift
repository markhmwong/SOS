//
//  TipJarCryptoCell.swift
//  Pump It Up
//
//  Created by Mark Wong on 16/1/2022.
//

import UIKit

struct TipJarCryptoBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 10
        if state.isHighlighted || state.isSelected {
            
            if state.isHighlighted {
                // Reduce the alpha of the tint color to 30% when highlighted
                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
            }
        }
        return background
    }
}

struct TipJarCryptoConfiguration : UIContentConfiguration {
    var item: TipJarViewModel.CryptoTipItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = TipJarCryptoView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

/*
 
 MARK: - View A
 
 */

class TipJarCryptoView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }

    private lazy var cryptoWalletLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.numberOfLines = 0
        label.alpha = 1.0
        label.textAlignment = .left
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.numberOfLines = 0
        label.alpha = 1.0
        label.textAlignment = .left
        return label
    }()
    
    //copy label
    private let actionLabel: UILabel = {
        let label = UILabel()
        label.text = "Copy"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.numberOfLines = 0
        label.alpha = 1.0
        label.textAlignment = .right
        return label
    }()


    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addSubview(cryptoWalletLabel)
        addSubview(addressLabel)
        addSubview(actionLabel)

        cryptoWalletLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        cryptoWalletLabel.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 0).isActive = true
        cryptoWalletLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: cryptoWalletLabel.bottomAnchor, constant: 0).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: 0).isActive = true

        actionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
        
        self.configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let config = self.configuration as? TipJarCryptoConfiguration else { return }
        self.cryptoWalletLabel.text = config.item.name
        self.addressLabel.text = config.item.wallet
        self.cryptoWalletLabel.textColor = Theme.mainBackground
        
        self.cryptoWalletLabel.textColor = config.item.color
    }
}

/*
 
 MARK: - Cell
 
 */
class TipJarCryptoCell: UICollectionViewCell {
    
    var item: TipJarViewModel.CryptoTipItem? = nil
    
    var petrolName: String? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let item = item else { return }
        var content = TipJarCryptoConfiguration().updated(for: state)
        content.item = item
        contentConfiguration = content
        
        backgroundConfiguration = TipJarCryptoBackgroundConfiguration.configuration(for: state)
    }
}
