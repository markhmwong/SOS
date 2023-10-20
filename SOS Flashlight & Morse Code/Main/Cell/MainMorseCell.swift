//
//  MainMorseCell.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

struct MainItemBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {

//        view.layer.backgroundColor = UIColor.gray.cgColor
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 10
        if state.isHighlighted || state.isSelected {
            // Set nil to use the inherited tint color of the cell when highlighted or selected
//            background.backgroundColor = nil
            
            if state.isHighlighted {
                // Reduce the alpha of the tint color to 30% when highlighted
                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
            }
        }
        return background
    }
}

struct MainItemConfiguration : UIContentConfiguration {
    var mainItem: MainMorseViewModel.MainItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = MainView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

class MainView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.defaultBlack
        label.textAlignment = .left
        return label
    }()
    

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addSubview(titleLabel)


        
        titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor, constant: -0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 5).isActive = true



        self.configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let config = self.configuration as? MainItemConfiguration else { return }
        self.titleLabel.text = config.mainItem.name

        self.titleLabel.textColor = .defaultBlack

    }
}


class MainCell: UICollectionViewCell {
    
    var item: MainMorseViewModel.MainItem? = nil
    
    var petrolName: String? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let item = item else { return }
        
        switch item.item {
        case .sos:
            var content = SosItemConfiguration().updated(for: state)
            content.mainItem = item
            contentConfiguration = content
        case .messageConversion:
            var content = MessageConversionConfiguration().updated(for: state)
            content.mainItem = item
            contentConfiguration = content
        case .tools:
            var content = ToolConfiguration().updated(for: state)
            content.mainItem = item
            contentConfiguration = content
        case .morseConversion:
            var content = ConversionConfiguration().updated(for: state)
            content.mainItem = item
            contentConfiguration = content
        }
        
        
        backgroundConfiguration = MainItemBackgroundConfiguration.configuration(for: state)
    }
}
