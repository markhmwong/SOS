//
//  MenuBarCell.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 19/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

private extension UICellConfigurationState {
    var menuItem: MenuBarDataSource.MenuItem? {
        set {
            self[.menuItem] = newValue
        }
        get { return self[.menuItem] as? MenuBarDataSource.MenuItem }
    }
}

fileprivate extension UIConfigurationStateCustomKey {
    static let menuItem = UIConfigurationStateCustomKey("com.whizbang.state.menuBarCell")
}

class MenuBarCell: UICollectionViewCell {
//    private var queueManager: QueueManager = QueueManager()

    private var item: MenuBarDataSource.MenuItem? = nil
   
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.menuItem = self.item
        return state
    }

    private let imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = UIColor.defaultText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.defaultText
        label.text = "Unknown"
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .semibold)
        return label
    }()
    
    func configureCell(with item: MenuBarDataSource.MenuItem) {
        guard self.item != item else { return }
        self.item = item
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        setNeedsUpdateConfiguration()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        guard let menuItem = state.menuItem else {
            return
        }
                
        // locally stored data
        let image = UIImage(systemName: menuItem.icon)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        titleLabel.text = menuItem.name
    }
    
    private func setupViewsIfNeeded() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)

        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant:5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5).isActive = true
    }
}
