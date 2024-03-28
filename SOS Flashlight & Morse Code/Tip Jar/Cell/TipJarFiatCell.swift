//
//  TipJarFiatCell.swift
//  Pump It Up
//
//  Created by Mark Wong on 16/1/2022.
//

import UIKit

//struct TipJarFiatBackgroundConfiguration {
//    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
//        var background = UIBackgroundConfiguration.clear()
//        background.cornerRadius = 10
//        if state.isHighlighted || state.isSelected {
//            if state.isHighlighted {
//                // Reduce the alpha of the tint color to 30% when highlighted
//                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
//            }
//        }
//        return background
//    }
//}
//
//struct TipJarFiatConfiguration : UIContentConfiguration {
//    var item: TipJarViewModel.FiatTipItem! = nil
//
//    
//    func makeContentView() -> UIView & UIContentView {
//        let c = TipJarFiatView(configuration: self)
//        return c
//    }
//    
//    func updated(for state: UIConfigurationState) -> Self {
//        guard let _ = state as? UICellConfigurationState else { return self }
//
//        let updatedConfig = self
//        return updatedConfig
//    }
//}
//
///*
// 
// MARK: - View A
// 
// */
//
//class TipJarFiatView: UIView, UIContentView {
//    var configuration: UIContentConfiguration {
//        didSet {
//            self.configure()
//        }
//    }
//    
//    private var spinner = UIActivityIndicatorView(style: .medium)
//
//    private lazy var tipLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    private lazy var priceLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .regular)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    private lazy var descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
//        label.textAlignment = .left
//        return label
//    }()
//
//    init(configuration: UIContentConfiguration) {
//        self.configuration = configuration
//        super.init(frame: .zero)
//        
//        addSubview(tipLabel)
//        addSubview(priceLabel)
//        addSubview(descriptionLabel)
//
//        tipLabel.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 0).isActive = true
//        tipLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
//
//        priceLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
//        priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        
//        descriptionLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).isActive = true
//        descriptionLabel.topAnchor.constraint(equalTo: tipLabel.bottomAnchor).isActive = true
//        descriptionLabel.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor).isActive = true
//        self.configure()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configure() {
//        guard let config = self.configuration as? TipJarFiatConfiguration else { return }
//        self.tipLabel.text = "\(config.item.name)"
//        self.priceLabel.text = "\(config.item.price)"
//        self.descriptionLabel.text = "\(config.item.tipDescription)"
//    }
//
/*
 
 MARK: - Tip Cell
 
 */
//class TipJarFiatCell: UICollectionViewCell {
//    
//    var item: TipJarViewModel.FiatTipItem? = nil
//    
//    var petrolName: String? {
//        didSet {
//            setNeedsUpdateConfiguration()
//        }
//    }
//    
//    override func updateConfiguration(using state: UICellConfigurationState) {
//        guard let item = item else { return }
//        var content = TipJarFiatConfiguration().updated(for: state)
//        content.item = item
//        contentConfiguration = content
//        
//        backgroundConfiguration = TipJarFiatBackgroundConfiguration.configuration(for: state)
//    }
//}
//
class TipJarFiatCell: UICollectionViewCell {
    
    var item: TipJarViewModel.FiatTipItem? = nil {
        didSet {
            self.configure()
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
    
    private func configure() {
        contentView.backgroundColor = .clear
     
    }
    

}
